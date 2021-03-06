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
Print_Style "Instalando screen, unzip, sudo, net-tools, wget y otras dependencias..." "$CYAN"
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
##  ##  ##
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update -y
sudo apt-get install php7.4 -y

##  ##  ##
cd /
sudo apt install git -y
sudo git clone https://github.com/Arslanoov/bedrock-admin-panel.git
cd /bedrock-admin-panel


# Agregue la clave GPG oficial de Docker:
Print_Style "Agregando la clave GPG oficial de Docker..." "$BLUE"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

Print_Style "Verificando la clave 0EBF CD88 GPG oficial de Docker..." "$MAGENTA"
sleep 3s
sudo apt-key fingerprint 0EBFCD88


# Configurar el repositorio estable
Print_Style "Configurando el repositorio versión estable..." "$YELLOW"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Instlar Docker Engine
Print_Style "Actualisando el apt índice del paquete..." "$CYAN"
sleep 2s
sudo apt-get update

Print_Style "Instalando la última versión de Docker Engine y containerd..." "$GREEN"
sleep 2s
sudo apt-get install docker-ce docker-ce-cli containerd.io
### ### ###
sudo gpasswd -a ${USER} docker

Print_Style "Instalando Docker Compose..." "$BLACK"
sleep 2s
sudo apt install docker-compose -y
sudo apt install make -y
sudo make init

# Verifique si el directorio principal del servidor de Minecraft ya existe
cd /opt
if [ ! -d "mcpe-data" ]; then
  sudo mkdir mcpe-data
  cd mcpe-data
else
  cd mcpe-data
  if [ -f "bedrock_server" ]; then
    echo "Migración del antiguo servidor Bedrock a minecraftpe/old"
    cd mcpe-data
    sudo mkdir mcpe-data
    mv old sudo mkdir mcpe-data/old
    cd mcpe-data
    echo "Migración completa a cd mcpe-data/old"
  fi
fi

# Configurando Nombre del Servidor: $ServerName
echo "========================================================================="
Print_Style "Ingrese un nombre corto para el servidor nuevo o existente," "$RED"
Print_Style "se utilizará como nombre de la carpeta y el nombre del servicio" "$RED"
echo "========================================================================="
read_with_prompt ServerName "Nombre de Servidor"

echo "========================================================================="


#####if [ ! -d "$ServerName" ]; then
if [ -d "$ServerName" ];
then
Print_Style "¡El directorio minecraftbe/$ServerName ya existe!  Actualizando scripts y configurando el servicio..." "$MAGENTA"
Print_Style "Iniciando Actualización del Servidor Minecraft Bedrock Edition en Docker" "$MAGENTA"
sleep 4s
#-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-Si-

#Verificar si existen containers de servidores Minecraft
echo "========================================================================="
Print_Style "ADVERTECIA: Obteniendo datos de los contenedores, si observa que existen contenedores," "$RED"
Print_Style "deben ser eliminados con el comando: sudo docker container rm nombredelservidor" "$RED"
echo "========================================================================="
read -n1 -r -p "Presione cualquier tecla para continuar"
Print_Style "=========================================================================" "$BLUE"
sudo docker container ps -a
Print_Style "=========================================================================" "$BLUE"
echo "========================================================================="

echo "Para continuar con la instalacion del servidor seleccione No (n)"
echo "Para eliminar algún container existente seleccione Si (y)"
    echo -n "¿Eliminar container existente? (y/n)"
    read answer < /dev/tty
    if [ "$answer" != "${answer#[Yy]}" ]; then
      # Crear copia de seguridad en la nube cloudname
        echo "========================================================================="
        Print_Style "Debes escribir o copiar el Nombre del Container (NAMES) " "$CYAN"
        read_with_prompt NameC "Nombre del container"
        echo "========================================================================="
        Print_Style "Deteniendo container $NameC" "$MAGENTA"
        sudo docker container stop $NameC
        Print_Style "Eliminando container $NameC" "$MAGENTA"
        sudo docker container rm $NameC
        sleep 2s
        echo "========================================================================="
        cd ~
        cd minecraftbe
            if [ ! -d "$NameC" ]; then
            echo "========================================================================="
            Print_Style "No existe directorio para eliminar $NameC" "$MAGENTA"
            echo "========================================================================="
            else
            #sudo rm -rf $NameC
            Print_Style "Buscando directorio $NameC" "$MAGENTA"
        Print_Style "=========================ARCHIVOS Y/O DIRECTORIOS========================" "$MAGENTA"
            ls -l
        Print_Style "=========================ARCHIVOS Y/O DIRECTORIOS========================" "$MAGENTA"
            fi
        sleep 3s
    fi

