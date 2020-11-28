#!/bin/bash
sudo yum -y install git
sudo yum -y install httpd
cd /var/www/html
sudo git clone https://github.com/bgorbuntsov/d3gauge.git ./
sudo systemctl start httpd


