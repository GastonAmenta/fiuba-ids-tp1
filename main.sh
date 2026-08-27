#!/bin/bash

# Definición de rutas principales
BASE_DIR="$HOME/EPNro1"
ENTRADA_DIR="$BASE_DIR/entrada"
SALIDA_DIR="$BASE_DIR/salida"
PROCESADO_DIR="$BASE_DIR/procesado"
LOG_FILE="$BASE_DIR/procesado.log"
FLAG_FILE="$BASE_DIR/.running"

# Manejo del parámetro optativo -d (Limpieza completa)
if [ "$1" == "-d" ]; then
    echo "--------------------------------------------------"
    echo " Eliminando entorno y deteniendo procesos..."
    echo "--------------------------------------------------"
    rm -f "$FLAG_FILE"
    pkill -f consolidar.sh 2>/dev/null
    rm -rf "$BASE_DIR"
    echo " El entorno ha sido eliminado correctamente."
    echo "--------------------------------------------------"
    exit 0
fi

# Configuración de la variable FILENAME
if [ -z "$FILENAME" ]; then
    FILENAME="alumnos"
fi
OUT_FILE="$SALIDA_DIR/${FILENAME}.txt"

# Función para detener el proceso en segundo plano
stop_background_process() {
    if [ -f "$FLAG_FILE" ]; then
        rm -f "$FLAG_FILE"
        pkill -f consolidar.sh 2>/dev/null
        echo " Proceso en segundo plano detenido."
    fi
}

# Función para mostrar el menú de opciones
show_menu() {
    echo "=================================================="
    echo "           SISTEMA DE GESTIÓN DE ALUMNOS          "
    echo "=================================================="
    echo " 1) Crear entorno"
    echo " 2) Correr proceso"
    echo " 3) Mostrar alumnos ordenados por Padrón"
    echo " 4) Mostrar las 10 notas más altas"
    echo " 5) Buscar alumno por Padrón"
    echo " 6) Visualizar log"
    echo " 7) Salir"
    echo "=================================================="
}

# Bucle principal de la interfaz
while true; do
    show_menu
    read -p " Seleccione una opción [1-7]: " option
    echo ""

    case $option in
        1)
            # Opción 1: Crear estructura de directorios
            mkdir -p "$ENTRADA_DIR" "$SALIDA_DIR" "$PROCESADO_DIR"
            echo "[OK] Entorno creado exitosamente en $BASE_DIR"
            ;;
        2)
            # Opción 2: Iniciar proceso en segundo plano (background)
            if [ ! -d "$BASE_DIR" ]; then
                echo "[ERROR] Primero debe crear el entorno (Opción 1)."
            elif [ -f "$FLAG_FILE" ]; then
                echo "[INFO] El proceso consolidar.sh ya se encuentra en ejecución."
            else
                touch "$FLAG_FILE"
                ./consolidar.sh &
                echo "[OK] Proceso consolidar.sh iniciado en segundo plano."
            fi
            ;;
        3)
            # Opción 3: Listar alumnos ordenados por Padrón
            if [ -f "$OUT_FILE" ]; then
                echo "=================================================="
                echo "       ALUMNOS ORDENADOS POR NÚMERO DE PADRÓN     "
                echo "=================================================="
                sort -n "$OUT_FILE"
            else
                echo "[INFO] El archivo $OUT_FILE aún no existe."
            fi
            ;;
        4)
            # Opción 4: Top 10 notas más altas (Columna 5)
            if [ -f "$OUT_FILE" ]; then
                echo "=================================================="
                echo "            LAS 10 NOTAS MÁS ALTAS               "
                echo "=================================================="
                sort -k5,5nr "$OUT_FILE" | head -n 10
            else
                echo "[INFO] El archivo $OUT_FILE aún no existe."
            fi
            ;;
        5)
            # Opción 5: Búsqueda individual por Padrón
            if [ -f "$OUT_FILE" ]; then
                read -p " Ingrese el número de Padrón a buscar: " padron
                echo "--------------------------------------------------"
                grep "^$padron " "$OUT_FILE" || echo "[INFO] No se encontraron registros para el Padrón $padron."
            else
                echo "[INFO] El archivo $OUT_FILE aún no existe."
            fi
            ;;
        6)
            # Opción 6: Mostrar registro de logs
            if [ -f "$LOG_FILE" ]; then
                echo "=================================================="
                echo "               HISTORIAL DE PROCESAMIENTO         "
                echo "=================================================="
                cat "$LOG_FILE"
            else
                echo "[INFO] El archivo de log aún no ha sido creado."
            fi
            ;;
        7)
            # Opción 7: Salida y limpieza de procesos
            stop_background_process
            echo " Saliendo del sistema..."
            echo "=================================================="
            exit 0
            ;;
        *)
            echo "[ERROR] Opción inválida. Intente nuevamente."
            ;;
    esac
    echo ""
done
