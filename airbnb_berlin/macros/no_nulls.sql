-- more on adapter : https://docs.getdbt.com/reference/dbt-jinja-functions/adapter

{% macro no_nulls_in_columns(model) %}
    SELECT * FROM {{ model }} WHERE
    
    {% set columns = adapter.get_columns_in_relation(model) %}

    {% for col in columns %}
      {{ col.column }} IS NULL OR
    {% endfor %}
    FALSE -- it is here to terminate the FOR loop..
{% endmacro %}
