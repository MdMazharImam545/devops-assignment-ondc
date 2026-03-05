#!/bin/bash
apt update -y
apt install -y nginx
systemctl enable nginx
systemctl start nginx
echo "Environment Webserver $(hostname)" > /var/www/html/index.nginx-debian.html