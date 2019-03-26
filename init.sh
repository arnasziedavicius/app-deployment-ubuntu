#!/bin/bash
# ******************************************
# Program: App Init
# Developer: Arnas Ziedavicius
# Date: 26-03-2019
# Environment: Ubuntu
# ******************************************

# Abort on errors
set -e

### Configuration ###

# Home path (no trailing slash)
HOME_PATH=/home/ubuntu
# Folder name where the app will be served from
FOLDER=www
# Username
USER=ubuntu

# Node Version
NVM_V=10.15.1

# Repository URL
if [ ! -z "$1" ]
  then
    # With access token
    REPO_URL=https://$1@github.com/user/repo.git
else
  # With username and password prompt
	REPO_URL=https://github.com/user/repo.git
fi

# Server host2
HOST=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`
# Server port
PORT=3000

# The base URL for the API (Required, no trailing slash)
API_URL=https://cms.app.com
# The base URL for the front-end (Required, no trailing slash)
APP_URL=https://app.com

### Automation steps ###

# Install NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
export NVM_DIR="$HOME_PATH/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# Install Node.js
nvm install $NVM_V

# Install PM2
npm install pm2 -g

# Install Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install -y yarn

# Create app directory and change into it
mkdir $FOLDER
cd $FOLDER

# Clone from repo
git clone $REPO_URL .

# Install app dependencies with Yarn
yarn

# Create environment file and add variables
touch ./.env
echo "API_URL=$API_URL" >> ./.env
echo "APP_URL=$APP_URL" >> ./.env
echo "HOST=$HOST" >> ./.env
echo "PORT=$PORT" >> ./.env

# Build the app
yarn run build

# Setup PM2 server
pm2 start npm --name "app" -- start

# Make sure that PM2 restarts when server restarts
pm2 startup
sudo env PATH=$PATH:$HOME_PATH/.nvm/versions/node/v$NVM_V/bin $HOME_PATH/.nvm/versions/node/v$NVM_V/lib/node_modules/pm2/bin/pm2 startup systemd -u $USER --hp $HOME_PATH

# Change directory back to start
cd .