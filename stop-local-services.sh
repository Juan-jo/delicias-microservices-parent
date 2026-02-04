#!/bin/bash


SERVICES=("delicias-users" "delicias-zones" "delicias-restaurants" "delicias-products")

echo "Deteniendo microservicios..."

for SERVICE in "${SERVICES[@]}"; do
    # Busca el PID (Process ID) basándose en el nombre del servicio
    PID=$(pgrep -f "$SERVICE")

    if [ -z "$PID" ]; then
        echo "⚠️ $SERVICE no parece estar ejecutándose."
    else
        echo "Killing $SERVICE (PID: $PID)..."
        kill -15 $PID  # Intenta un apagado suave (Graceful shutdown)
        sleep 1
    fi
done

echo "Todos los servicios se han detenido."