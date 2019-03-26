#!/bin/bash
# ******************************************
# Program: App Update
# Developer: Arnas Ziedavicius
# Date: 26-03-2019
# Environment: Ubuntu
# ******************************************

# Abort on errors
set -e

### Configuration ###

# App directory
APP_FOLDER=www

### Automation steps ###

# Change into app it
cd $APP_FOLDER

# Pull from repo
git pull

# Update app dependencies with Yarn
yarn

# Buils the app
yarn run build

# Restart PM2 server
pm2 restart "app"

# Change directory back to start
cd .