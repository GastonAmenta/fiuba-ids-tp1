#!/bin/bash

# Opcion optativa -d para eliminar todo el entorno y procesos
if [ "$1" = "-d" ]; then
    echo "Eliminando todo..."
    # Eliminamos el archivo bandera para detener consolidar.sh
    rm -f "$HOME/EPNro1/.running"
    # Eliminamos el directorio EPNro1 y todo su contenido
    rm -rf "$HOME/EPNro1"
    echo "Listo!"
    exit 0
fi

# Si la variable FILENAME esta vacia, asignamos el valor "alumnos" por defecto
if [ "$FILENAME" = "" ]; then
    FILENAME="alumnos"
fi

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
            mkdir -p "$HOME/EPNro1/entrada"
            mkdir -p "$HOME/EPNro1/salida"
            mkdir -p "$HOME/EPNro1/procesado"
            echo "Entorno creado en $HOME/EPNro1"
            ;;
            
        2)
            # Iniciar el proceso de consolidacion en segundo plano
            if [ ! -d "$HOME/EPNro1" ]; then
                echo "Primero cree el entorno con la opcion 1"
            else
                if [ -f "$HOME/EPNro1/.running" ]; then
                    echo "El proceso ya esta corriendo"
                else
                    # Creamos el archivo bandera
                    touch "$HOME/EPNro1/.running"
                    # Ejecutamos consolidar.sh en background
                    ./consolidar.sh &
                    echo "Proceso iniciado en background"
                fi
            fi
            ;;
            
        3)
            # Mostrar lista de alumnos ordenada por Padron
            if [ -f "$HOME/EPNro1/salida/$FILENAME.txt" ]; then
                echo "--- Lista por Padron ---"
                sort -n "$HOME/EPNro1/salida/$FILENAME.txt"
            else
                echo "El archivo no existe"
            fi
            ;;
            
        4)
            # Mostrar las 10 notas mas altas (columna 5)
            if [ -f "$HOME/EPNro1/salida/$FILENAME.txt" ]; then
                echo "--- Top 10 Notas ---"
                sort -n -r -k 5 "$HOME/EPNro1/salida/$FILENAME.txt" | head -n 10
            else
                echo "El archivo no existe"
            fi
            ;;
            
        5)
            # Buscar datos de un alumno por su numero de Padron
            if [ -f "$HOME/EPNro1/salida/$FILENAME.txt" ]; then
                read -p "Ingrese Padron: " PADRON
                echo "--- Resultado ---"
                grep "^$PADRON " "$HOME/EPNro1/salida/$FILENAME.txt"
            else
                echo "El archivo no existe"
            fi
            ;;
            
        6)
            # Visualizar el archivo de historial procesado.log
            if [ -f "$HOME/EPNro1/procesado.log" ]; then
                echo "--- Log ---"
                cat "$HOME/EPNro1/procesado.log"
            else
                echo "El log no existe"
            fi
            ;;
            
        7)
            # Preparando el cierre del programa
            echo "Saliendo del programa..."
            # Eliminamos el archivo bandera para detener el script de segundo plano
            rm -f "$HOME/EPNro1/.running"
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
