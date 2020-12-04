# Minecraft Bedrock Edition Server en Docker

## Instalar Servidor Dedicado de Minecraft Bedrock Edition con Docker

Antes de iniciar hay que aclarar que el Servidor dedicado de Minecraft Bedrock Edition, es una versión compatible para jugar desde PC con Minecraft para Windows 10, en consolas las ediciones de PlayStation, XBOX y Nintendo Switch y para dispositivos móviles con sistema operativo iPhone y/o Android (anteriormente Minecraft Pocket Edition). Si deseas saber más sobre la versión puede consultarla aquí: https://translate.google.com/translate?sl=auto&tl=es&u=https://minecraft.gamepedia.com/Bedrock_Edition


## Requisitos Mínimos:
* Una computadora con un procesador x86_64 bit.
* 1 GB de RAM o más
* Ubuntu Server 18.04.2

## Instalación:

Se recomienda usar Ubuntu Server para ejecutar el servidor dedicado de Minecraft. Está disponible aquí: https://ubuntu.com/download/server

Una vez tenga su Computador o Servidor Virtual VPS, Inicie sesión en su servidor Linux usando SSH con un mouse y teclado copie y pegue el siguiente comando:

```
wget https://raw.githubusercontent.com/digiraldo/Minecraft-BE-Server-Docker/master/DockerMinecraft.sh
chmod +x DockerMinecraft.sh
./DockerMinecraft.sh
```