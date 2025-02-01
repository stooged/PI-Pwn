#!/bin/bash

if [ -f /boot/firmware/PPPwn/config.sh ]; then
source /boot/firmware/PPPwn/config.sh
fi
if [ -z $INTERFACE ]; then INTERFACE="eth0"; fi
if [ -z $FIRMWAREVERSION ]; then FIRMWAREVERSION="11.00"; fi
if [ -z $SHUTDOWN ]; then SHUTDOWN=true; fi
if [ -z $USBETHERNET ]; then USBETHERNET=false; fi
if [ -z $PPPOECONN ]; then PPPOECONN=false; fi
if [ -z $VMUSB ]; then VMUSB=false; fi
if [ -z $DTLINK ]; then DTLINK=false; fi
if [ -z $PPDBG ]; then PPDBG=false; fi
if [ -z $TIMEOUT ]; then TIMEOUT="5m"; fi
if [ -z $RESTMODE ]; then RESTMODE=false; fi
if [ -z $LEDACT ]; then LEDACT="normal"; fi
if [ -z $OIPV ]; then OIPV=false; fi
if [ -z $UGH ]; then UGH=true; fi
if [ $OIPV = true ] ; then
PYIP="fe80::4141:4141:4141:4141"
else
PYIP="fe80::9f9f:41ff:9f9f:41ff"
fi
STA2="stage2_1100.bin"
HDIR="/boot/firmware/PPPwn/vx_sta/"
if [ $UGH = true ] && [[ $FIRMWAREVERSION == "9.00" ]] || [[ $FIRMWAREVERSION == "9.03" ]] || [[ $FIRMWAREVERSION == "9.60" ]] || [[ $FIRMWAREVERSION == "10.00" ]] || [[ $FIRMWAREVERSION == "10.01" ]] || [[ $FIRMWAREVERSION == "10.50" ]] || [[ $FIRMWAREVERSION == "10.70" ]] || [[ $FIRMWAREVERSION == "10.71" ]] || [[ $FIRMWAREVERSION == "11.00" ]] ; then
HDIR="/boot/firmware/PPPwn/gh_sta/"
if [[ $FIRMWAREVERSION == "9.00" ]] ; then
STA2="stage2_900.bin"
elif [[ $FIRMWAREVERSION == "9.03" ]] ; then
STA2="stage2_903.bin"
elif [[ $FIRMWAREVERSION == "9.60" ]] ; then
STA2="stage2_950.bin"
elif [[ $FIRMWAREVERSION == "10.00" ]] || [[ $FIRMWAREVERSION == "10.01" ]] ; then
STA2="stage2_1000.bin"
elif [[ $FIRMWAREVERSION == "10.50" ]] || [[ $FIRMWAREVERSION == "10.70" ]] || [[ $FIRMWAREVERSION == "10.71" ]] ; then
STA2="stage2_1050.bin"
elif [[ $FIRMWAREVERSION == "11.00" ]] ; then
STA2="stage2_1100.bin"
fi
else
UGH=false
if [[ $FIRMWAREVERSION == "7.00" ]] || [[ $FIRMWAREVERSION == "7.01" ]] || [[ $FIRMWAREVERSION == "7.02" ]] ; then
STA2="stage2_700.bin"
elif [[ $FIRMWAREVERSION == "7.50" ]] || [[ $FIRMWAREVERSION == "7.51" ]] || [[ $FIRMWAREVERSION == "7.55" ]] ; then
STA2="stage2_750.bin"
elif [[ $FIRMWAREVERSION == "8.00" ]] || [[ $FIRMWAREVERSION == "8.01" ]] || [[ $FIRMWAREVERSION == "8.03" ]] ; then
STA2="stage2_800.bin"
elif [[ $FIRMWAREVERSION == "8.50" ]] || [[ $FIRMWAREVERSION == "8.52" ]] ; then
STA2="stage2_8.50.bin"
elif [[ $FIRMWAREVERSION == "9.00" ]] ; then
STA2="stage2_900.bin"
elif [[ $FIRMWAREVERSION == "9.03" ]] || [[ $FIRMWAREVERSION == "9.04" ]] ; then
STA2="stage2_903.bin"
elif [[ $FIRMWAREVERSION == "9.50" ]] || [[ $FIRMWAREVERSION == "9.51" ]] || [[ $FIRMWAREVERSION == "9.60" ]] ; then
STA2="stage2_950.bin"
elif [[ $FIRMWAREVERSION == "10.00" ]] || [[ $FIRMWAREVERSION == "10.01" ]] ; then
STA2="stage2_1000.bin"
elif [[ $FIRMWAREVERSION == "10.50" ]] || [[ $FIRMWAREVERSION == "10.70" ]] || [[ $FIRMWAREVERSION == "10.71" ]] ; then
STA2="stage2_1050.bin"
elif [[ $FIRMWAREVERSION == "11.00" ]] ; then
STA2="stage2_1100.bin"
fi
fi
PITYP=$(tr -d '\0' </proc/device-tree/model) 
if [[ $PITYP == *"Raspberry Pi 2"* ]] ;then
coproc read -t 15 && wait "$!" || true
VMUSB=false
elif [[ $PITYP == *"Raspberry Pi 3"* ]] ;then
coproc read -t 10 && wait "$!" || true
VMUSB=false
elif [[ $PITYP == *"Raspberry Pi 4"* ]] ;then
coproc read -t 5 && wait "$!" || true
elif [[ $PITYP == *"Raspberry Pi Compute Module 4"* ]] ;then
coproc read -t 5 && wait "$!" || true
elif [[ $PITYP == *"Raspberry Pi 5"* ]] ;then
coproc read -t 5 && wait "$!" || true
elif [[ $PITYP == *"Raspberry Pi Zero 2"* ]] ;then
coproc read -t 8 && wait "$!" || true
VMUSB=false
elif [[ $PITYP == *"Raspberry Pi Zero"* ]] ;then
coproc read -t 10 && wait "$!" || true
VMUSB=false
elif [[ $PITYP == *"Raspberry Pi"* ]] ;then
coproc read -t 15 && wait "$!" || true
VMUSB=false
else
coproc read -t 5 && wait "$!" || true
VMUSB=false
fi
PLED=""
ALED=""
if [[ $LEDACT == "status" ]] || [[ $LEDACT == "off" ]] ;then
   if [ -f /sys/class/leds/PWR/trigger ] && [ -f /sys/class/leds/ACT/trigger ]  ; then
      PLED="/sys/class/leds/PWR/trigger"
      ALED="/sys/class/leds/ACT/trigger"
      echo none | sudo tee $PLED >/dev/null
      echo none | sudo tee $ALED >/dev/null
   elif [ -f /sys/class/leds/user-led1/trigger ] && [ -f /sys/class/leds/user-led2/trigger ]  ; then
      PLED="/sys/class/leds/user-led1/trigger"
      ALED="/sys/class/leds/user-led2/trigger"
      echo none | sudo tee $PLED >/dev/null
      echo none | sudo tee $ALED >/dev/null
   else
      LEDACT="normal"
   fi
