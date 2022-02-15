#!/bin/bash
set -x

# Variables
USERNAME=ubuntu

# Actualizamos el sistema
apt update

# Descargamos el script
curl -fsSL https://get.docker.com -o get-docker.sh

# Ejecutamos el script
sudo sh get-docker.sh

# Añadimos nuestro usuario al grupo docker
usermod -aG docker $USERNAME

# Actualizamos el grupo docker se hace aparte
#newgrp docker

# Iniciamos el servicio docker
systemctl start docker

# Configuramos para que el servicio se inicie automaticamente
systemctl enable docker
