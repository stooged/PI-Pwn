#!/bin/bash

if [ ! -f /boot/firmware/PPPwn/config.sh ]; then
INTERFACE="eth0" 
else
source /boot/firmware/PPPwn/config.sh
fi

sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X
sudo sysctl net.ipv4.ip_forward=1
sudo sysctl net.ipv4.conf.all.route_localnet=1
sudo iptables -t nat -I PREROUTING -s 192.168.2.0/24 -p udp -m udp --dport 53 -j DNAT --to-destination 127.0.0.1:5353
if [ -f /boot/firmware/PPPwn/ports.txt ]; then
	PORTS=$(sudo cat /boot/firmware/PPPwn/ports.txt | tr "," "\n")
	for prt in $PORTS
	do
    	sudo iptables -t nat -I PREROUTING -p tcp --dport $prt -j DNAT --to 192.168.2.2:$prt
	done
else
	sudo iptables -t nat -I PREROUTING -p tcp --dport 2121 -j DNAT --to 192.168.2.2:2121
	sudo iptables -t nat -I PREROUTING -p tcp --dport 3232 -j DNAT --to 192.168.2.2:3232
	sudo iptables -t nat -I PREROUTING -p tcp --dport 9090 -j DNAT --to 192.168.2.2:9090
	sudo iptables -t nat -I PREROUTING -p tcp --dport 12800 -j DNAT --to 192.168.2.2:12800
	sudo iptables -t nat -I PREROUTING -p tcp --dport 1337 -j DNAT --to 192.168.2.2:1337
fi
sudo iptables -t nat -A POSTROUTING -s 192.168.2.0/24 ! -d 192.168.2.0/24 -j MASQUERADE
echo -e "\n\n\033[93m\nPPPoE Enabled \033[0m\n" | sudo tee /dev/tty1
sudo pppoe-server -I $INTERFACE -T 60 -N 1 -C PS4 -S PS4 -L 192.168.2.1 -R 192.168.2.2 -F