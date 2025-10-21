select
    *
    ,current_timestamp() AS load_date
from {{ source('gallery_data', 'sales_transactions') }}