#!/bin/bash

# Atualiza o sistema e instala dependências
echo "Adicionando repositório Docker..."
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

echo "Instalando Docker..."
dnf install --nobest docker-ce -y

echo "Habilitando e iniciando o Docker..."
systemctl enable --now docker

echo "Instalando Docker Compose..."
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o docker-compose
mv docker-compose /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "Docker e Docker Compose instalados com sucesso."

# Menu de opções
echo ""
echo "Escolha um projeto para instalar:"
echo "1 - Monitoramento Gubit"
echo "2 - Web Proxy"
echo "3 - Graylog"
echo "4 - Speedtest"
read -p "Digite o número do projeto desejado: " opcao

# Seleção e clonagem do projeto
case $opcao in
  1)
    repo="https://github.com/danielsilvapereira/docker-monitoramento-gubit"
    ;;
  2)
    repo="https://github.com/danielsilvapereira/docker-webproxy"
    ;;
  3)
    repo="https://github.com/danielsilvapereira/docker-graylog"
    ;;
  4)
    repo="https://github.com/danielsilvapereira/docker-speedtest"
    ;;
  *)
    echo "Opção inválida. Saindo."
    exit 1
    ;;
esac

# Clonar e subir o docker-compose
dir=$(basename "$repo")
echo "Clonando repositório $repo ..."
git clone "$repo"

cd "$dir" || { echo "Erro ao entrar no diretório $dir"; exit 1; }

echo "Executando docker-compose up -d ..."
docker compose up -d

echo "Instalação concluída!"
