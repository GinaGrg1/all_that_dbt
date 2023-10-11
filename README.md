Running dbt using docker

Start Docker

```
/.dbtcontainer $ docker compose up

```

To connect to Mariadb
```
docker exec -it <docker-image-name> mariadb --user root -pmariadb
```
