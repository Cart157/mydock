#!/bin/bash

certbot certonly --webroot -w /var/www/letsencrypt -d "gutfan.com" -e "fanybook@126.com" --agree-tos --n
certbot certonly --webroot -w /var/www/letsencrypt -d "www.gutfan.com" -e "fanybook@126.com" --agree-tos --n

cp /etc/letsencrypt/archive/"$CN"/cert1.pem /var/certs/cert1.pem
cp /etc/letsencrypt/archive/"$CN"/privkey1.pem /var/certs/privkey1.pem
