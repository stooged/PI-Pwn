#!/usr/bin/env bash
set -e

if [ -f /boot/firmware/pppwn/patch.log ]; then
    sudo rm -rf /boot/firmware/pppwn/patch.log
fi

patching(){
    if ! command -v nala 2>&1 >/dev/null
    then
	echo -e "First time run, you will only see this once!\n"
        echo -e "Doing APT update...\n"
        sudo apt-get update
        echo -e "\nInstalling Nala...\n"
        sudo apt-get install nala -y
        echo -e "\nRunning Rasbian upgrade...\n"
	sudo DEBIAN_FRONTEND=noninteractive nala upgrade -y
        echo -e "\nAll set!"
    else
	echo -e "\nRunning Rasbian upgrade...\n"
        sudo DEBIAN_FRONTEND=noninteractive nala upgrade -y
        echo -e "\nAll set!"
    fi
};


patching | sudo tee /dev/tty1 | sudo tee /dev/pts/* | sudo tee -a /boot/firmware/pppwn/patch.log
exit 0
