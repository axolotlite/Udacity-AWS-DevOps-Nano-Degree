#!/bin/bash
apt-get update -y
apt-get install apache2 -y
systemctl start apache2.service
echo "it works! Udagram, Udacity" > /var/www/html/index.html
echo "Datetime of creation: $(date)" >> /var/www/html/index.html