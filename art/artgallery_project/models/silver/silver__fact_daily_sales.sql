{{
    config(
        materialized='incremental',
        on_schema_change='fail'
        )
}}

with sales as (
    select
        transaction_id,
        artwork_id,
        customer_id,
        gallery_id,
        sale_date::date as sale_date,
        sale_price,
        payment_method,
        load_date
    from {{ ref('bronze__vw_sales_transactions') }}
),

artwork as (  
    select
        artwork_id,
        artist_id
    from {{ ref('bronze__vw_artwork_inventory') }}
),

final as (
    select
        sales.transaction_id,
        sales.sale_date,
        sales.artwork_id,
        artwork.artist_id,
        sales.customer_id,
        sales.gallery_id,
        sales.sale_price,
        sales.payment_method,
        sales.load_date
    from sales
    inner join artwork 
        on sales.artwork_id = artwork.artwork_id
)

select * from final
{% if is_incremental() %}
    where load_date > (select coalesce(max(load_date), '1900-01-01') from {{ this }})
{% endif %}