#!/bin/bash

read -p "Username : " username
read -s -p "Password : " password

echo ${password} | ocpasswd -c /etc/ocserv/ocpasswd ${username}

echo "the user ${username} has been created successfuly"
