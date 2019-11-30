#!/bin/bash 
# 
# Name: nginx-install.sh
# 
# Summary: Install nginx for Ubuntu Server
# 
# Usage example: 
# 
# ./nginx-install.sh 
# 
# Date 			Modified By 	Description 
# 26-Nov-2019  	Hrishikesh 		Original version


#Install Nginx for Ubuntu Servers

apt-get -y install nginx

# Create the necessory folders

mkdir -p /var/www/html
mkdir -p /var/www/html/stats


# Configuration setup.

rm -f /etc/nginx/conf.d/default.conf 
cat <<+++ >/etc/nginx/conf.d/db.conf
# Default server configuration
#
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

        index index.html index.json;


        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }
        location /stats/ {
                alias /var/www/html;
                index index.html index.json; 
                default_type text/plain;        
}

+++

#Create a basic landing page

cat <<+++ >/var/www/html/index.html
<html>
<head>

<title>Sever Monitoring stats</title>
<style>
th { text-align: left; }
td { text-align: middle; }
body { font-family: "Univers 45 LT", Arial, Helvetica,sans-serif; }
h1 { font-family: "Univers 45 LT", Arial, Helvetica,sans-serif; color:black; font-size: 15px; text-align:center; }
table { width: 100%; border-spacing: 10px}
.bar { background-color: yellow; width: 100%; height: 30px; padding:5px; }
</style>
</head>
<body>
<div class="bar">
<h1>Server stats</h1>
</div>
<p>
<a href=/stats/>Serverstats</a><br>
<p>
</body>
</html>
+++

systemctl enable nginx.service 
systemctl stop nginx 
systemctl start nginx 

systemctl status nginx 

# End 
