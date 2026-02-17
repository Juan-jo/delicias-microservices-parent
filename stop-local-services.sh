#!/bin/bash


SERVICES=("delicias-users"
"delicias-zones"
"delicias-restaurants"
"delicias-products"
"delicias-shoppingcart"
)

echo "Stoping services..."

for SERVICE in "${SERVICES[@]}"; do
    # Busca el PID (Process ID) basándose en el nombre del servicio
    PID=$(pgrep -f "$SERVICE")

    if [ -z "$PID" ]; then
        echo "⚠️ $SERVICE are not running."
    else
        echo " -> 💀 Killing $SERVICE (PID: $PID)..."
        kill -15 $PID  # Intenta un apagado suave (Graceful shutdown)
        sleep 1
    fi
done

echo "All services stopped."