select
    *
from {{ source('gallery_data', 'sales_transactions') }}