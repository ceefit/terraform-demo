#!/usr/bin/env bash

sudo apt -y update
sudo apt -y install nginx
sudo systemctl enable --now nginx
sudo mv /tmp/index.html /var/www/html/index.html
sudo ufw allow 'Nginx HTTP'