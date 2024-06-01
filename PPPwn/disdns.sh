#!/bin/bash

HSLC=$(tr -d '\0' </etc/dnsmasq.more.conf) 
if [[ $HSLC == *"127.0.0.1"* ]] ;then
HSTN=$(hostname | cut -f1 -d' ')
echo 'address=/manuals.playstation.net/192.168.2.1
address=/'$HSTN'.local/192.168.2.1' | sudo tee /etc/dnsmasq.more.conf
sudo systemctl restart dnsmasq
fi