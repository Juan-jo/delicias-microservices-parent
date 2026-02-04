#!/bin/bash
#export JAVA_OPTS="-Xms256m -Xmx512m"
export JAVA_OPTS="-Xms64m -Xmx128m -XX:MaxMetaspaceSize=48m -XX:ReservedCodeCacheSize=32m -Xss256k -XX:+UseSerialGC -Dquarkus.jmx.enabled=false"
# Base
export APP_TIMEZONE=America/Mexico_City

# DB
export DB_HOST=localhost
export DB_PORT=5432

export DB_USER=postgres;
export DB_PASSWORD=password;
#DB_NAME=db_zones;

# Keycloak
export REALM=delicias-app
export AUTH_SERVER_URL=http://192.168.101.100:9001
export AUTH_CLIENT_ID=deliciasapp-auth-client

# Supabase
export SUPABASE_URL=https://dooexrpqhljvevkhqbjr.supabase.co
export SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRvb2V4cnBxaGxqdmV2a2hxYmpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE4MjI5MTEsImV4cCI6MjA3NzM5ODkxMX0.fhAKkxbiyf2ElTtHHCS75swvgVG5S1FlIb1eLishg-Y
export SUPABASE_BUCKET=delicias

# Client API`s
export CLIENT_API_USERS_URL=http://localhost:3000
export CLIENT_API_ZONES_URL=http://localhost:3001
export CLIENT_API_RESTAURANTS_URL=http://localhost:3002

# Dynamic database
declare -A SERVICE_DATABASES
SERVICE_DATABASES=(
    ["delicias-users"]="delicias_users"
    ["delicias-zones"]="delicias_zones"
    ["delicias-restaurants"]="delicias_restaurants"
    ["delicias-products"]="delicias_products"
)

#Start Building Jar

echo -e "Building Delicias Core"
cd delicias-services-core
mvn clean install
cd ..


# --- Lista de Microservicios (nombres de las carpetas) ---
SERVICES=("delicias-users" "delicias-zones" "delicias-restaurants" "delicias-products")


# 1. Compilación y empaquetado
echo "Empaquetando proyectos con Maven..."
for SERVICE in "${SERVICES[@]}"; do
    echo "🔨 Construyendo $SERVICE..."
    (cd ./$SERVICE && mvn clean package -DskipTests)

    # Verificar si el build falló
    if [ $? -ne 0 ]; then
        echo "❌ Error al construir $SERVICE. Abortando."
        exit 1
    fi
done

echo "Todos los JARs se generaron correctamente."
echo "---"

# 2. Ejecución de los Microservicios
echo "🏃 Ejecutando servicios en segundo plano..."

for SERVICE in "${SERVICES[@]}"; do

    DB_NAME=${SERVICE_DATABASES[$SERVICE]}

    JAR_PATH="./$SERVICE/target/quarkus-app/quarkus-run.jar"

    if [ $? -eq 0 ]; then
      # IMPORTANTE: En Quarkus el ejecutable correcto es quarkus-run.jar
      JAR_PATH="./$SERVICE/target/quarkus-app/quarkus-run.jar"

      if [ ! -f "$JAR_PATH" ]; then
        # Si no es fast-jar, buscamos el runner tradicional
        JAR_PATH=$(find ./$SERVICE/target -name "*-runner.jar" | head -n 1)
      fi

        export DB_NAME=$DB_NAME

        echo "🚀 Arrancando $SERVICE con DB $DB_NAME..."
        java -jar "$JAR_PATH" > "$SERVICE.log" 2>&1 &

      else
            echo "❌ Falló el build de $SERVICE"

    fi


    if [ -z "$JAR_PATH" ]; then
        echo "⚠️ No se encontró el JAR para $SERVICE"
        continue
    fi
done

echo "🎉 ¡Todos los servicios están arrancando!"
echo "📄 Revisa los archivos .log para ver la salida de cada uno."