#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c() {
    echo -e "\n\n${yellowColour}[!]${endColour} ${redColour}Saliendo...${endColour} \n"
    tput cnorm && exit 1
}

# Ctrl+C
trap ctrl_c INT

# Variables Globales

main_url="https://htbmachines.github.io/bundle.js"

function helpPanel(){
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso:${endColour}"
    echo -e "\t${purpleColour}u)${endColour} ${grayColour}Descargar o Actualizar archivos necesarios ${endColour}"
    echo -e "\t${purpleColour}m)${endColour} ${grayColour}Buscar por un nombre de maquina${endColour}"
    echo -e "\t${purpleColour}i)${endColour} ${grayColour}Buscar por direccion IP${endColour}"
    echo -e "\t${purpleColour}y)${endColour} ${grayColour}Obtener link de la resolucion de la maquina en youtube${endColour}"
    echo -e "\t${purpleColour}d)${endColour} ${grayColour}Filtrar por dificultad de una maquina${endColour}"
    echo -e "\t${purpleColour}o)${endColour} ${grayColour}Filtrar por sistema operativo de una maquina${endColour}"
    echo -e "\t${purpleColour}s)${endColour} ${grayColour}Filtrar por skills de una maquina${endColour}"
    echo -e "\t${purpleColour}h)${endColour} ${grayColour}Mostrar este panel de ayuda${endColour}"
}

function updateFiles(){
    tput civis
    
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Comprobando estado de la base de datos${endColour}"
    
    sleep 2
    
    if [ ! -f bundle.js ]; then
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Descargando archivos necesarios...${endColour}"
        curl -s $main_url > bundle.js
        js-beautify bundle.js | sponge bundle.js
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Todos los archivos han sido descargados${endColour}"
    else
        curl -s $main_url > bundle_temp.js
        js-beautify bundle_temp.js | sponge bundle_temp.js
        md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
        md5_original_value=$(md5sum bundle.js | awk '{print $1}')
        
        if [ "$md5_temp_value" == "$md5_original_value" ]; then
            echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Tienes instalada la ultima version${endColour}"
            rm bundle_temp.js
        else
            echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Actualizando archivos...${endColour}"
            sleep 1
            rm bundle.js && mv bundle_temp.js bundle.js
            echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Archivos actualizados${endColour}"
        fi
    fi
    tput cnorm
}

function searchMachine(){
    machineName="$1"
    machineName_checker="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//')"
    
    if [ "$machineName_checker" ]; then
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listando las propiedades de la maquina${endColour} ${purpleColour}$machineName${endColour}${grayColour}\n${endColour}"
        cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//'
    else
        echo -e "\n${redColour}[!]${endColour} ${grayColour}No existe una maquina con ese nombre${endColour}"
    fi
}

function searchIP(){
    ipAddres="$1"
    machineName="$(cat bundle.js | grep "ip: \"$ipAddres\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
    
    if [ "$machineName" ]; then
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}La maquina correspondiente para la IP${endColour} ${blueColour}$ipAddres${endColour} ${grayColour}es${endColour} ${purpleColour}$machineName${endColour}"
    else
        echo -e "\n${redColour}[!]${endColour} ${grayColour}La direccion IP proporcionada no existe${endColour}"
    fi
}

function getYoutubeLink(){
    machineName="$1"
    youtubeLink="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep │  youtube | awk 'NF{print $NF}')"
    
    if [ "$youtubeLink" ]; then
        echo -e "\n${yellowColour}[+]${endColour} ${purpleColour}$machineName${endColour} ${grayColour}->${endColour} ${blueColour}$youtubeLink${endColour}"
    else
        echo -e "\n${redColour}[!]${endColour} ${grayColour}No existe una maquina con ese nombre${endColour}"
    fi
}

function getMachinesDifficulty(){
    difficulty="$1"
    results_check="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
    
    if [ "$results_check" ]; then
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Representando las maquinas que poseen un nivel de dificultad -->${endColour} ${blueColour}$difficulty${endColour}\n"
        cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    else
        echo -e "\n${redColour}[!]${endColour} ${grayColour}Esa dificultad no existe${endColour}"
    fi
}

function getOperationSystem(){
    operation_system="$1"
    results_check="$(cat bundle.js | grep "so: \"$operation_system\"" -B 4 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
    
    if [ "$results_check" ]; then
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Representando las maquinas que poseen sistema operativo -->${endColour} ${blueColour}$operation_system${endColour}\n"
        cat bundle.js | grep "so: \"$operation_system\"" -B 4 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    else
        echo -e "\n${redColour}[!]${endColour} ${grayColour}Ese sistema operativo no existe${endColour}"
    fi
}

function getOsDifficultyMachines(){
    difficulty="$1"
    operation_system="$2"
    osDifficulty_check="$(cat bundle.js | grep "so: \"$operation_system\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
    
    if [ "$osDifficulty_check" ]; then
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Mostrando las maquinas que tengan dificultad:${endColour} ${blueColour}$difficulty${endColour}${grayColour}y sistema operativo:${endColour} ${blueColour}$operation_system${endColour}\n"
        cat bundle.js | grep "so: \"$operation_system\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
    else
        echo -e "\n${redColour}[!]${endColour} ${grayColour}Ese sistema operativo o dificultad no existe${endColour}"
    fi
}

function getSkill (){
    skill="$1"
    
    skill_check="$(cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print$NF}' | tr -d '"' | tr -d ',' | column)"
    
    if [ "$skill_check" ]; then
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Mostrando las maquinas que tengan la skill -->${endColour} ${purpleColour}$skill${endColour}\n"
        cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print$NF}' | tr -d '"' | tr -d ',' | column
    else
        echo -e "\n${redColour}[!]${endColour} ${grayColour}Esa skill indicada no existe${endColour}"
    fi
}

# Indicadores
declare -i parameter_counter=0
declare -i difficulty_flag=0
declare -i os_flag=0

while getopts "m:ui:y:d:o:s:h" arg; do
    case $arg in
        m) machineName="$OPTARG"; let parameter_counter+=1;;
        u) let parameter_counter+=2;;
        i) ipAddres="$OPTARG"; let parameter_counter+=3;;
        y) machineName="$OPTARG"; let parameter_counter+=4;;
        d) difficulty="$OPTARG"; difficulty_flag=1; parameter_counter+=5;;
        o) operation_system="$OPTARG"; os_flag=1; let parameter_counter+=6;;
        s) skill="$OPTARG"; let parameter_counter+=7;;
        h) ;;
    esac
done

if [ $parameter_counter -eq 1 ]; then
    searchMachine $machineName
    elif [ $parameter_counter -eq 2 ]; then
    updateFiles
    elif [ $parameter_counter -eq 3 ]; then
    searchIP $ipAddres
    elif [ $parameter_counter -eq 4 ]; then
    getYoutubeLink $machineName
    elif [ $parameter_counter -eq 5 ]; then
    getMachinesDifficulty $difficulty
    elif [ $parameter_counter -eq 6 ]; then
    getOperationSystem $operation_system
    elif [ $os_flag -eq 1 ] && [ $difficulty_flag -eq 1 ]; then
    getOsDifficultyMachines $difficulty $operation_system
    elif [ $parameter_counter -eq 7 ]; then
    getSkill "$skill"
else
    helpPanel
fi