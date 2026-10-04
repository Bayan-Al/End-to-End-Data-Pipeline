{{ config(materialized='view') }}

with source as (
    select * from {{ source('saudi_commercial_data', 'financials_data') }}
),

renamed as (
    select
        -- Primary Identifiers & Keys
        safe_cast(id as int64) as id,
        safe_cast(user_id as string) as user_id,
        safe_cast(encrypted_id as string) as encrypted_id,
        safe_cast(sub as string) as sub,

        -- Names & Descriptions
        nullif(trim(safe_cast(name_ar as string)), 'NA') as name_ar,
        nullif(trim(safe_cast(name_en as string)), 'NA') as name_en,
        nullif(trim(safe_cast(description as string)), 'NA') as description,
        safe_cast(rating as float64) as rating,
        safe_cast(total_reviews as int64) as total_reviews,

        -- Status & Classification
        nullif(trim(safe_cast(certification_status as string)), 'NA') as certification_status,
        nullif(trim(safe_cast(business_type_ar as string)), 'NA') as business_type_ar,
        nullif(trim(safe_cast(business_type_en as string)), 'NA') as business_type_en,
        nullif(trim(safe_cast(business_sub_type_ar as string)), 'NA') as business_sub_type_ar,
        nullif(trim(safe_cast(business_sub_type_en as string)), 'NA') as business_sub_type_en,
        nullif(trim(safe_cast(main_activity as string)), 'NA') as main_activity,

        -- Commercial Record
        nullif(trim(safe_cast(commercial_record_number as string)), 'NA') as commercial_record_number,
        nullif(trim(safe_cast(commercial_record_name as string)), 'NA') as commercial_record_name,

        -- Exchange & Refund Policies
        safe_cast(exchange_refund_policy_has_no_refund_exchange as boolean) as has_no_refund_exchange,
        safe_cast(exchange_refund_policy_refund_days as int64) as refund_days,
        safe_cast(exchange_refund_policy_exchange_days as int64) as exchange_days,
        nullif(trim(safe_cast(exchange_refund_policy_exchange_refund_policy_text as string)), 'NA') as exchange_refund_policy_text,

        -- Contact Information
        nullif(trim(safe_cast(contact_details_email as string)), 'NA') as email,
        nullif(trim(safe_cast(contact_details_mobile as string)), 'NA') as mobile,
        nullif(trim(safe_cast(contact_details_phone as string)), 'NA') as phone,
        nullif(trim(safe_cast(contact_details_customer_service_number as string)), 'NA') as customer_service_number,
        safe_cast(contact_details_is_mobile_used_for_customer_service as boolean) as is_mobile_used_for_customer_service,

        -- Address Information
        nullif(trim(safe_cast(address_city_name as string)), 'NA') as city_name,
        nullif(trim(safe_cast(address_region_name as string)), 'NA') as region_name,
        nullif(trim(safe_cast(address_street_name as string)), 'NA') as street_name,
        nullif(trim(safe_cast(address_district_name as string)), 'NA') as district_name,
        nullif(trim(safe_cast(address_district_id as string)), 'NA') as district_id,
        safe_cast(address_is_private as boolean) as is_address_private,

        -- Freelance Document / License Info
        nullif(trim(safe_cast(free_lance_document_id as string)), 'NA') as freelance_document_id,
        nullif(trim(safe_cast(free_lance_document_license_no as string)), 'NA') as freelance_license_no,
        nullif(trim(safe_cast(free_lance_document_license_status as string)), 'NA') as freelance_license_status,
        safe_cast(free_lance_document_license_issue_date as date) as freelance_license_issue_date,
        safe_cast(free_lance_document_license_expiry_date as date) as freelance_license_expiry_date,
        nullif(trim(safe_cast(free_lance_document_qr_code as string)), 'NA') as freelance_qr_code,
        nullif(trim(safe_cast(free_lance_document_speciality_name as string)), 'NA') as freelance_speciality_name,
        nullif(trim(safe_cast(free_lance_document_category_name as string)), 'NA') as freelance_category_name,

        -- Media & URLs
        nullif(trim(safe_cast(image_url as string)), 'NA') as image_url,
        nullif(trim(safe_cast(other_type_name as string)), 'NA') as other_type_name,

        -- Social Media & Selling Channels
        nullif(trim(safe_cast(facebook_url as string)), 'NA') as facebook_url,
        safe_cast(facebook_selling_channel as boolean) as facebook_selling_channel,
        nullif(trim(safe_cast(instagram_url as string)), 'NA') as instagram_url,
        safe_cast(instagram_selling_channel as boolean) as instagram_selling_channel,
        nullif(trim(safe_cast(twitter_url as string)), 'NA') as twitter_url,
        safe_cast(twitter_selling_channel as boolean) as twitter_selling_channel,
        nullif(trim(safe_cast(apple_store_url as string)), 'NA') as apple_store_url,
        safe_cast(apple_store_selling_channel as boolean) as apple_store_selling_channel,
        nullif(trim(safe_cast(google_play_store_url as string)), 'NA') as google_play_store_url,
        safe_cast(google_play_store_selling_channel as boolean) as google_play_store_selling_channel,
        nullif(trim(safe_cast(whatsapp_url as string)), 'NA') as whatsapp_url,
        safe_cast(whatsapp_selling_channel as boolean) as whatsapp_selling_channel,
        nullif(trim(safe_cast(telegram_url as string)), 'NA') as telegram_url,
        safe_cast(telegram_selling_channel as boolean) as telegram_selling_channel,
        nullif(trim(safe_cast(website_url as string)), 'NA') as website_url,
        safe_cast(website_selling_channel as boolean) as website_selling_channel,
        nullif(trim(safe_cast(snapchat_url as string)), 'NA') as snapchat_url,
        safe_cast(snapchat_selling_channel as boolean) as snapchat_selling_channel,
        nullif(trim(safe_cast(tiktok_url as string)), 'NA') as tiktok_url,
        safe_cast(tiktok_selling_channel as boolean) as tiktok_selling_channel,

        -- System Metadata & Window Function for Deduplication
        safe_cast(_airbyte_extracted_at as timestamp) as extracted_at,
        row_number() over (
            partition by safe_cast(id as int64) 
            order by safe_cast(_airbyte_extracted_at as timestamp) desc
        ) as row_num

    from source
),

deduplicated as (
    select * except (row_num) 
    from renamed 
    where row_num = 1
)

select * from deduplicated