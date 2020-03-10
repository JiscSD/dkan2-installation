#!/bin/bash

# update apt
echo -e "\e[34m----------"
echo "DKAN2 Installation: updating up"
echo -e "----------\e[39m"
apt-get update

# install prerequisite packages
echo -e "\e[34m----------"
echo "DKAN2 Installation: installing prerequisite packages"
echo -e "----------\e[39m"
apt install apt-transport-https ca-certificates curl software-properties-common -y

# install nvm
echo -e "\e[34m----------"
echo "DKAN2 Installation: install NVM"
echo -e "----------\e[39m"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
# add to path
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# install node version 12
echo -e "\e[34m----------"
echo "DKAN2 Installation: installing node version 12 LTS"
echo -e "----------\e[39m"
nvm install 12
nvm use 12

# install docker
echo -e "\e[34m----------"
echo "DKAN2 Installation: installing Docker"
echo -e "----------\e[39m"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# add docker repository
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

# update apt-get
apt-get update

# install docker-ce
echo -e "\e[34m----------"
echo "DKAN2 Installation: installing docker-ce"
echo -e "----------\e[39m"
apt install docker-ce -y

usermod -aG docker $1

# install docker compose
echo -e "\e[34m----------"
echo "DKAN2 Installation: installing docker compose"
echo -e "----------\e[39m"
curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

# set permissions
echo -e "\e[34m----------"
echo "DKAN2 Installation: setting permissions of docker-compose"
echo -e "----------\e[39m"
chmod +x /usr/local/bin/docker-compose

export DRUPAL_VERSION=V8

echo -e "\e[34m----------"
echo "DKAN2 Installation: delte dkan-tools if it is already installed"
echo -e "----------\e[39m"
# delete dkan-tools if it already exists
rm -Rf /home/$1/dkan-tools

echo -e "\e[34m----------"
echo "DKAN2 Installation: clone DKAN Tools (dktl)"
echo -e "----------\e[39m"
# clone dkan-tools locally
git clone https://github.com/GetDKAN/dkan-tools.git /home/$1/dkan-tools

echo -e "\e[34m----------"
echo "DKAN2 Installation: delete /usr/local/bin/dktl if exists"
echo -e "----------\e[39m"
# delete symbolic link if it exists
rm -Rf /usr/local/bin/dktl; 

echo -e "\e[34m----------"
echo "DKAN2 Installation: symbolic link between dktl and /usr/local/bin/dktl"
echo -e "----------\e[39m"
ln -s /home/$1/dkan-tools/bin/dktl /usr/local/bin/dktl

# make /var/www if not already there
mkdir -p /var/www

cd /var/www

echo -e "\e[34m----------"
echo "DKAN2 Installation: run nginx container"
echo -e "----------\e[39m"

docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy

echo -e "\e[34m----------"
echo "DKAN2 Installation: dktl init"
echo -e "----------\e[39m"
/usr/local/bin/dktl init

/usr/local/bin/dktl get 8.7.3

/usr/local/bin/dktl make --frontend

echo -e "\e[34m----------"
echo "DKAN2 Installation: dktl updaterush"
echo -e "----------\e[39m"
/usr/local/bin/dktl updatedrush

echo -e "\e[34m----------"
echo "DKAN2 Installation: dktl install"
echo -e "----------\e[39m"
/usr/local/bin/dktl install

echo -e "\e[34m----------"
echo "DKAN2 Installation: drush uli --uri=dkan"
echo -e "----------\e[39m"
/usr/local/bin/dktl drush uli --uri=dkan > /home/$1/dkan-install.txt