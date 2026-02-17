#!/bin/bash

echo -e "🔨 -> Building Delicias Core"
cd delicias-services-core
mvn clean install
cd ..

SERVICES=(
"delicias-users"
"delicias-zones"
"delicias-restaurants"
"delicias-products"
"delicias-shoppingcart"
)

for SERVICE in "${SERVICES[@]}"; do
    echo "🔨 -> Building $SERVICE..."
    (cd ./$SERVICE && mvn clean package -DskipTests)

    # Verificar si el build falló
    if [ $? -ne 0 ]; then
        echo "❌ Error of building $SERVICE. Canceled."
        exit 1
    fi
done

echo "JAR files created correctly. ✅ ✅ ✅ ✅"
echo "---"
