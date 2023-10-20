#!/usr/bin/bash

# load PG connection variables from .env
source .env

# setup local postgresql db
docker pull postgres
docker run --name $CONTAINER_NAME \
            -e POSTGRES_USER=$PG_USERNAME \
            -e POSTGRES_PASSWORD=$PG_PASSWORD \
            -e POSTGRES_DB=$PG_DB \
            -d -p $PG_PORT:5432 postgres
