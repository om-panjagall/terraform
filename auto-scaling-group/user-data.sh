#! /bin/bash
sudo su 
sudo apt-get update
sudo apt install apache2 
sudo touch /var/www/html/index.html
sudo chmod 777 /var/www/html/index.html
echo "<h4> At $(hostname -f) <h4>" >> /var/www/html/index.html