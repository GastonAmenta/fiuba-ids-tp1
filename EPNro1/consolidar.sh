#!/bin/bash
#colocamos las variables con el ingreso a las respectivos directorios.
ENTRADA="./entrada"
SALIDA="./salida/FILENAME.txt"
PROCESADO="./procesado"

#bucle demonio en el cual va a correr el scrip en background
while true
do
for archivo in "$ENTRADA"/*.txt; do
   if [[ -f "$archivo" ]]; then
    	cat "$archivo">>"$SALIDA"
   	 mv "$archivo" "$PROCESADO"
   fi
done
sleep 5
done

