{% test check_username_invalid_format(model, column_name) %}

    with
        failures as (
            select
                '{{ model }}' as table_name,
                '{{ column_name }}' as column_name,
                'Invalid username format' as issues_type,
                {{ column_name }} as failed_value,
                object_construct(
                    '{{ column_name }}', {{ column_name }}
                ) as record_details
            from {{ model }}
            where
                not regexp_like(
                    {{ column_name }},
                    '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}(\.[0-9]+)*$'
                )
            and 1=2
        )

    select distinct
        'chk_username_format_is_invalid' as unique_code,
        'fail' as status,
        'chk_username_format' as test_name,
        table_name,
        column_name,
        issues_type,
        failed_value,
        record_details,
        current_timestamp as load_timestamp
    from failures

{% endtest %}