This project is using dbt-fusion (2.0.0-preview.44). To fix deprecations first install dbt-autofix
<br>
`pip install dbt-autofix`
<br>
`dbt-autofix deprecations`

<br>
Update Raw tables to include loaded_date
```
ALTER TABLE PROD_RAW.SOURCE_DATA.ARTIST_PROFILES DROP COLUMN loaded_date;  

ALTER TABLE PROD_RAW.SOURCE_DATA.ARTIST_PROFILES
ADD COLUMN loaded_date TIMESTAMP;

UPDATE PROD_RAW.SOURCE_DATA.ARTIST_PROFILES  
SET loaded_date = TO_TIMESTAMP_LTZ(CURRENT_DATE - 1); 
```