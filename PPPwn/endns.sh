#!/bin/bash

HSLC=$(tr -d '\0' </etc/dnsmasq.more.conf) 
if [[ ! $HSLC == *"127.0.0.1"* ]] ;then
HSTN=$(hostname | cut -f1 -d' ')
echo 'address=/manuals.playstation.net/192.168.2.1
address=/playstation.com/127.0.0.1
address=/playstation.net/127.0.0.1
address=/playstation.org/127.0.0.1
address=/akadns.net/127.0.0.1
address=/akamai.net/127.0.0.1
address=/akamaiedge.net/127.0.0.1
address=/edgekey.net/127.0.0.1
address=/edgesuite.net/127.0.0.1
address=/llnwd.net/127.0.0.1
address=/scea.com/127.0.0.1
address=/sie-rd.com/127.0.0.1
address=/llnwi.net/127.0.0.1
address=/sonyentertainmentnetwork.com/127.0.0.1
address=/ribob01.net/127.0.0.1
address=/cddbp.net/127.0.0.1
address=/nintendo.net/127.0.0.1
address=/ea.com/127.0.0.1
address=/'$HSTN'.local/192.168.2.1' | sudo tee /etc/dnsmasq.more.conf
sudo systemctl restart dnsmasq
fi