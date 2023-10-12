-- This custom test name (custom_test) must be included in the schema.yml file under tests
-- the parameters model & column_name will be passed from the schema.yml file.
{%test custom_test(model, column_name) %}

select *
from {{ model }}
where {{ column_name }} is null

{% endtest %}
