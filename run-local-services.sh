#!/bin/bash
#export JAVA_OPTS="-Xms256m -Xmx512m"
export JAVA_OPTS="-Xms64m -Xmx256m -XX:MaxMetaspaceSize=48m -XX:ReservedCodeCacheSize=32m -Xss256k -XX:+UseSerialGC -Dquarkus.jmx.enabled=false"
#export JAVA_OPTS="--Xms256m -Xmx512m -XX:MaxMetaspaceSize=48m -XX:ReservedCodeCacheSize=32m -Xss256k -XX:+UseSerialGC -Dquarkus.jmx.enabled=false"

# Base
export APP_TIMEZONE=America/Mexico_City

# DB
export DB_HOST=localhost
export DB_PORT=5432

export DB_USER=postgres;
export DB_PASSWORD=password;

# Keycloak
export REALM=delicias-app
export AUTH_SERVER_URL=http://localhost:9001
export AUTH_CLIENT_ID=deliciasapp-auth-client

export ADMIN_CLIENT_ID=admin-cli
export ADMIN_CLIENT_SECRET=PP8mW3FCVO2vbC0dsiJFU6A8czcBokvx


# Supabase
export SUPABASE_URL=https://dooexrpqhljvevkhqbjr.supabase.co
export SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRvb2V4cnBxaGxqdmV2a2hxYmpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE4MjI5MTEsImV4cCI6MjA3NzM5ODkxMX0.fhAKkxbiyf2ElTtHHCS75swvgVG5S1FlIb1eLishg-Y
export SUPABASE_BUCKET=delicias

# Client API`s
export CLIENT_API_USERS_URL=http://localhost:3000
export CLIENT_API_ZONES_URL=http://localhost:3001
export CLIENT_API_RESTAURANTS_URL=http://localhost:3002
export CLIENT_API_PRODUCTS_URL=http://localhost:3003;

# Dynamic database
declare -A SERVICE_DATABASES
SERVICE_DATABASES=(
    ["delicias-users"]="delicias_users"
    ["delicias-zones"]="delicias_zones"
    ["delicias-restaurants"]="delicias_restaurants"
    ["delicias-products"]="delicias_products"
    ["delicias-shoppingcart"]="delicias_shoppingcart"
)

SERVICES=(
"delicias-users"
"delicias-zones"
"delicias-restaurants"
"delicias-products"
"delicias-shoppingcart"
)

for SERVICE in "${SERVICES[@]}"; do

    DB_NAME=${SERVICE_DATABASES[$SERVICE]}

    JAR_PATH="./$SERVICE/target/quarkus-app/quarkus-run.jar"

    if [ $? -eq 0 ]; then

      JAR_PATH="./$SERVICE/target/quarkus-app/quarkus-run.jar"

      if [ ! -f "$JAR_PATH" ]; then
        # Si no es fast-jar, buscamos el runner tradicional
        JAR_PATH=$(find ./$SERVICE/target -name "*-runner.jar" | head -n 1)
      fi

        export DB_NAME=$DB_NAME

        echo "🚀 Run $SERVICE with DB $DB_NAME..."
        java -Dquarkus.profile=dev -jar "$JAR_PATH" > "$SERVICE.log" 2>&1 &

      else
            echo "❌ Error of $SERVICE"

    fi


    if [ -z "$JAR_PATH" ]; then
        echo "⚠️ Not found JAR for $SERVICE"
        continue
    fi
done
