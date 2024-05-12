#!/bin/bash
sudo apt update
sudo apt install python3-scapy -y
sudo rm /usr/lib/systemd/system/bluetooth.target
sudo rm /usr/lib/systemd/system/network-online.target
sudo sed -i 's^sudo bash /boot/firmware/PPPwn/run.sh \&^^g' /etc/rc.local
echo '[Service]
WorkingDirectory=/boot/firmware/PPPwn
ExecStart=/boot/firmware/PPPwn/run.sh
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
INET="true"
SHTDN="false"
echo -e '\033[32mPPPoE installed\033[0m'
break;;
[Nn]* ) 
echo -e '\033[35mSkipping PPPoE install\033[0m'
INET="false"
while true; do
read -p "$(printf '\r\n\r\n\033[36mDo you want the pi to shutdown after pwn success\r\n\r\n\033[36m(Y|N)?: \033[0m')" pisht
case $pisht in
[Yy]* ) 
SHTDN="true"
echo -e '\033[32mThe pi will shutdown\033[0m'
break;;
[Nn]* ) 
echo -e '\033[35mThe pi will not shutdown\033[0m'
SHTDN="false"
break;;
* ) echo -e '\033[31mPlease answer Y or N\033[0m';;
esac
done
break;;
* ) echo -e '\033[31mPlease answer Y or N\033[0m';;
esac
done
while true; do
read -p "$(printf '\r\n\r\n\033[36mAre you using a usb to ethernet adapter for the console connection\r\n\r\n\033[36m(Y|N)?: \033[0m')" usbeth
case $usbeth in
[Yy]* ) 
USBE="true"
echo -e '\033[32mUsb to ethernet is being used\033[0m'
break;;
[Nn]* ) 
echo -e '\033[35mUsb to ethernet is NOT being used\033[0m'
USBE="false"
break;;
* ) echo -e '\033[31mPlease answer Y or N\033[0m';;
esac
done
while true; do
read -p "$(printf '\r\n\r\n\033[36mDo you want to use the old python version of pppwn, It is much slower\r\n\r\n\033[36m(Y|N)?: \033[0m')" cppp
case $cppp in
[Yy]* ) 
UCPP="false"
echo -e '\033[32mThe Python version of PPPwn is being used\033[0m'
break;;
[Nn]* ) 
echo -e '\033[35mThe C++ version of PPPwn is being used\033[0m'
UCPP="true"
break;;
* ) echo -e '\033[31mPlease answer Y or N\033[0m';;
esac
done
while true; do
read -p "$(printf '\r\n\r\n\033[36mWould you like to change the firmware version being used, the default is 11.00\r\n\r\n\033[36m(Y|N)?: \033[0m')" fwset
case $fwset in
[Yy]* ) 
while true; do
read -p  "$(printf '\033[33mEnter the firmware version [11.00 | 9.00]: \033[0m')" FWV
case $FWV in
"" ) 
 echo -e '\033[31mCannot be empty!\033[0m';;
 * )  
if grep -q '^[0-9.]*$' <<<$FWV ; then 

if [[ ! "$FWV" =~ ^("11.00"|"9.00")$ ]]  ; then
echo -e '\033[31mThe version must be 11.00 or 9.00\033[0m';
else 
break;
fi
else 
echo -e '\033[31mThe version must only contain alphanumeric characters\033[0m';
fi
esac
done
echo -e '\033[32mYou are using '$FWV'\033[0m'
break;;
[Nn]* ) 
echo -e '\033[35mUsing the default setting: 11.00\033[0m'
FWV="11.00"
break;;
* ) echo -e '\033[31mPlease answer Y or N\033[0m';;
esac
done
while true; do
read -p "$(printf '\r\n\r\n\033[36mWould you like to change the pi lan interface, the default is eth0\r\n\r\n\033[36m(Y|N)?: \033[0m')" ifset
case $ifset in
[Yy]* ) 
while true; do
read -p  "$(printf '\033[33mEnter the interface value: \033[0m')" IFCE
case $IFCE in
"" ) 
 echo -e '\033[31mCannot be empty!\033[0m';;
 * )  
if grep -q '^[0-9a-zA-Z_ -]*$' <<<$IFCE ; then 
if [ ${#IFCE} -le 1 ]  || [ ${#IFCE} -ge 17 ] ; then
echo -e '\033[31mThe interface must be between 2 and 16 characters long\033[0m';
else 
break;
fi
else 
echo -e '\033[31mThe interface must only contain alphanumeric characters\033[0m';
fi
esac
done
echo -e '\033[32mYou are using '$IFCE'\033[0m'
break;;
[Nn]* ) 
echo -e '\033[35mUsing the default setting: eth0\033[0m'
IFCE="eth0"
break;;
* ) echo -e '\033[31mPlease answer Y or N\033[0m';;
esac
done
echo '#!/bin/bash

# raspberry pi ethernet interface
INTERFACE="'$IFCE'" 

# console firmware version  [11.00 | 9.00]
FIRMWAREVERSION="'$FWV'" 

# shutdown pi on successful pppwn  [true | false]
SHUTDOWN='$SHTDN'

# using a usb to ethernet adapter  [true | false]
USBETHERNET='$USBE'

#use c++ version of pppwn
USECPP='$UCPP'

# enable pppoe after pwn  [true | false]
#this does not work if you did not set the console to connect to the internet during the install
PPPOECONN='$INET'' | sudo tee /boot/firmware/PPPwn/config.sh
sudo systemctl enable pipwn
sudo systemctl start pipwn
echo -e '\033[36mInstall complete,\033[33m Rebooting\033[0m'
sudo reboot
