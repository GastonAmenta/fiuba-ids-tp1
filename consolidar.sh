#!/bin/bash

# Definition of base directories
BASE_DIR="$HOME/EPNro1"
ENTRADA_DIR="$BASE_DIR/entrada"
SALIDA_DIR="$BASE_DIR/salida"
PROCESADO_DIR="$BASE_DIR/procesado"
LOG_FILE="$BASE_DIR/procesado.log"
FLAG_FILE="$BASE_DIR/.running"

# Variable de entorno FILENAME (valor por defecto: alumnos)
if [ -z "$FILENAME" ]; then
    FILENAME="alumnos"
fi

OUT_FILE="$SALIDA_DIR/${FILENAME}.txt"

# Bucle de procesamiento mientras exista el archivo bandera
while [ -f "$FLAG_FILE" ]; do

    # Captura de archivos .txt en la carpeta entrada
    shopt -s nullglob
    files=("$ENTRADA_DIR"/*.txt)
    shopt -u nullglob

    if [ ${#files[@]} -gt 0 ]; then
        for file in "${files[@]}"; do
            filename_only=$(basename "$file")

            # 1. Consolidar información en el archivo de salida
            cat "$file" >> "$OUT_FILE"

            # 2. Registrar en el archivo de log con fecha y hora
            timestamp=$(date +"%d/%m/%Y %H:%M:%S")
            echo "$timestamp - Procesado archivo $filename_only" >> "$LOG_FILE"

            # 3. Mover archivo procesado a la carpeta correspondiente
            mv "$file" "$PROCESADO_DIR/"
        done
    fi

    # Pausa de 2 segundos entre verificaciones
    sleep 2
done
