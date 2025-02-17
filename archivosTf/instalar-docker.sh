#!/bin/bash
# Actualizar el sistema
sudo apt-get update -y

# Instalar las dependencias necesarias
sudo apt-get install -y unzip curl apt-transport-https ca-certificates curl software-properties-common

# Descargar el instalador de AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# Descomprimir el archivo descargado
unzip awscliv2.zip
# Ejecutar el instalador de AWS CLI
sudo ./aws/install

# Agregar la clave GPG oficial de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/trusted.gpg.d/docker.asc
# Agregar el repositorio de Docker
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# Actualizar el índice de paquetes
sudo apt-get update -y
# Instalar Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# Verificar que Docker se haya instalado correctamente
sudo systemctl start docker
sudo systemctl enable docker
# Agregar el usuario actual al grupo Docker para usar docker
sudo usermod -aG docker ubuntu

# Crear una red de Docker llamada "my_network"
sudo docker network create my-network