mysql -h 127.0.0.1 -uroot -pmariadb < .dbtcontainer/setup-mariadb.sql
echo 'export DBT_PROFILES_DIR="/workspace"'  >> ~/.bash_profile
