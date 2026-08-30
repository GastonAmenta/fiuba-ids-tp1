#!/bin/bash
#asiganamos variables con la direccion de los archivos
SALIDA="./salida/FILENAME.txt"
ENTRADA="./entrada"
CONSOLIDAR="./consolidar.sh"

#creamos la interfaz
echo "============================================"
echo "    BIENVENIDO A LA GESTION DE ALUMNOS		  "
echo "============================================"
echo "1)Listado de alumnos por número de padrón"
echo "2)Listado de alumnos con las 10 notas más altas"
echo "3)Ejecutar el consolidar en background"
echo "*)Salir"

read -p "Ingrese la opcion que quiera elegir: " opcion

#asignamos las funciones de la interfaz
case "$opcion" in
	1)
	if [[ -f "$SALIDA" ]]; then
	  cat "$SALIDA"|sort -rn
	else
	  echo "El archivo FILENAME.txt no existe"
	fi
	;;

	2)
	if [[ -f "$SALIDA" ]]; then
	  cat "$SALIDA"|sort -nr -k 5|head -n 10
	else
	  echo "El archivo FILENAME.txt no existe"
	fi
	;;
	3)
	 "$CONSOLIDAR" &
	;;

	*)
	   exit 0
	   ;;
esac
