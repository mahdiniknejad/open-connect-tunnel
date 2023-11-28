#!/bin/bash

apt update -y
apt install stunnel4 openssl -y
echo "Stunnel has installed successfuly"

if [[ -f /usr/lib/systemd/system/stunnel.service ]]; then
    rm /usr/lib/systemd/system/stunnel.service
fi

cp ./stunnel_config/stunnel.service /usr/lib/systemd/system/stunnel.service

read -p "What is your host server ip : " host
read -p "What is your host server input port (you've added this in host config) : " port

sed -i "s/HOST_IP/${host}/g" stunnel_config/stunnel.conf
sed -i "s/HOST_PORT/${port}/g" stunnel_config/stunnel.conf

if [[ -f /etc/stunnel/stunnel.conf ]]; then
    rm /etc/stunnel/stunnel.conf
fi
cp ./stunnel_config/stunnel.conf /etc/stunnel/

cat stunnel_config/default.conf >stunnel_config/stunnel.conf

touch temp.cnf

cat openssl_config/openssl_update.cnf /etc/ssl/openssl.cnf >openssl_config/temp.cnf && mv temp.cnf /etc/ssl/openssl.cnf

systemctl start stunnel
systemctl enable stunnel
systemctl restart stunnel

exit 0
