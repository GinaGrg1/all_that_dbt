#### Useful commands:
- dbt run [ dbt run --select <model_name>]
- dbt test
- dbt seed
- dbt compile
- dbt snapshot
- dbt source freshness
- dbt deps [ to install packages listed in packages.yml file ]


#### Adding a row for incremental load testing
```
INSERT INTO AIRBNB.RAW.RAW_REVIEWS VALUES 
(3176, CURRENT_TIMESTAMP(), 'Regina', 'Excellent Stay', 'positive');
```

- Ephemeral models are just saved as CTEs. These will not be created when run `dbt run` command.
- The CTEs will be saved in target/run/airbnb_berlin/models/src/ 

- Seeds are local files that you can upload to data warehouse from dbt
- Source is an abstraction layer on the top of your input tables
- Source freshness can be checked automatically
- run `dbt seed` to upload to Snowflake

sources.yml :
Using identifiers in sources.yml file, we can replace this:
```
WITH raw_hosts AS (
    SELECT * FROM AIRBNB.RAW.RAW_HOSTS
)
```
with this:
```
WITH raw_hosts AS (
    SELECT * FROM {{ source('airbnb', 'hosts') }}
)
```

There is also an option to check for source freshness. [ see source.yml file ]
```
        freshness:
          warn_after: {count: 1, period: hour}
          error_after: {count: 24, period: hour}
```
If it doesnt find any fresh data within 1 hour, it will warn. Use the following command
```
$ dbt source freshness
```


### SCD Type 2 [ Snapshots ]
Eg:
```
{% snapshot raw_listings_scd %}

{{
   config(
       target_schema='dev',
       unique_key='id',
       strategy='timestamp',
       updated_at='updated_at',
       invalidate_hard_deletes=True
   )
}}

SELECT * FROM {{ source('airbnb', 'listings') }}

{% endsnapshot %}
```

`UPDATE AIRBNB.RAW.RAW_LISTINGS SET MINIMUM_NIGHTS=30, UPDATED_AT=CURRENT_TIMESTAMP() WHERE ID=3176;`

#### schema.yml file
Define tests in this file. We can also define relationships between tables here.


#### Tests
There are four built-in generic tests:
- unique
- not_null
- accepted_values
- Relationships
You can also create your own custom generic tests or import tests from dbt packages. This will go under tests folder.

#### Macros [ Similar to functions ]


