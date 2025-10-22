{{
    config(
        materialized='incremental',
        on_schema_change='fail'
        )
}}

with artists as (
    select
        artist_id,
        artist_name,
        artist_tier,
        birth_year,
        country,
        biography,
        load_date
    from {{ ref('bronze__vw_artist_profiles') }}
),

commission_rates as (
    select
        artist_tier,
        commission_rate
    from {{ ref('commission_rates') }}
),

final as (
    select
        artists.artist_id,
        artists.artist_name,
        artists.artist_tier,
        commission_rates.commission_rate,
        artists.birth_year,
        year(current_date()) - artists.birth_year as artist_age,
        artists.country,
        artists.biography,
        artists.load_date
    from artists
    left join commission_rates 
        on artists.artist_tier = commission_rates.artist_tier
)

select * from final
{% if is_incremental() %}
    where load_date > (select coalesce(max(load_date), '1900-01-01') from {{ this }})
{% endif %}