#!/bin/bash

# raspberry pi ethernet interface
INTERFACE="eth0" 

# console firmware version [11.00 | 9.00]
FIRMWAREVERSION="11.00" 

# shutdown pi on successful pppwn  [true | false]
SHUTDOWN=true


echo -e "\n\n\033[36m _____  _____  _____                 
|  __ \\|  __ \\|  __ \\
| |__) | |__) | |__) |_      ___ __
|  ___/|  ___/|  ___/\\ \\ /\\ / / '_ \\
| |    | |    | |     \\ V  V /| | | |
|_|    |_|    |_|      \\_/\\_/ |_| |_|\033[0m
\n\033[33mhttps://github.com/TheOfficialFloW/PPPwn\033[0m\n"

echo -e "\n\033[32mReady for console connection\033[92m\nFirmware:\033[93m $FIRMWAREVERSION\033[92m\nInterface:\033[93m $INTERFACE\033[0m\n"
while [ true ]
do
ret=$(sudo python3 /boot/firmware/PPPwn/pppwn.py --interface=$INTERFACE --fw=$FIRMWAREVERSION --stage1=/boot/firmware/PPPwn/pppwn.bin --stage2=/boot/firmware/PPPwn/stage2_$FIRMWAREVERSION.bin)
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
        sudo ip link set $INTERFACE down
        sleep 4
        sudo ip link set $INTERFACE up
fi
done


