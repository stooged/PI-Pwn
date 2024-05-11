#!/bin/bash
sudo apt update
sudo apt install python3-scapy -y
sudo rm /usr/lib/systemd/system/bluetooth.target
sudo rm /usr/lib/systemd/system/network-online.target
sudo sed -i '/sudo bash \/boot\/firmware\/PPPwn\/run.sh \&/d' /etc/rc.local # Removes old run command from rc.local
echo '[Service]
WorkingDirectory=/boot/firmware/PI-Pwn/PPPwn
ExecStart=/boot/firmware/PI-Pwn/PPPwn/run.sh
Restart=never
User=root
Group=root
Environment=NODE_ENV=production
[Install]
WantedBy=multi-user.target' | sudo tee /etc/systemd/system/pipwn.service
sudo chmod u+rwx /etc/systemd/system/pipwn.service
while true; do
read -p "$(printf '\r\n\r\n\033[36mDo you want the console to connect to the internet after PPPwn? (Y|N):\033[0m ')" pppq
case $pppq in
[Yy]* ) 
sudo apt install pppoe dnsmasq iptables -y
echo 'bogus-priv
expand-hosts
domain-needed
server=8.8.8.8
listen-address=127.0.0.1
port=5353
conf-file=/etc/dnsmasq.more.conf' | sudo tee /etc/dnsmasq.conf
echo 'address=/playstation.com/127.0.0.1
address=/playstation.net/127.0.0.1
address=/playstation.org/127.0.0.1
address=/akadns.net/127.0.0.1
address=/akamai.net/127.0.0.1
address=/akamaiedge.net/127.0.0.1
address=/edgekey.net/127.0.0.1
address=/edgesuite.net/127.0.0.1
address=/llnwd.net/127.0.0.1
address=/scea.com/127.0.0.1
address=/sonyentertainmentnetwork.com/127.0.0.1
address=/ribob01.net/127.0.0.1
address=/cddbp.net/127.0.0.1
address=/nintendo.net/127.0.0.1
address=/ea.com/127.0.0.1' | sudo tee /etc/dnsmasq.more.conf
sudo systemctl restart dnsmasq
echo 'auth
lcp-echo-failure 3
lcp-echo-interval 60
mtu 1482
mru 1482
require-pap
ms-dns 192.168.2.1
netmask 255.255.255.0
defaultroute
noipdefault
usepeerdns' | sudo tee /etc/ppp/pppoe-server-options
while true; do
read -p "$(printf '\r\n\r\n\033[36mDo you want to set a PPPoE username and password?\r\nif you select no then these defaults will be used\r\n\r\nUsername: \033[33mppp\r\n\033[36mPassword: \033[33mppp\r\n\r\n\033[36m(Y|N)?: \033[0m')" wapset
case $wapset in
[Yy]* ) 
while true; do
read -p  "$(printf '\033[33mEnter Username: \033[0m')" PPPU
case $PPPU in
"" ) 
 echo -e '\033[31mCannot be empty!\033[0m';;
 * )  
if grep -q '^[0-9a-zA-Z_ -]*$' <<<$PPPU ; then 


if [ ${#PPPU} -le 1 ]  || [ ${#PPPU} -ge 33 ] ; then
echo -e '\033[31mUsername must be between 2 and 32 characters long\033[0m';
else 
break;
fi
else 
echo -e '\033[31mUsername must only contain alphanumeric characters\033[0m';
fi
esac
done
while true; do
read -p "$(printf '\033[33mEnter password: \033[0m')" PPPW
case $PPPW in
"" ) 
 echo -e '\033[31mCannot be empty!\033[0m';;
 * )  
if [ ${#PPPW} -le 1 ]  || [ ${#PPPW} -ge 33 ] ; then
echo -e '\033[31mPassword must be between 2 and 32 characters long\033[0m';
else 
break;
fi
esac
done
echo -e '\033[36mUsing custom settings\r\n\r\nUsername: \033[33m'$PPPU'\r\n\033[36mPassword: \033[33m'$PPPW'\r\n\r\n\033[0m'
break;;
[Nn]* ) 
echo -e '\033[36mUsing default settings\r\n\r\nUsername: \033[33mppp\r\n\033[36mPassword: \033[33mppp\r\n\r\n\033[0m'
 PPPU="ppp"
 PPPW="ppp"
break;;
* ) echo -e '\033[31mPlease answer Y or N\033[0m';;
esac
done
echo '"'$PPPU'"  *  "'$PPPW'"  *' | sudo tee /etc/ppp/pap-secrets
sudo sed -i 's^PPPOECONN=false^PPPOECONN=true^g' /boot/firmware/PI-Pwn/PPPwn/run.sh
echo -e '\033[32mPPPoE installed\033[0m'
break;;
[Nn]* ) echo -e '\033[35mSkipping PPPoE install\033[0m'
break;;
* ) echo -e '\033[31mPlease answer Y or N\033[0m';;
esac
done
sudo systemctl enable pipwn
sudo systemctl start pipwn
echo -e '\033[36mInstall complete,\033[33m Rebooting\033[0m'
sudo reboot