# Obtener la ruta del directorio de inicio y el nombre de usuario
  DirName=$(readlink -e ~)
  UserName=$(whoami)
  cd ~
  cd minecraftbe
  cd $ServerName
  echo "El directorio del servidor es: $DirName/minecraftbe/$ServerName"
echo "========================================================================="

 # Eliminar scripts existentes
  sudo rm -rf start.sh stop.sh restart.sh cloud.sh back.sh

echo "========================================================================="
sleep 2s

# Descargar start.sh desde el repositorio
 echo "========================================================================="
  echo "Tomando start.sh del repositorio..."
  sudo wget -O start.sh https://raw.githubusercontent.com/digiraldo/Minecraft-BE-Server-Docker/master/start.sh
  sudo chmod +x start.sh
  sudo sed -i "s:dirname:$DirName:g" start.sh
  sudo sed -i "s:servername:$ServerName:g" start.sh

# Descargar config.sh desde el repositorio
 echo "========================================================================="
  echo "Tomando config.sh del repositorio..."
  sudo wget -O config.sh https://raw.githubusercontent.com/digiraldo/Minecraft-BE-Server-Docker/master/config.sh
  sudo chmod +x config.sh
  sudo sed -i "s:dirname:$DirName:g" config.sh
  sudo sed -i "s:servername:$ServerName:g" config.sh

# Haga una copia de seguridad de sus datos
Print_Style "Realizando copia de seguridad de datos $DirName/minecraftbe/$ServerName..." "$GREEN"
sleep 2s
sudo cp -r $DirName/minecraftbe/$ServerName $DirName/minecraftbe/$ServerName.bak

# Salga y elimine el contenedor antiguo
Print_Style "Deteniendo el Servidor..." "$YELLOW"
sleep 2s
sudo docker container stop $ServerName
Print_Style "Eliminando el contenedor antiguo..." "$MAGENTA"
sleep 2s
sudo docker container rm $ServerName

# Inicie un nuevo contenedor
Print_Style "Iniciando nuevo contenedor..." "$BLUE"
sleep 2s
sudo docker run -itd --restart=always --name=$ServerName --net=host \
  -v $DirName/minecraftbe/$ServerName:/data \
  lomot/minecraft-bedrock:1.16.100.04

