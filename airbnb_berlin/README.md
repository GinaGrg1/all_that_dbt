Allow your IP address as well as from dbt to access snowflake
```
CREATE NETWORK POLICY from_dbt ALLOWED_IP_LIST=('52.3.77.232', '3.214.191.130', '34.233.79.135', '92.233.128.103');
```

Data used are saved in the public S3 bucket:
```
https://dbtlearn.s3.us-east-2.amazonaws.com
```
