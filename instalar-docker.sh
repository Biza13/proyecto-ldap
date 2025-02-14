#!/bin/bash
sudo apt update -y
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu
newgrp docker
sudo apt install awscli -y
sudo apt install  git -y
sudo apt install wget -y
# Descargar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Hacer que Docker Compose sea ejecutable
sudo chmod +x /usr/local/bin/docker-compose

