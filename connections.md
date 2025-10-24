Create a Security Integration in Snowflake for Azure AD

```
CREATE SECURITY INTEGRATION azure_oauth_integration  
  TYPE = OAUTH  
  ENABLED = TRUE  
  OAUTH_CLIENT = 'EXTERNAL'  
  OAUTH_CLIENT_TYPE = 'CONFIDENTIAL'  
  OAUTH_ISSUE_REFRESH_TOKENS = TRUE  
  OAUTH_REFRESH_TOKEN_VALIDITY = 86400  
  OAUTH_REDIRECT_URI = '<YOUR_REDIRECT_URI>'  
  OAUTH_AUTHORIZATION_ENDPOINT = 'https://login.microsoftonline.com/<TENANT_ID>/oauth2/v2.0/authorize'  
  OAUTH_TOKEN_ENDPOINT = 'https://login.microsoftonline.com/<TENANT_ID>/oauth2/v2.0/token'  
  OAUTH_CLIENT_ID = '<APPLICATION_CLIENT_ID>'  
  OAUTH_CLIENT_SECRET = '<APPLICATION_CLIENT_SECRET>';  
```

profiles.yml file
```
my_snowflake_profile:  
  target: dev  
  outputs:  
    dev:  
      type: snowflake  
      account: <account>  
      user: <user>  
      role: <role>  
      database: <database>  
      warehouse: <warehouse>  
      schema: <schema>  
      authenticator: oauth  
      token: "{{ env_var('SNOWFLAKE_OAUTH_ACCESS_TOKEN') }}"

Note: dbt expects an access token (not refresh token) for token:. So, you must obtain an access token using the refresh token in your pipeline.
```

Store secrets (client ID, client secret, refresh token) as Azure DevOps Pipeline secrets/variables.
Use a script to fetch the access token before dbt runs.
Example using curl and jq:
```
# variables from Azure DevOps secrets  
export CLIENT_ID=$(CLIENT_ID)  
export CLIENT_SECRET=$(CLIENT_SECRET)  
export REFRESH_TOKEN=$(REFRESH_TOKEN)  
export TENANT_ID=$(TENANT_ID)  
  
# Get access token from Azure AD  
ACCESS_TOKEN=$(curl -X POST "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token" \  
 -H "Content-Type: application/x-www-form-urlencoded" \  
 -d "grant_type=refresh_token&client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&refresh_token=$REFRESH_TOKEN&scope=https://analysis.windows.net/powerbi/api/.default" \  
 | jq -r '.access_token')  
  
# Export for dbt to pick up  
export SNOWFLAKE_OAUTH_ACCESS_TOKEN=$ACCESS_TOKEN  
```

Example Azure DevOps YAML Pipeline Snippet

```
variables:  
  CLIENT_ID: $(clientId)  
  CLIENT_SECRET: $(clientSecret)  
  REFRESH_TOKEN: $(refreshToken)  
  TENANT_ID: $(tenantId)  
  
steps:  
- script: |  
    ACCESS_TOKEN=$(curl -X POST "https://login.microsoftonline.com/$(TENANT_ID)/oauth2/v2.0/token" \  
     -H "Content-Type: application/x-www-form-urlencoded" \  
     -d "grant_type=refresh_token&client_id=$(CLIENT_ID)&client_secret=$(CLIENT_SECRET)&refresh_token=$(REFRESH_TOKEN)&scope=https://analysis.windows.net/powerbi/api/.default" \  
     | jq -r '.access_token')  
    echo "##vso[task.setvariable variable=SNOWFLAKE_OAUTH_ACCESS_TOKEN]$ACCESS_TOKEN"  
  displayName: 'Get OAuth Access Token'  
  
- script: |  
    dbt run --profiles-dir .  
  displayName: 'Run dbt'  
  env:  
    SNOWFLAKE_OAUTH_ACCESS_TOKEN: $(SNOWFLAKE_OAUTH_ACCESS_TOKEN)  
```
