#!/bin/bash

# Opcion optativa -d para eliminar todo el entorno y procesos (VERSIÓN MEZCLADA)
if [ "$1" = "-d" ]; then
    echo "matando proceso..."
    pkill -f "$HOME/EPNro1/consolidar.sh"
    rm -rf "$HOME/EPNro1/"
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
    echo "1) Crear entorno (con consolidar.sh)"
    echo "2) Correr proceso consolidar.sh en background"
    echo "3) Listado de alumnos por número de padrón"
    echo "4) Listado de alumnos con las 10 notas más altas"
    echo "5) Buscar alumno por Padron"
    echo "6) Visualizar log"
    echo "7) Salir"
    echo "=================================="
    
    read -p "Opcion: " OPCION
    echo ""

    case $OPCION in
        1)
            # Creación del entorno CON el script consolidar.sh (VERSIÓN DEL SEGUNDO CÓDIGO)
            echo "creando entorno..."

            cd "$HOME"
            mkdir -p EPNro1
            cd EPNro1
            mkdir -p entrada
            mkdir -p salida
            mkdir -p procesado

            cat > "$HOME/EPNro1/consolidar.sh" << 'EOF'
#!/bin/bash

while true; do

    for f in "$HOME/EPNro1/entrada"/*.txt; do

        if [ -f "$f" ]; then

            dia=$(date "+%y-%m-%d %H:%M:%S")

            cat "$f" >> "$HOME/EPNro1/salida/$FILENAME.txt"

            mv "$f" "$HOME/EPNro1/procesado"

            echo "$dia,procesado,$f" >> "$HOME/EPNro1/procesado.log"

        fi

    done

done
EOF

            echo "entorno creado correctamente"
            ;;
            
        2)
            # Iniciar el proceso de consolidacion en segundo plano (VERSIÓN DEL SEGUNDO CÓDIGO)
            if [ ! -d "$HOME/EPNro1" ]; then
                echo "Solicite la creacion de un entorno, vaya a la opcion 1"
            else
                chmod +x "$HOME/EPNro1/consolidar.sh"
                "$HOME/EPNro1/consolidar.sh" &
                echo "proceso iniciado."
            fi
            ;;
            
        3)
            # Mostrar lista de alumnos ordenada por Padron (VERSIÓN DEL TERCER CÓDIGO)
            if [ -f "$HOME/EPNro1/salida/$FILENAME.txt" ]; then
                echo "--- Lista por Padron ---"
                cat "$HOME/EPNro1/salida/$FILENAME.txt" | sort -rn
            else
                echo "El archivo FILENAME.txt no existe"
            fi
            ;;
            
        4)
            # Mostrar las 10 notas mas altas (VERSIÓN DEL TERCER CÓDIGO)
            if [ -f "$HOME/EPNro1/salida/$FILENAME.txt" ]; then
                echo "--- Top 10 Notas ---"
                cat "$HOME/EPNro1/salida/$FILENAME.txt" | sort -nr -k 5 | head -n 10
            else
                echo "El archivo FILENAME.txt no existe"
            fi
            ;;
            
        5)
            # Buscar datos de un alumno por su numero de Padron (VERSIÓN MEZCLADA)
            if [ -f "$HOME/EPNro1/salida/$FILENAME.txt" ]; then
                read -p "Ingrese Padron: " PADRON
                echo "--- Resultado ---"
                alumno=$(grep "^$PADRON " "$HOME/EPNro1/salida/$FILENAME.txt")
                if [ -z "$alumno" ]; then
                    echo "El alumno no fue encontrado"
                else
                    echo "$alumno"
                fi
            else
                echo "El archivo no existe"
            fi
            ;;
            
        6)
            # Visualizar el archivo de historial procesado.log (VERSIÓN MEZCLADA)
            if [ -f "$HOME/EPNro1/procesado.log" ]; then
                echo "--- Log ---"
                cat "$HOME/EPNro1/procesado.log"
            else
                echo "El log no existe"
            fi
            ;;
            
        7)
            # Preparando el cierre del programa (VERSIÓN MEZCLADA)
            echo "Saliendo del programa..."
            echo "Estas saliendo del programa"
            exit 0
            ;;
            
        *)
            # Manejo de opciones no validas
            echo "Esta no es una opcion valida"
            ;;
    esac

    echo ""
done