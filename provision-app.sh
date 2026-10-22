#!/bin/bash
# provision-app.sh
# Sets up a fresh Ubuntu 24.04 VM and runs the Node 20 tic-tac-toe app with pm2.
# - Gets the app code with git clone (no scp needed)
# - NGINX is a reverse proxy: port 80 -> app on port 3000
# Safe to run more than once (idempotent).
# Usage: bash provision-app.sh

set -e
export DEBIAN_FRONTEND=noninteractive

REPO_URL="https://github.com/uniiicycle/tech613-node-app.git"
REPO_DIR="$HOME/tech613-node-app"
APP_DIR="$REPO_DIR/app"

# update and upgrade packages
sudo apt-get update
sudo apt-get upgrade -y

# install nginx and git
sudo apt-get install nginx git -y

# reverse proxy: send traffic on port 80 to the app on port 3000
# (only changes the line the first time, so it's safe to re-run)
sudo sed -i 's|try_files $uri $uri/ =404;|proxy_pass http://localhost:3000;|' /etc/nginx/sites-available/default
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx

# install Node.js 20 (skip if already installed)
if ! node -v 2>/dev/null | grep -q '^v20\.'; then
  curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
  sudo -E bash nodesource_setup.sh
  sudo apt-get install nodejs -y
fi
echo "node version: $(node -v)"

# install pm2 (skip if already installed)
if ! command -v pm2 >/dev/null; then
  sudo npm install -g pm2
fi

# get the app code: clone the first time, pull the latest after that
if [ -d "$REPO_DIR/.git" ]; then
  git -C "$REPO_DIR" pull
else
  git clone "$REPO_URL" "$REPO_DIR"
fi

# install app dependencies
cd "$APP_DIR"
npm install

# stop any old copy, then start the app in the background
pm2 kill
pm2 start index.js --name app
pm2 list

echo "app running: http://<public-ip> (via nginx) or http://<public-ip>:3000"
