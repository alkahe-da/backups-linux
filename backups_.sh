#!/bin/bash
clear
shopt -s xpg_echo
#Colores
BLANCO="\033[1;37m"
BLANCO2="\033[1;3;37m"
VERDE="\033[1;32m"
ROJO="\033[1;31m"
ROJO2="\033[1;3;31m"
MORADO="\033[1;3;5;35m"
NARANJA="\033[1;38;5;208m"
AZUL="\033[1;34m"
RT="\033[0m"

function que_hace_esta_app(){
 echo ""
 echo -e "${ROJO}BACKUPS / ${MORADO}Autor:${RT} ANKHAL\n"
 echo -e "${VERDE}Objetivo:${RT} Este programa permite crear backups personalizados en el directorio actual o en uno específico. Los archivos se copian y las carpetas se comprimen con \"7zip\" antes de moverse al destino.\n"
 echo -e "${ROJO}Notas importantes:${RT} Se requiere tener \"7zip\" instalado. Se recomienda crear una carpeta similar a \"Documentos\" para almacenar los backups; de lo contrario, irán a la carpeta \"HOME\". Asegúrate de tener permisos en el directorio de uso.\n"
 echo -e "${AZUL}Recomendaciones:${RT} Para mejor funcionalidad, añade el script a la variable \"\$PATH\" o crea un alias. Puedes eliminar los \"sleeps\" para mayor eficiencia. Para salir, selecciona la opción en el menú.\n"
 echo -e "${NARANJA}Comunidad:${RT} El script es libre para modificar y redistribuir. Se agradecen sugerencias y contribuciones.\n"
 echo -e "${MORADO}Contacto:${RT} julibroo91@gmail.com / github.com/alkahe-da"
 echo ""
 echo "   ${BLANCO2}\"-h\"   \"--help\"    Muestra este mensaje  /  Leer \"FAVOR_LEER\" para más info${RT}"	
}

#Acciona el parámetro "-h, --help", para ayuda con el código
if [[ "$1"  == "-h" || "$1" == "--help" ]]; then
	que_hace_esta_app
	exit 0
fi

#Valida si está instalado 7zip 
probar_7z=$(command -v 7z)
if [[ -z "$probar_7z" ]]; then
 echo -e "${ROJO}BACKUPS${RT} / ${MORADO}Powere By ANKHAL${RT}"
 echo ""
 echo -e "${ROJO}ERROR: ${BLANCO}Por favor instala ${ROJO2}\"7zip\" ${BLANCO}para poder usar este script de manera correcta.
 Ejemplo: "${NARANJA}\"sudo apt install 7zip\" '(Ubuntu)'
 echo ""
 sleep 2
 exit 0
elif [[ -n "$probar_7z" ]]; then

function directorio_destino(){
	 directorios=(~/Documents ~/documents ~/Documentos ~/documentos)

 for directorio in "${directorios[@]}"; do
	if [[ -d "$directorio" ]]; then
		if [[ -d "$directorio/backups_" ]]; then
			destino_back="$directorio/backups_/"
		else
			mkdir "$directorio/backups_"
      		destino_back="$directorio/backups_"
		fi
		break
	fi
 done

 if [[ -z "$destino_back" ]]; then
 	echo -e "${ROJO}NOTA${RT}: ${BLANCO}Como no tienes una carpeta de ${BLANCO2}\"Documentos\" / \"Documents\" \n${BLANCO}Los ${ROJO}archivos ${BLANCO}se guardarán en ${ROJO2}\"$HOME\"${RT}"
	sleep 4
	echo ""
    destino_back="$HOME"
 fi

 echo "$destino_back"
}

function dir_actual(){
 #Menú
 echo ""
 echo "Buscando en directorio actual..."
 echo ""
 sleep 1.5
 ruta_actual=$(pwd)

 #Función busqueda del directorios destino de los backups
 destino_back=$(directorio_destino)

 #Busca los archivos y los copia
 busqueda_find=$(find $ruta_actual -maxdepth 1 -type f) 
 if [ -n "$busqueda_find" ]; then
  echo -e "${ROJO}Archivos ${BLANCO}encontrados en ${BLANCO2}$ruta_actual${RT}"
  echo "$busqueda_find"
  echo ""
  echo -e "${VERDE}  \"y\"${BLANCO}= Para copiar    ${ROJO}\"n\"${BLANCO}= Para negar${RT}"
  find $ruta_actual -maxdepth 1 -type f -ok cp -v {} $destino_back \;
  sleep 1.5
 else
	echo -e "${ROJO}No ${BLANCO}se han encontrado archivos en el directorio ${BLANCO2}~/$busqueda_de_directorio${RT}"
 fi
 
 #Busca los dir y los copia
 busqueda_find_d=$(find $ruta_actual -maxdepth 1 -type d -not -path $ruta_actual -not -path ".")
 if [ -n "$busqueda_find_d" ]; then
    echo ""
	echo -e "${ROJO}Directorios ${BLANCO}encontrados en ${BLANCO2}$ruta_actual${RT}"
	echo "$busqueda_find_d"
	echo ""
    echo -e "${VERDE}  \"y\"${BLANCO}= Para copiar    ${ROJO}\"n\"${BLANCO}= Para negar${RT}"
	find "$ruta_actual" -maxdepth 1 -type d -not -path "$ruta_actual" -not -path "." -ok bash -c '
  dir="{}"; 
  dir_name=$(basename "$dir"); 
  7z a "${2}/${dir_name}.7z" "$dir"
 ' _ {} "$destino_back" \; > /dev/null

	echo ""
 else
	echo -e "${ROJO}No ${BLANCO}se encontraron directorios en el directorio${BLANCO2}$ruta_actual${RT}"
 fi
 #Fin
}

