#!/bin/bash

NETWORK_INTERFACE=$(ip -o -4 route show to default | awk '{print $5}')
echo -e "Your Network interface is $NETWORK_INTERFACE"

PRIVATE_SUBNET="10.10.10.0/24"
echo -e "Your private subnet is $PRIVATE_SUBNET"

echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/60-custom.conf
echo -e "IP Forwarding Enabled"

echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.d/60-custom.conf
echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.d/60-custom.conf
echo -e "BBR algorithm Enabled"

sudo sysctl -p /etc/sysctl.d/60-custom.conf
echo -e "sysctl settings applied"

sudo iptables -t nat -A POSTROUTING -s $PRIVATE_SUBNET -o $NETWORK_INTERFACE -j MASQUERADE
echo -e "NAT configured"

sudo iptables -A FORWARD -s $PRIVATE_SUBNET -j ACCEPT
sudo iptables -A FORWARD -d $PRIVATE_SUBNET -j ACCEPT
echo -e "Packet Forwarding is allowed now"

sudo mkdir -p /etc/iptables

sudo apt-get install iptables-persistent -y
sudo iptables-save >/etc/iptables/rules.v4
echo -e "iptables configuration and rules saved to /etc/iptables/rules.v4"

# Checking NAT rule
echo -e "Check if the NAT rule appears below..."
sudo iptables -t nat -L POSTROUTING
