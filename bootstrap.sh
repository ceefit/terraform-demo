#!/usr/bin/env bash

sudo apt -y update
sudo apt -y install nginx
sudo systemctl enable --now nginx
sudo ufw allow 'Nginx HTTP'