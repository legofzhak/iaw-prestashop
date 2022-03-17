#!/bin/bash
set -x

# Variables
USERNAME=ubuntu

# Actualizamos el sistema
apt update

# Descargamos el script de instalación
curl -fsSL https://get.docker.com -o get-docker.sh

# Ejecutamos el script
sh get-docker.sh

# Añadimos nuestro usuario al grupo docker
usermod -aG docker $USERNAME

# Iniciamos el servicio docker
systemctl start docker

# Configuramos para que el servicio se inicie automaticamente
systemctl enable docker

# Instalar Docker Compose
apt install docker-compose -y

# Actualizamos el grupo docker se hace fuera del script
#newgrp docker