function dir_especifico(){
 #Menú de busqueda
 while true; do
 while true; do
 while true; do
 echo ""
 echo -e "${ROJO}EJEMPLO: ${BLANCO2}Documents/actividades/programing${RT}  ${ROJO}SALIR: ${BLANCO}\"exit\"${RT}"
 echo -e -n "${BLANCO}Por favor ingresa directorio a buscar: ~/${RT}" 
 read busqueda
 if [[ "$busqueda" == "exit"  || "$busqueda" == "Exit"  || "$busqueda" == "EXIT" ]]; then
	echo ""
	echo -e "${ROJO}Saliendo...${RT}"
	sleep 1.5
	exit 0
 fi 
 echo ""
 echo "Buscando en directorio especificado..."
 echo ""
 sleep 2.5

 #Valida la entrada del usuario
 if [ -z $busqueda ]; then
	echo -e "${ROJO}ERROR${BLANCO}: Ingresa un carácter válido!"
	sleep 1.5
 else
	:
	break
 fi
 done

 #Valida si el directorio ingresado existe
  if [ -d ~/$busqueda ]; then
    busqueda_de_directorio="$busqueda"
	break
 else
	echo -e "${BLANCO}El directorio ${BLANCO2}~/$busqueda ${ROJO}!No existe!${RT}"
	sleep 1.5
 fi
 done

 #Función busqueda del directorios destino de los backups
 destino_back=$(directorio_destino)

 #Busca los archivos y los copia
 busqueda_find=$(find ~/$busqueda_de_directorio -maxdepth 1 -type f) 
 if [ -n "$busqueda_find" ]; then
  echo -e "${ROJO}Archivos ${BLANCO}encontrados en ${BLANCO2}~/$busqueda_de_directorio${RT}"
  echo "$busqueda_find"
  echo ""
  echo -e "${VERDE}  \"y\"${BLANCO}= Para copiar    ${ROJO}\"n\"${BLANCO}= Para negar${RT}"
  find ~/$busqueda_de_directorio -maxdepth 1 -type f -ok cp -v {} $destino_back \;
  sleep 1.5
  #break
 else
	echo -e "${ROJO}No ${BLANCO}se han encontrado archivos en el directorio ${BLANCO2}~/$busqueda_de_directorio${RT}"
 fi

 #Busca los directorios y los copia
 busqueda_find_d=$(find ~/$busqueda_de_directorio -maxdepth 1 -type d -not -path ~/$busqueda_de_directorio -not -path ".")
 if [ -n "$busqueda_find_d" ]; then
    echo ""
	echo -e "${ROJO}Directorios ${BLANCO}encontrados en ${BLANCO2}~/$busqueda_de_directorio${RT}"
	echo "$busqueda_find_d"
	echo ""
    echo -e "${VERDE}  \"y\"${BLANCO}= Para copiar    ${ROJO}\"n\"${BLANCO}= Para negar${RT}"
    find ~/$busqueda_de_directorio -maxdepth 1 -type d -not -path ~/$busqueda_de_directorio -not -path "." -ok bash -c '
  dir="{}"; 
  dir_name=$(basename "$dir"); 
  7z a "${2}/${dir_name}.7z" "$dir"
 ' _ {} "$destino_back" \; > /dev/null

	echo ""
	break
 else
	echo -e "${ROJO}No ${BLANCO}se encontraron directorios en el directorio${BLANCO2} ~/$busqueda_de_directorio${RT}"
 fi
 done
 #Acaba
}

echo -e "${ROJO}▄█▀ ▄▄▄▄▄▄▄ ▀█▄
▀████ ███ ████▀
    █▄ █ ▄█	
     █████     -h, --help
     █▀█▀█${RT}"
echo ""
echo -e "    ${ROJO}BACKUPS${RT}
${MORADO}Powere By ANKHAL${RT}"

while true; do
echo ""
echo -e "${BLANCO}Ingresa una opción:${RT} "
echo "1. Buscar en Dir actual
2. Buscar en Dir especifico
3. Salir"
echo -e -n "${ROJO}#? ${RT}" 
read entrada

if [[ $entrada -eq 1 ]]; then
    entrada="1. Buscar en Dir actual"
elif [[ $entrada -eq 2 ]]; then
	entrada="2. Buscar en Dir especifico"
elif [[ $entrada -eq 3 ]]; then
	entrada="3. Salir"
fi

case $entrada in
	"1. Buscar en Dir actual")
	dir_actual
	break
	;;
	"2. Buscar en Dir especifico")
	dir_especifico
	break
	;;
	"3. Salir")
	echo ""
	echo "${ROJO}Saliendo..."
	sleep 1
	break
	exit 0
	;;
	*)
	echo ""
	echo -e "${ROJO}ERROR${RT}: Ingresa una de las opciones"
	sleep 1.5
esac 
done
fi