fi
echo -e "\n\n\033[36m _____  _____  _____                 
|  __ \\|  __ \\|  __ \\
| |__) | |__) | |__) |_      ___ __
|  ___/|  ___/|  ___/\\ \\ /\\ / / '_ \\
| |    | |    | |     \\ V  V /| | | |
|_|    |_|    |_|      \\_/\\_/ |_| |_|\033[0m
\n\033[33mhttps://github.com/TheOfficialFloW/PPPwn\033[0m\n" | sudo tee /dev/tty1
sudo systemctl stop pppoe
if [ $USBETHERNET = true ] ; then
	echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/unbind >/dev/null
	coproc read -t 2 && wait "$!" || true
	echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/bind >/dev/null
	coproc read -t 5 && wait "$!" || true
	sudo ip link set $INTERFACE up
   else	
	sudo ip link set $INTERFACE down
	coproc read -t 5 && wait "$!" || true
	sudo ip link set $INTERFACE up
fi
echo -e "\n\033[36m$PITYP\033[92m\nFirmware:\033[93m $FIRMWAREVERSION\033[92m\nInterface:\033[93m $INTERFACE\033[0m" | sudo tee /dev/tty1
echo -e "\033[92mPPPwn:\033[93m Python pppwn.py \033[0m" | sudo tee /dev/tty1
if [ $VMUSB = true ] ; then
 sudo rmmod g_mass_storage
  FOUND=0
  readarray -t rdirarr  < <(sudo ls /media/pwndrives)
  for rdir in "${rdirarr[@]}"; do
    readarray -t pdirarr  < <(sudo ls /media/pwndrives/${rdir})
    for pdir in "${pdirarr[@]}"; do
       if [[ ${pdir,,}  == "payloads" ]] ; then 
	     FOUND=1
	     UDEV='/dev/'${rdir}
	     break
      fi
    done
      if [ "$FOUND" -ne 0 ]; then
        break
      fi
  done  
  if [[ ! -z $UDEV ]] ;then
    sudo modprobe g_mass_storage file=$UDEV stall=0 ro=0 removable=1
  fi
  echo -e "\033[92mUSB Drive:\033[93m Enabled\033[0m" | sudo tee /dev/tty1
fi
if [ $PPPOECONN = true ] ; then
   echo -e "\033[92mInternet Access:\033[93m Enabled\033[0m" | sudo tee /dev/tty1
else   
   echo -e "\033[92mInternet Access:\033[93m Disabled\033[0m" | sudo tee /dev/tty1
fi
if [[ $LEDACT == "status" ]] ;then
   echo timer | sudo tee $PLED >/dev/null
fi
if [[ ! $(ifconfig $INTERFACE) == *"RUNNING"* ]]; then
   echo -e "\033[31mWaiting for link\033[0m" | sudo tee /dev/tty1
   while [[ ! $(ifconfig $INTERFACE) == *"RUNNING"* ]]
   do
      coproc read -t 2 && wait "$!" || true
   done
   echo -e "\033[32mLink found\033[0m\n" | sudo tee /dev/tty1
fi
if [ $RESTMODE = true ] && [ $UGH = true ] ; then
sudo pppoe-server -I $INTERFACE -T 60 -N 1 -C PPPWN -S PPPWN -L 192.168.2.1 -R 192.168.2.2 
coproc read -t 2 && wait "$!" || true
while [[ $(sudo nmap -p 3232 192.168.2.2 | grep '3232/tcp' | cut -f2 -d' ') == "" ]]
do
    coproc read -t 2 && wait "$!" || true
done
coproc read -t 5 && wait "$!" || true
GHT=$(sudo nmap -p 3232 192.168.2.2 | grep '3232/tcp' | cut -f2 -d' ')
if [[ $GHT == *"open"* ]] ; then
echo -e "\n\033[95mGoldhen found aborting pppwn\033[0m\n" | sudo tee /dev/tty1
if [[ $LEDACT == "status" ]] ;then
	echo none | sudo tee $PLED >/dev/null
	echo default-on | sudo tee $ALED >/dev/null
fi
sudo killall pppoe-server
if [ $PPPOECONN = true ] ; then
	sudo systemctl start pppoe
	if [ $DTLINK = true ] ; then
		sudo systemctl start dtlink
	fi
else
	if [ $SHUTDOWN = true ] ; then
		coproc read -t 5 && wait "$!" || true
		sudo poweroff
	else
		if [ $DTLINK = true ] ; then
			sudo systemctl start dtlink
		else
			sudo ip link set $INTERFACE down
		fi
	fi
fi
exit 0
else
echo -e "\n\033[95mGoldhen not found starting pppwn\033[0m\n" | sudo tee /dev/tty1
sudo killall pppoe-server
if [ $USBETHERNET = true ] ; then
	echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/unbind >/dev/null
	coproc read -t 1 && wait "$!" || true
	echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/bind >/dev/null
	coproc read -t 4 && wait "$!" || true
	sudo ip link set $INTERFACE up
   else	
	sudo ip link set $INTERFACE down
	coproc read -t 5 && wait "$!" || true
	sudo ip link set $INTERFACE up
fi
fi
fi
PIIP=$(hostname -I) || true
if [ "$PIIP" ]; then
   echo -e "\n\033[92mIP: \033[93m $PIIP\033[0m" | sudo tee /dev/tty1
fi
echo -e "\n\033[95mReady for console connection\033[0m\n" | sudo tee /dev/tty1
while [ true ]
do
if [[ $LEDACT == "status" ]] ;then
	echo heartbeat | sudo tee $PLED >/dev/null
	echo timer | sudo tee $ALED >/dev/null
fi
sudo ip link set $INTERFACE down
coproc read -t 5 && wait "$!" || true
sudo ip link set $INTERFACE up
if [ -f /boot/firmware/PPPwn/config.sh ]; then
 if  grep -Fxq "PPDBG=true" /boot/firmware/PPPwn/config.sh ; then
   PPDBG=true
   else
   PPDBG=false
 fi
fi
while read -r stdo ; 
do 
 if [ $PPDBG = true ] ; then
	echo -e $stdo | sudo tee /dev/tty1 | sudo tee /dev/pts/* | sudo tee -a /boot/firmware/PPPwn/pwn.log
 fi
 if [[ $stdo  == "[+] Done!" ]] ; then
	echo -e "\033[32m\nConsole PPPwned! \033[0m\n" | sudo tee /dev/tty1
	if [[ $LEDACT == "status" ]] ;then
		echo none | sudo tee $PLED >/dev/null
		echo default-on | sudo tee $ALED >/dev/null
	fi
	if [ $PPPOECONN = true ] ; then
		sudo systemctl start pppoe
		if [ $DTLINK = true ] ; then
			sudo systemctl start dtlink
		fi
	else
		if [ $SHUTDOWN = true ] ; then
			coproc read -t 5 && wait "$!" || true
			sudo poweroff
		else
			if [ $DTLINK = true ] ; then
				sudo systemctl start dtlink
			else
				sudo ip link set $INTERFACE down
			fi
        fi
	fi
	exit 0
 elif [[ $stdo  == *"Scanning for corrupted object...failed"* ]] ; then
 	echo -e "\033[31m\nFailed retrying...\033[0m\n" | sudo tee /dev/tty1
 elif [[ $stdo  == *"Unsupported firmware version"* ]] ; then
 	echo -e "\033[31m\nUnsupported firmware version\033[0m\n" | sudo tee /dev/tty1
	if [[ $LEDACT == "status" ]] ;then
	 	echo none | sudo tee $ALED >/dev/null
	 	echo default-on | sudo tee $PLED >/dev/null
	fi
 	exit 1
 elif [[ $stdo  == *"Cannot find interface with name of"* ]] ; then
 	echo -e "\033[31m\nInterface $INTERFACE not found\033[0m\n" | sudo tee /dev/tty1
	if [[ $LEDACT == "status" ]] ;then
	 	echo none | sudo tee $ALED >/dev/null
	 	echo default-on | sudo tee $PLED >/dev/null
	fi
 	exit 1
 fi
done < <(timeout $TIMEOUT sudo python3 /boot/firmware/PPPwn/pppwn.py --interface=$INTERFACE --fw=${FIRMWAREVERSION//.} --ipv=$PYIP --sta=$HDIR$STA2)
if [[ $LEDACT == "status" ]] ;then
 	echo none | sudo tee $ALED >/dev/null
 	echo default-on | sudo tee $PLED >/dev/null
fi
done


