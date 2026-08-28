#!/bin/bash

# Si la variable FILENAME esta vacia, asignamos el valor "alumnos" por defecto
if [ "$FILENAME" = "" ]; then
    FILENAME="alumnos"
fi

# El bucle se ejecuta mientras exista el archivo bandera .running
while [ -f "$HOME/EPNro1/.running" ]; do

    # Verificamos si existe el directorio de entrada
    if [ -d "$HOME/EPNro1/entrada" ]; then
        
        # Iteramos directamente sobre los archivos .txt de la carpeta entrada
        for f in "$HOME/EPNro1/entrada"/*.txt; do
            
            # Comprobamos que el archivo realmente exista
            if [ -f "$f" ]; then
                
                # 1. Anadimos el contenido al archivo de salida correspondiente
                cat "$f" >> "$HOME/EPNro1/salida/$FILENAME.txt"

                # 2. Guardamos la fecha actual y escribimos el registro en procesado.log
                FECHA=$(date +"%d/%m/%Y %H:%M:%S")
                echo "$FECHA - Procesado archivo $f" >> "$HOME/EPNro1/procesado.log"

                # 3. Movemos el archivo procesado al directorio procesado
                mv "$f" "$HOME/EPNro1/procesado/"
            fi
        done
    fi

    # Pausa de 2 segundos antes de volver a verificar
    sleep 2
done
