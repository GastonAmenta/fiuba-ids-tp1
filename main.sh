#!/bin/bash

# Ruta base del entorno EPNro1
BASE="$HOME/EPNro1"

# Opcion optativa -d para eliminar todo el entorno y procesos
if [ "$1" = "-d" ]; then
    echo "Eliminando todo..."
    # Eliminamos el archivo bandera para detener consolidar.sh
    rm -f "$BASE/.running"
    # Eliminamos el directorio EPNro1 y todo su contenido
    rm -rf "$BASE"
    echo "Listo!"
    exit 0
fi

# Si la variable FILENAME esta vacia, asignamos el valor "alumnos" por defecto
if [ "$FILENAME" = "" ]; then
    FILENAME="alumnos"
fi

# Ruta del archivo final consolidado
OUT="$BASE/salida/$FILENAME.txt"

# Inicializamos la variable de control para la opcion del menu
OPCION=0

# El bucle se ejecuta MIENTRAS la opcion seleccionada NO sea 7
while [ "$OPCION" != "7" ]; do
    echo "=================================="
    echo "1) Crear entorno"
    echo "2) Correr proceso"
    echo "3) Mostrar alumnos ordenados por Padron"
    echo "4) Mostrar las 10 notas mas altas"
    echo "5) Buscar alumno por Padron"
    echo "6) Visualizar log"
    echo "7) Salir"
    echo "=================================="
    
    read -p "Opcion: " OPCION
    echo ""

    case $OPCION in
        1)
            # Creacion de la estructura de carpetas
            mkdir -p "$BASE/entrada"
            mkdir -p "$BASE/salida"
            mkdir -p "$BASE/procesado"
            echo "Entorno creado en $BASE"
            ;;
            
        2)
            # Iniciar el proceso de consolidacion en segundo plano
            if [ ! -d "$BASE" ]; then
                echo "Primero cree el entorno con la opcion 1"
            else
                if [ -f "$BASE/.running" ]; then
                    echo "El proceso ya esta corriendo"
                else
                    # Creamos el archivo bandera
                    touch "$BASE/.running"
                    # Ejecutamos consolidar.sh en background
                    ./consolidar.sh &
                    echo "Proceso iniciado en background"
                fi
            fi
            ;;
            
        3)
            # Mostrar lista de alumnos ordenada por Padron
            if [ -f "$OUT" ]; then
                echo "--- Lista por Padron ---"
                sort -n "$OUT"
            else
                echo "El archivo no existe"
            fi
            ;;
            
        4)
            # Mostrar las 10 notas mas altas (columna 5)
            if [ -f "$OUT" ]; then
                echo "--- Top 10 Notas ---"
                sort -n -r -k 5 "$OUT" | head -n 10
            else
                echo "El archivo no existe"
            fi
            ;;
            
        5)
            # Buscar datos de un alumno por su numero de Padron
            if [ -f "$OUT" ]; then
                read -p "Ingrese Padron: " PADRON
                echo "--- Resultado ---"
                grep "^$PADRON " "$OUT"
            else
                echo "El archivo no existe"
            fi
            ;;
            
        6)
            # Visualizar el archivo de historial procesado.log
            if [ -f "$BASE/procesado.log" ]; then
                echo "--- Log ---"
                cat "$BASE/procesado.log"
            else
                echo "El log no existe"
            fi
            ;;
            
        7)
            # Preparando el cierre del programa
            echo "Saliendo del programa..."
            # Eliminamos el archivo bandera para detener el script de segundo plano
            rm -f "$BASE/.running"
            ;;
            
        *)
            # Manejo de opciones no validas
            echo "Opcion invalida"
            ;;
    esac

    echo ""
done

# Mensaje final al romper el bucle tras seleccionar la opcion 7
echo "Успешно вышло, хорошего дня!"