echo -n "¿Iniciar el servidor de Minecraft automáticamente? (y/n)?"
  read answer < /dev/tty
  if [ "$answer" != "${answer#[Yy]}" ]; then
  #    sudo docker container enable $ServerName
 #   sudo systemctl enable $ServerName.service

    # Reinicio automático configurado a las 4 am
    echo "========================================================================="
    echo -n "¿Reiniciar automáticamente y hacer una copia de seguridad del servidor a las 4 am todos los días? (y/n)"
    read answer < /dev/tty
    if [ "$answer" != "${answer#[Yy]}" ]; then
      croncmd="$DirName/minecraftbe/$ServerName/restart.sh"
      cronjob="0 4 * * * $croncmd"
      ( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
      echo "Reinicio diario programado. Para cambiar la hora o eliminar el reinicio automático, escriba crontab -e"
    fi
  fi

# Gestionar el servidor
echo "========================================================================="
Print_Style "Entrar o salir de la consola de juegos..." "$BLUE"
echo "========================================================================="
Print_Style "Para salir, presione ctrl+p+q" "$CYAN"
echo "========================================================================="
Print_Style "Para matar el proceso, presione ctrl+c o ctrl+d" "$BLUE"
echo "========================================================================="
sleep 3s
sudo docker attach $ServerName

# Gestionar el servidor minecraft (detener / iniciar / reiniciar / eliminar)
echo "================================================================="
echo "================================================================="
echo "================================================================="
Print_Style "Para detener el Servidor: sudo docker container stop $ServerName" "$CYAN"
echo "================================================================="
sleep 2s
Print_Style "Para iniciar el Servidor: sudo docker container start $ServerName" "$MAGENTA"
echo "================================================================="
sleep 2s
Print_Style "Para reiniciar el Servidor: sudo docker container restart $ServerName" "$YELLOW"
echo "================================================================="
echo "================================================================="
echo "================================================================="
sleep 4s
echo "Reiniciando el Servidor:"
sudo docker container restart $ServerName
echo "================================================================="
sleep 2s

cd ~
cd minecraftbe
cd $ServerName

Print_Style "Configuración del Servidor servername..." "$GREEN"
echo "========================================================================="
sudo sed -n "/server-name=/p" server.properties | sed 's/server-name=/Nombre del Servidor: .... /'
sudo sed -n "/level-name=/p" server.properties | sed 's/level-name=/Nombre del Nivel: ....... /'
sudo sed -n "/gamemode=/p" server.properties | sed 's/gamemode=/Modo del Juego: ......... /'
sudo sed -n "/difficulty=/p" server.properties | sed 's/difficulty=/Dificultad del Mundo: ... /'
sudo sed -n "/allow-cheats=/p" server.properties | sed 's/allow-cheats=/Usar Trucos: ............ /'
sudo sed -n "/max-players=/p" server.properties | sed 's/max-players=/Jugadores Máximos: ...... /'
sudo sed -n "/white-list=/p" server.properties | sed 's/white-list=/Permiso de Jugadores: ... /'
sudo sed -n "/level-seed=/p" server.properties | sed 's/level-seed=/Número de Semilla: ...... /'
sudo sed -n "/server-port=/p" server.properties | sed 's/server-port=/Puerto IPV4: ............ /'
sudo sed -n "/server-portv6=/p" server.properties | sed 's/server-portv6=/Puerto IPV6: ............ /'
echo "========================================================================="
sleep 3s

# Iniciando Servidor
Print_Style "Iniciando el Servidor con: docker container start $ServerName" "$BLINK"
sudo docker container start $ServerName


else

Print_Style "Instalando el Servidor de Minecraft Bedrock Edition en Docker" "$MAGENTA"
sleep 4s
#-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-No-

#Verificar si existen containers de servidores Minecraft
echo "========================================================================="
Print_Style "ADVERTECIA: Obteniendo datos de los contenedores, si observa que existen contenedores" "$RED"
Print_Style "de minecraft, deben ser eliminados con el comando: sudo docker container rm nombredelservidor" "$RED"
echo "========================================================================="
read -n1 -r -p "Presione cualquier tecla para continuar"
Print_Style "=========================================================================" "$BLUE"
sudo docker container ps -a
Print_Style "=========================================================================" "$BLUE"
echo "========================================================================="

echo "Para continuar con la instalacion del servidor seleccione No (n)"
echo "Para eliminar algún container existente seleccione Si (y)"
    echo -n "¿Eliminar container existente? (y/n)"
    read answer < /dev/tty
    if [ "$answer" != "${answer#[Yy]}" ]; then
      # eliminar container existente
        echo "========================================================================="
        Print_Style "Debes escribir o copiar el Nombre del Container (NAMES) " "$CYAN"
        read_with_prompt NameC "Nombre del container"
        echo "========================================================================="
        Print_Style "Deteniendo container $NameC" "$MAGENTA"
        sudo docker container stop $NameC
        Print_Style "Eliminando container $NameC" "$MAGENTA"
        sudo docker container rm $NameC
        sleep 2s
        echo "========================================================================="
        sleep 3s
    fi

# Crear directorio de servidor
echo "Creando directorio del servidor de Minecraft (/opt/mcpe-data/$ServerName)..."
sudo mkdir -p /opt/mcpe-data
cd /opt/mcpe-data
sudo mkdir $ServerName
cd $ServerName
# mkdir downloads
sudo mkdir backups
# mkdir logs

# Implementar el servidor
cd ~
Print_Style "Iplementando el Servidor..." "$GREEN"
sleep 2s
sudo docker run -itd --restart=always --name=$ServerName --net=host \
  -v /opt/mcpe-data:/data \
  lomot/minecraft-bedrock:1.16.100.04

# Haga una copia de seguridad de sus datos
Print_Style "Realizando copia de seguridad de datos /opt/mcpe-data..." "$GREEN"
sleep 2s
sudo cp -r /opt/mcpe-data /opt/mcpe-data.bak

# Salga y elimine el contenedor antiguo
Print_Style "Deteniendo el Servidor..." "$YELLOW"
sleep 2s
sudo docker container stop $ServerName
Print_Style "Eliminando el contenedor antiguo..." "$MAGENTA"
sleep 2s
sudo docker container rm $ServerName

# Inicie un nuevo contenedor
Print_Style "Iniciando nuevo contenedor..." "$BLUE"
sleep 2s
sudo docker run -itd --restart=always --name=$ServerName --net=host \
  -v /opt/mcpe-data:/data \
  lomot/minecraft-bedrock:1.16.100.04

### ### ###
Print_Style "Generando permisos a backups y worlds..." "$CYAN"
chmod -R 777 /opt/mcpe-data/backups
chmod -R 777 /opt/mcpe-data/worlds
sleep 2s

sudo service docker stop

echo 'www-data ALL=NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

# Ver la ip del equipo
Print_Style "Direccion IP del Servidor..." "$CYAN"
hostname -I
sleep 3s

# Digitar la ip del equipo
echo "========================================================================="
Print_Style "Introduzca la IP - IPV4 del servidor: " "$BLUE"
read_with_prompt IPV4 "Puerto IPV4 del servidor"
echo "========================================================================="

sudo sh -c "echo '$IPV4' >> /bedrock-admin-panel/web/server.ip"

sudo service docker start

cd /bedrock-admin-panel/web
sudo chmod -R 777 var
sudo docker-compose run --rm php-cli chmod -R 777 /app/data
cd ..
docker-compose up -d
cd web
php generate.php

# Segundo Comando
Print_Style "Copia el enlace que apareció para ingresar desde la web..." "$MAGENTA"
cd /bedrock-admin-panel
nohup php -S 0.0.0.0:57152 -t command/ > /dev/null 2>&1 &

sleep 6s


# Gestionar el servidor
echo "========================================================================="
Print_Style "Entrar o salir de la consola de juegos..." "$BLUE"
echo "========================================================================="
Print_Style "Para salir, presione ctrl+p+q" "$CYAN"
echo "========================================================================="
Print_Style "Para matar el proceso, presione ctrl+c o ctrl+d" "$BLUE"
echo "========================================================================="
sleep 3s
sudo docker attach $ServerName

cd /opt/mcpe-data
cd $ServerName

sleep 2s

# Descargar start.sh desde el repositorio
 echo "========================================================================="
  echo "Tomando start.sh del repositorio..."
  sudo wget -O start.sh https://raw.githubusercontent.com/digiraldo/Minecraft-BE-Server-Docker/master/start.sh
  sudo chmod +x start.sh
  sudo sed -i "s:dirname:$DirName:g" start.sh
  sudo sed -i "s:servername:$ServerName:g" start.sh

# Descargar config.sh desde el repositorio
 echo "========================================================================="
  echo "Tomando config.sh del repositorio..."
  sudo wget -O config.sh https://raw.githubusercontent.com/digiraldo/Minecraft-BE-Server-Docker/master/config.sh
  sudo chmod +x config.sh
  sudo sed -i "s:dirname:$DirName:g" config.sh
  sudo sed -i "s:servername:$ServerName:g" config.sh

# Descargar cloud.sh desde el repositorio
#echo "========================================================================="
#echo "Tomando restart.sh del repositorio..."
#wget -O cloud.sh https://raw.githubusercontent.com/digiraldo/Minecraft-BE-Server-Docker/master/cloud.sh
#chmod +x cloud.sh
#sudo sed -i "s:dirname:$DirName:g" cloud.sh
#sudo sed -i "s/servername/$ServerName/g" cloud.sh

# Descargar back.sh desde el repositorio
#echo "========================================================================="
#  echo "Tomando back.sh del repositorio..."
#  wget -O back.sh https://raw.githubusercontent.com/digiraldo/Minecraft-BE-Server-Docker/master/back.sh
#  chmod +x back.sh
#  sudo sed -i "s:dirname:$DirName:g" back.sh
#  sudo sed -i "s:servername:$ServerName:g" back.sh

cd ~
echo "========================================================================="
echo -n "¿Iniciar el servidor de Minecraft automáticamente? (y/n)?"
read answer < /dev/tty
if [ "$answer" != "${answer#[Yy]}" ]; then
#    sudo docker container enable $ServerName
#  sudo systemctl enable $ServerName.service

  # Reinicio automático a las 4 am
  TimeZone=$(cat /etc/timezone)
  CurrentTime=$(date)
  echo "========================================================================="
  echo "Zona horaria actual del sistema: $TimeZone"
  echo "Hora actual del sistema: $CurrentTime"
  echo "========================================================================="
  sleep 8s
  echo "Puede ajustar / eliminar el tiempo de reinicio seleccionado más tarde escribiendo crontab -e o ejecutando SetupMinecraft.sh nuevamente"
  echo "========================================================================="
  echo -n "¿Reiniciar automáticamente y hacer una copia de seguridad del servidor a las 4 am todos los días? (y/n)"
  read answer < /dev/tty
  if [ "$answer" != "${answer#[Yy]}" ]; then
    croncmd="/opt/mcpe-data/restart.sh"
    cronjob="0 4 * * * $croncmd"
    ( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
    echo "Reinicio diario programado. Para cambiar la hora o eliminar el reinicio automático, escriba crontab -e"
  fi
fi

# Gestionar el servidor minecraft (detener / iniciar / reiniciar / eliminar)
echo "================================================================="
echo "================================================================="
echo "================================================================="
Print_Style "Para detener el Servidor: sudo docker container stop $ServerName" "$CYAN"
echo "================================================================="
sleep 2s
Print_Style "Para iniciar el Servidor: sudo docker container start $ServerName" "$MAGENTA"
echo "================================================================="
sleep 2s
Print_Style "Para reiniciar el Servidor: sudo docker container restart $ServerName" "$YELLOW"
echo "================================================================="
echo "================================================================="
echo "================================================================="
sleep 4s
echo "Reiniciando el Servidor:"
sudo docker container restart $ServerName
echo "================================================================="
sleep 2s

cd /opt/mcpe-data
cd $ServerName

Print_Style "Configuración del Servidor servername..." "$GREEN"
echo "========================================================================="
sudo sed -n "/server-name=/p" server.properties | sed 's/server-name=/Nombre del Servidor: .... /'
sudo sed -n "/level-name=/p" server.properties | sed 's/level-name=/Nombre del Nivel: ....... /'
sudo sed -n "/gamemode=/p" server.properties | sed 's/gamemode=/Modo del Juego: ......... /'
sudo sed -n "/difficulty=/p" server.properties | sed 's/difficulty=/Dificultad del Mundo: ... /'
sudo sed -n "/allow-cheats=/p" server.properties | sed 's/allow-cheats=/Usar Trucos: ............ /'
sudo sed -n "/max-players=/p" server.properties | sed 's/max-players=/Jugadores Máximos: ...... /'
sudo sed -n "/white-list=/p" server.properties | sed 's/white-list=/Permiso de Jugadores: ... /'
sudo sed -n "/level-seed=/p" server.properties | sed 's/level-seed=/Número de Semilla: ...... /'
sudo sed -n "/server-port=/p" server.properties | sed 's/server-port=/Puerto IPV4: ............ /'
sudo sed -n "/server-portv6=/p" server.properties | sed 's/server-portv6=/Puerto IPV6: ............ /'
echo "========================================================================="
sleep 3s

echo "========================================================================="
    echo -n "¿Iniciar Configuracion del Servidor: $ServerName? (y/n)"
    read answer < /dev/tty
    if [ "$answer" != "${answer#[Yy]}" ]; then
      # Crear copia de seguridad en la nube cloudname
        echo "========================================================================="
        echo "Iniciando Configuracion con config.sh"
        echo "========================================================================="
        sleep 3s
        /bin/bash /opt/mcpe-data/config.sh
    fi
echo "========================================================================="

fi

#################################################################################################
#################################################################################################