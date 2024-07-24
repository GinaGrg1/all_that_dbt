{%test shoe_size_max_40(model, column_name) %}

with shoe_size_cte as (
  select shoe_size, count(*) as shoe_count
  from {{ model }}
  group by {{ column_name }}
)

select shoe_size, shoe_count
from shoe_size_cte
where shoe_count > 40

{% endtest %}
