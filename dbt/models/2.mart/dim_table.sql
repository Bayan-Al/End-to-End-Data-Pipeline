{{ config(materialized='table') }}

with staging as (
    select * from {{ ref('staging_layer') }}
)

select
    -- Primary Key & Core Identity
    id,
    user_id,
    encrypted_id,
    sub,
    name_ar,
    name_en,
    description,
    certification_status,
    business_type_ar,
    business_type_en,
    business_sub_type_ar,
    business_sub_type_en,
    main_activity,
    other_type_name,
    
    -- Geographic / Location Attributes
    city_name,
    region_name,
    street_name,
    district_name,
    district_id,
    is_address_private,
    
    -- Commercial & License Attributes
    commercial_record_number,
    commercial_record_name,
    freelance_document_id,
    freelance_license_no,
    freelance_license_status,
    freelance_license_issue_date,
    freelance_license_expiry_date,
    freelance_qr_code,
    freelance_speciality_name,
    freelance_category_name,
    
    -- Contact & Social Media Channels
    email,
    mobile,
    phone,
    customer_service_number,
    is_mobile_used_for_customer_service,
    image_url,
    facebook_url,
    facebook_selling_channel,
    instagram_url,
    instagram_selling_channel,
    twitter_url,
    twitter_selling_channel,
    apple_store_url,
    apple_store_selling_channel,
    google_play_store_url,
    google_play_store_selling_channel,
    whatsapp_url,
    whatsapp_selling_channel,
    telegram_url,
    telegram_selling_channel,
    website_url,
    website_selling_channel,
    snapchat_url,
    snapchat_selling_channel,
    tiktok_url,
    tiktok_selling_channel,

    -- Policy Descriptions & Flags
    has_no_refund_exchange,
    exchange_refund_policy_text 

from staging