### Using the starter project

Useful commands:
- dbt run
- dbt test
- dbt seed
- dbt compile


#### Adding a row for incremental load testing
```
INSERT INTO AIRBNB.RAW.RAW_REVIEWS VALUES 
(3176, CURRENT_TIMESTAMP(), 'Regina', 'Excellent Stay', 'positive');
```

- Ephemeral models are just saved as CTEs. These will not be created when run `dbt run` command. The CTEs will be saved in target/run/dbtlearn/models/src/ 

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
