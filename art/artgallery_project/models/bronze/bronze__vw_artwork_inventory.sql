select
    *
    ,current_timestamp() AS load_date
from {{ source('gallery_data', 'artwork_inventory') }}