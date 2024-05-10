#!/bin/bash

# raspberry pi ethernet interface
INTERFACE="eth0" 

# console firmware version [11.00 | 9.00]
FIRMWAREVERSION="11.00" 

# shutdown pi on successful pppwn  [true | false]
SHUTDOWN=true

# using a usb to ethernet adapter  [true | false]
USBETHERNET=false


echo -e "\n\n\033[36m _____  _____  _____                 
|  __ \\|  __ \\|  __ \\
| |__) | |__) | |__) |_      ___ __
|  ___/|  ___/|  ___/\\ \\ /\\ / / '_ \\
| |    | |    | |     \\ V  V /| | | |
|_|    |_|    |_|      \\_/\\_/ |_| |_|\033[0m
\n\033[33mhttps://github.com/TheOfficialFloW/PPPwn\033[0m\n"
if [ $USBETHERNET = true ] ; then
	echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/unbind
	coproc read -t 2 && wait "$!" || true
	echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/bind
	coproc read -t 5 && wait "$!" || true
	sudo ip link set $INTERFACE up
   else	
	sudo ip link set $INTERFACE down
	coproc read -t 5 && wait "$!" || true
	sudo ip link set $INTERFACE up
fi
echo -e "\n\033[32mReady for console connection\033[92m\nFirmware:\033[93m $FIRMWAREVERSION\033[92m\nInterface:\033[93m $INTERFACE\033[0m\n"
while [ true ]
do
ret=$(sudo python3 /boot/firmware/PPPwn/pppwn.py --interface=$INTERFACE --fw=$FIRMWAREVERSION --stage1=/boot/firmware/PPPwn/stage1_$FIRMWAREVERSION.bin --stage2=/boot/firmware/PPPwn/stage2_$FIRMWAREVERSION.bin)
if [ $ret -ge 1 ]
   then
        echo -e "\033[32m\nConsole PPPwned! \033[0m\n"
		sudo ip link set $INTERFACE down
		if [ $SHUTDOWN = true ] ; then
			sudo poweroff
		fi
        exit 1
   else
        echo -e "\033[31m\nFailed retrying...\033[0m\n"
		if [ $USBETHERNET = true ] ; then
        	echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/unbind
        	coproc read -t 5 && wait "$!" || true
        	echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/bind
           else	
        	sudo ip link set $INTERFACE down
        	coproc read -t 5 && wait "$!" || true
        	sudo ip link set $INTERFACE up
        fi
fi
done
