#!/bin/bash



echo -e "\n\n\033[36m _____  _____  _____                 
|  __ \\|  __ \\|  __ \\
| |__) | |__) | |__) |_      ___ __
|  ___/|  ___/|  ___/\\ \\ /\\ / / '_ \\
| |    | |    | |     \\ V  V /| | | |
|_|    |_|    |_|      \\_/\\_/ |_| |_|\033[0m
\n\033[33mhttps://github.com/TheOfficialFloW/PPPwn\033[0m\n\n\033[32mReady for console connection\033[0m\n"

while [ true ]
do
ret=$(sudo python3 /boot/firmware/PPPwn/pppwn.py --interface=eth0 --fw=1100 --stage1=/boot/firmware/PPPwn/pppwn.bin --stage2=/boot/firmware/PPPwn/stage2_11.00.bin)
if [ $ret -ge 1 ]
   then
        echo -e "\033[32m\nConsole PPPwned! \033[0m\n"
		sudo ip link set eth0 down
		sudo poweroff
        exit 1
   else
        echo -e "\033[31m\nFailed retrying...\033[0m\n"
		sudo ip link set eth0 down
		sleep 4
        sudo ip link set eth0 up
fi
done


