wget https://github.com/lucaslealdev/PI-Pwn-script/archive/refs/heads/main.zip
unzip main.zip -d PI-Pwn
sudo mkdir /boot/firmware/
cd PI-Pwn
sudo cp -r PPPwn /boot/firmware/
cd /boot/firmware/PPPwn
sudo chmod 777 *
sudo bash install.sh