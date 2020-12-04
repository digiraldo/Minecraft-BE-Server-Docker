#!/bin/bash
# Este Script es para instalar la vesion de LomoHo con traduciones al español
#
# Instrucciones: https://github.com/LomotHo/minecraft-bedrock
# Instrucciones en Español: https://gorobeta.blogspot.com
# Para ejecutar el script de configuración, use:
#
# wget https://raw.githubusercontent.com/digiraldo/Minecraft-BE-Server-Docker/main/DockerMinecraft.sh
# chmod +x DockerMinecraft.sh
# ./DockerMinecraft.sh
#
# Repositorio de GitHub: https://github.com/digiraldo/Minecraft-BE-Server-Docker

echo "Script de instalación de servidor Minecraft PE fundamental en Docker por LomotHo"
# Repositorio de GitHub de LomotHo: https://github.com/LomotHo/minecraft-bedrock
echo "La última versión siempre en https://github.com/LomotHo/minecraft-bedrock"
echo "¡No olvide configurar el reenvío de puertos en su enrutador! El puerto predeterminado es 19132"

# Colores del terminal
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

# Imprime una línea con color usando códigos de terminal
Print_Style() {
  printf "%s\n" "${2}$1${NORMAL}"
}

# Función para leer la entrada del usuario con un mensaje
function read_with_prompt {
  variable_name="$1"
  prompt="$2"
  default="${3-}"
  unset $variable_name
  while [[ ! -n ${!variable_name} ]]; do
    read -p "$prompt: " $variable_name < /dev/tty
    if [ ! -n "`which xargs`" ]; then
      declare -g $variable_name=$(echo "${!variable_name}" | xargs)
    fi
    declare -g $variable_name=$(echo "${!variable_name}" | head -n1 | awk '{print $1;}')
    if [[ -z ${!variable_name} ]] && [[ -n "$default" ]] ; then
      declare -g $variable_name=$default
    fi
    echo -n "$prompt : ${!variable_name} -- aceptar? (y/n)"
    read answer < /dev/tty
    if [ "$answer" == "${answer#[Yy]}" ]; then
      unset $variable_name
    else
      echo "$prompt: ${!variable_name}"
    fi
  done
}

# Instale las dependencias necesarias para ejecutar el servidor de Minecraft en segundo plano
Print_Style "Instalando screen, unzip, sudo, net-tools, wget..." "$CYAN"
if [ ! -n "`which sudo`" ]; then
  apt-get update && apt-get install sudo -y
fi
sudo apt-get update
sudo apt-get install screen unzip wget -y
sudo apt-get install net-tools -y
sudo apt-get install libcurl4 -y
sudo apt-get install openssl -y
sudo apt-get install apt-transport-https -y
sudo apt-get install ca-certificates -y
sudo apt-get install curl
sudo apt-get install gnupg-agent
sudo apt-get install software-properties-common

# Agregue la clave GPG oficial de Docker:
Print_Style "Agregando la clave GPG oficial de Docker..." "$CYAN"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

Print_Style "Verificando la clave 0EBFCD88 GPG oficial de Docker..." "$MAGENTA"
sleep 3s
sudo apt-key fingerprint 0EBFCD88


# Configurar el repositorio estable
Print_Style "Configurando el repositorio versión estable..." "$YELLOW"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# INSTALAR DOCKER ENGINE
Print_Style "Actualisando el apt índice del paquete..." "$CYAN"
sleep 2s
sudo apt-get update

Print_Style "Instalando la última versión de Docker Engine y containerd..." "$CYAN"
sleep 2s
sudo apt-get install docker-ce docker-ce-cli containerd.io