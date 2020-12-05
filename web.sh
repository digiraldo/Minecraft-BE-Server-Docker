#!/bin/bash
# Este Script es para instalar la vesion de LomoHo con traduciones al español
#
# Instrucciones: https://github.com/LomotHo/minecraft-bedrock
# Instrucciones en Español: https://gorobeta.blogspot.com
# Para ejecutar el script de configuración, use:
# wget https://raw.githubusercontent.com/digiraldo/Minecraft-BE-Server-Docker/master/DockerMinecraft.sh
# chmod +x DockerMinecraft.sh
# ./DockerMinecraft.sh
#
# Repositorio de GitHub: https://github.com/digiraldo/Minecraft-BE-Server-Docker

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


sudo apt-get install cpu-checker
# Instalar KMV
#  https://alexariza.net/tutorial/como-instalar-kvm-en-ubuntu-server/

## Codigos de instalacion en la pagina


sudo apt update -y &&
sudo apt upgrade -y &&
sudo apt -y install software-properties-common &&
sudo add-apt-repository ppa:ondrej/php -y &&
sudo apt-get update -y &&

cd / &&
apt install git -y &&
git clone https://github.com/Arslanoov/bedrock-admin-panel.git &&
cd /bedrock-admin-panel &&

apt install docker.io -y &&
sudo gpasswd -a ${USER} docker &&
sudo service docker restart &&

mkdir -p /opt/mcpe-data &&
docker run -itd --restart=always --name=mcpe --net=host \
  -v /opt/mcpe-data:/data \
  lomot/minecraft-bedrock:1.16.100.04 &&

apt install docker-compose -y &&
apt install make -y &&
make init &&

mkdir /opt/mcpe-data/backups && chmod -R 777 /opt/mcpe-data/backups &&
chmod -R 777 /opt/mcpe-data/worlds &&

echo 'www-data ALL=NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo &&

# Ver la ip del equipo
Print_Style "Direccion IP del Servidor..." "$CYAN"
hostname -I
sleep 3s

# Digitar la ip del equipo
echo "========================================================================="
Print_Style "Introduzca la IP - IPV4 del servidor: " "$BLUE"
read_with_prompt IPV4 "Puerto IPV4 del servidor"
echo "========================================================================="

sudo sh -c "echo '$IPV4' >> /bedrock-admin-panel/web/server.ip" &&

sudo apt-get install php7.4 -y &&

cd /bedrock-admin-panel/web &&
chmod -R 777 var &&
docker-compose run --rm php-cli chmod -R 777 /app/data &&
cd .. &&
docker-compose up -d &&
cd web &&
php generate.php

#Second command:

cd /bedrock-admin-panel &&
nohup php -S 0.0.0.0:57152 -t command/ > /dev/null 2>&1 &