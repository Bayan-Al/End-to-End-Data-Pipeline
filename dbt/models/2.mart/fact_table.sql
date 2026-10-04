{{ config(materialized='table') }}

with staging as (
    select * from {{ ref('staging_layer') }}
)

select
    id as business_id,
    
    -- Numerical Metrics & Counts
    rating,
    total_reviews,
    refund_days,
    exchange_days,
    
    -- Metadata
    extracted_at

from staging
