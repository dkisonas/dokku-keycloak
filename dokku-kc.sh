#!/bin/bash

# Set database config from Dokku's DATABASE_URL
if [ "$DATABASE_URL" != "" ]; then
    echo "[INFO] Found database configuration in DATABASE_URL=$DATABASE_URL"

    # Regex to extract components from DATABASE_URL (postgres://username:password@host:port/database)
    regex='^postgres://([a-zA-Z0-9_-]+):([a-zA-Z0-9]+)@([a-z0-9.-]+):([[:digit:]]+)/([a-zA-Z0-9_-]+)$'
    if [[ $DATABASE_URL =~ $regex ]]; then
        # Extract the missing parts from DATABASE_URL
        db_host=${BASH_REMATCH[3]}
        db_port=${BASH_REMATCH[4]}
        db_name=${BASH_REMATCH[5]}
        
        # Construct KC_DB_URL
        export KC_DB_URL="jdbc:postgresql://$db_host:$db_port/$db_name?currentSchema=${KEYCLOAK_DB_SCHEMA}"
        
        echo "[INFO] KC_DB_URL=$KC_DB_URL"
    else
        echo "[ERROR] Could not parse DATABASE_URL"
        exit 1
    fi
else
    echo "[ERROR] Could not find database configuration in DATABASE_URL variable. Did you properly setup and link postgres?"
    exit 1
fi

# Simply continue with the original entrypoint script
/opt/keycloak/bin/kc.sh start --optimized