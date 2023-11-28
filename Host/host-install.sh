#!/bin/bash

apt update -y
apt install ocserv certbot stunnel4 openssl -y
echo "OpenConnect And Stunnel have installed successfuly"

read -p "Your Valid Domain : " domain
read -p "Your Email Address : " email

fullchain="/etc/letsencrypt/live/${domain}/fullchain.pem"
privatekey="/etc/letsencrypt/live/${domain}/privkey.pem"

echo "n" | certbot certonly --standalone --preferred-challenges http --agree-tos --email ${email} -d ${domain}

read -p "How Many Connection Each User should Have (number between 1 and 8) ? " connections

sed -i "s/MY_DOMAIN/${domain}/g" openconnect_config/ocserv.conf
sed -i "s/CLIENT_CONNECTIONS/${connections}/g" openconnect_config/ocserv.conf

rm /etc/ocserv/ocserv.conf
cp ./openconnect_config/ocserv.conf /etc/ocserv/

cat openconnect_config/default.conf >openconnect_config/ocserv.conf

systemctl start ocserv.service
systemctl restart ocserv.service

chmod +x nat_config/nat.sh
./nat_config/nat.sh

if [[ -f /usr/lib/systemd/system/stunnel.service ]]; then
    rm /usr/lib/systemd/system/stunnel.service
fi

cp ./stunnel_config/stunnel.service /usr/lib/systemd/system/stunnel.service

read -p "What is your approprate input port (hint: you will use this from mediator server) : " port

sed -i "s/INPUT_PORT/${port}/g" stunnel_config/stunnel.conf

if [[ -f /etc/stunnel/stunnel.conf ]]; then
    rm /etc/stunnel/stunnel.conf
fi
cp ./stunnel_config/stunnel.conf /etc/stunnel/

cat stunnel_config/default.conf >stunnel_config/stunnel.conf

openssl genrsa -out privkey.pem 2048
yes "" | openssl req -new -x509 -key privkey.pem -out cacert.pem -days 3650
cat privkey.pem cacert.pem >>/etc/stunnel/stunnel.pem
chmod 0400 /etc/stunnel/stunnel.pem

systemctl start stunnel
systemctl enable stunnel
systemctl restart stunnel

exit 0
