#!/bin/bash

# Parametro optativo -d para eliminar el entorno
if [ "$1" = "-d" ]; then
    echo "matando proceso..."
    pkill -f "consolidar.sh"
    rm -rf "$HOME/EPNro1/"
    echo "Listo!"
    exit 0
fi

# Variable de entorno por defecto
if [ "$FILENAME" = "" ]; then
    FILENAME="alumnos"
fi

# Inicializamos la variable de control para la opcion del menu
OPCION=0

# El bucle se ejecuta MIENTRAS la opcion seleccionada NO sea 7
while [ "$OPCION" != "7" ]; do
    echo "=================================="
    echo "1) Crear entorno (con consolidar.sh)"
    echo "2) Correr proceso consolidar.sh"
    echo "3) Listado de alumnos por padron"
    echo "4) Top 10 notas mas altas"
    echo "5) Buscar alumno por padron"
    echo "6) Visualizar log"
    echo "7) Salir"
    echo "=================================="
    
    read -p "Opcion: " OPCION
    echo ""

    case $OPCION in
        1)
        # Creación del entorno CON el script consolidar.sh 
            echo "creando entorno..."

            mkdir -p "$HOME/EPNro1/entrada"
            mkdir -p "$HOME/EPNro1/salida"
            mkdir -p "$HOME/EPNro1/procesado"

            cat > "$HOME/EPNro1/consolidar.sh" << EOF
#!/bin/bash

while true; do
    for f in \$HOME/EPNro1/entrada/*.txt; do
        if [ -f "\$f" ]; then
            FECHA=\$(date +"%d/%m/%Y %H:%M:%S")
            NOMBRE_ARCHIVO=\$(basename "\$f")
            
            cat "\$f" >> \$HOME/EPNro1/salida/${FILENAME}.txt
            mv "\$f" \$HOME/EPNro1/procesado
            
            echo "\$FECHA - Procesado archivo \$NOMBRE_ARCHIVO" >> \$HOME/EPNro1/procesado.log
        fi
    done
    sleep 2
done
EOF
            chmod +x "$HOME/EPNro1/consolidar.sh"
            echo "entorno creado correctamente con FILENAME=$FILENAME"
            ;;
            
        2)
        # Iniciar el proceso de consolidacion en segundo plano
            if [ ! -d "$HOME/EPNro1" ]; then
                echo "Solicite la creacion de un entorno, vaya a la opcion 1"
            else
                "$HOME/EPNro1/consolidar.sh" &
                echo "proceso iniciado."
            fi
            ;;
            
        3)
        # Mostrar lista de alumnos ordenada por Padron
            if [ -f "$HOME/EPNro1/salida/${FILENAME}.txt" ]; then
                echo "--- Lista por Padron ---"
                cat "$HOME/EPNro1/salida/${FILENAME}.txt" | sort -rn
            else
                echo "El archivo ${FILENAME}.txt no existe"
            fi
            ;;
            
        4)
        # Mostrar las 10 notas mas altas
            if [ -f "$HOME/EPNro1/salida/${FILENAME}.txt" ]; then
                echo "--- Top 10 Notas ---"
                cat "$HOME/EPNro1/salida/${FILENAME}.txt" | sort -nr -k 5 | head -n 10
            else
                echo "El archivo ${FILENAME}.txt no existe"
            fi
            ;;
            
        5)
        # Buscar datos de un alumno por su numero de Padron
            if [ -f "$HOME/EPNro1/salida/${FILENAME}.txt" ]; then
                read -p "Ingrese Padron: " PADRON
                echo "--- Resultado ---"
                alumno=$(grep "^$PADRON " "$HOME/EPNro1/salida/${FILENAME}.txt")
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
        # Visualizar el archivo de historial procesado.log 
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
            echo "Chau! До новых встреч!"
            exit 0
            ;;
            
        *)
        # Manejo de opciones no validas
            echo "Esta no es una opcion valida"
            ;;
    esac

    echo ""
done
