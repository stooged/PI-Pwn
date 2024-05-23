# PI Pwn

This is a script to setup <a href=https://github.com/xfangfang/PPPwn_cpp>PPPwn_cpp</a> a c++ rewrite of <a href=https://github.com/TheOfficialFloW/PPPwn>PPPwn</a> on the raspberry pi and run <a href=https://github.com/GoldHEN/GoldHEN>GoldHen</a> on the PS4 fw 11.0, 10.01, 10.00, 9.00<br>
It also supports internet access after pwn and access to ftp, klog and binloader servers launched by goldhen.<br>
A dns blocker is also installed and used to prevent updates.<br>

The <a href=https://www.raspberrypi.com/products/raspberry-pi-4-model-b/>Raspberry Pi 4</a>, <a href=https://www.raspberrypi.com/products/raspberry-pi-400/>Raspberry Pi 400</a> and <a href=https://www.raspberrypi.com/products/raspberry-pi-5/>Raspberry Pi 5</a> can pass through a usb drive inserted into the pi to the console if the pi is plugged into the console usb port<br>

There is also a webserver to control the pi, change settings and send payloads by accessing http://pppwn.local from the console or your pc if you have internet access enabled.<br> 

<br>

## Tested PI Models

<a href=https://www.raspberrypi.com/products/raspberry-pi-5/>Raspberry Pi 5</a><br>
<a href=https://www.raspberrypi.com/products/raspberry-pi-4-model-b/>Raspberry Pi 4 Model B</a><br>
<a href=https://www.raspberrypi.com/products/raspberry-pi-400/>Raspberry Pi 400</a><br>
<a href=https://www.raspberrypi.com/products/raspberry-pi-3-model-b-plus/>Raspberry Pi 3B+</a><br>
<a href=https://www.raspberrypi.com/products/raspberry-pi-2-model-b/>Raspberry Pi 2 Model B</a><br>
<a href=https://www.raspberrypi.com/products/raspberry-pi-zero-2-w/>Raspberry Pi Zero 2 W</a> with usb to ethernet adapter<br>
<a href=https://www.raspberrypi.com/products/raspberry-pi-zero-w/>Raspberry Pi Zero W</a> with usb to ethernet adapter<br>
<a href=https://wiki.radxa.com/Rock4/4cplus>ROCK PI 4C Plus</a> with armbian <a href=https://imola.armbian.com/archive/rockpi-4cplus/archive/Armbian_23.11.1_Rockpi-4cplus_bookworm_current_6.1.63.img.xz>Image</a><br>
<a href=https://biqu.equipment/products/bigtreetech-btt-pi-v1-2>BIGTREETECH BTT Pi V1.2</a> with armbian <a href=https://www.armbian.com/bigtreetech-cb1/>minimal</a><br>
<a href=https://www.linksprite.com/linksprite-pcduino3/>pcDuino3b</a> with armbian <a href=https://imola.armbian.com/archive/pcduino3nano/archive/Armbian_5.38_Pcduino3nano_Debian_jessie_next_4.14.14.7z>Image</a><br>


## Install
<br>

You need to install <a href=https://www.raspberrypi.com/software/operating-systems/>Raspberry Pi OS Lite</a> or <a href="https://www.armbian.com/">Armbian Cli / Minimal</a> onto a sd card.<br>

Place the sd card into the raspberry pi, boot it and connect it to the internet then run the following commands<br>

<br>

```sh
sudo apt update
sudo apt install git -y
sudo rm -f -r PI-Pwn
sudo systemctl stop pipwn
git clone https://github.com/stooged/PI-Pwn
sudo mkdir /boot/firmware/
cd PI-Pwn
sudo cp -r PPPwn /boot/firmware/
cd /boot/firmware/PPPwn
sudo chmod 777 *
sudo bash install.sh
```

<br>

During the install process you will be asked to set some options.<br>

If you are using a <b>usb to ethernet adapter</b> for the connection to the console you need to select yes<br>
If your pi has an ethernet port and you are using a usb to ethernet adapter your interface for the usb adapter should be eth1<br>
If you are using something like a pi zero 2 the interface will be eth0<br>

Once the pi reboots pppwn will run automatically.<br>



## On your PS4:<br>

- Go to `Settings` and then `Network`<br>
- Select `Set Up Internet connection` and choose `Use a LAN Cable`<br>
- Choose `Custom` setup and choose `PPPoE` for `IP Address Settings`<br>
- Enter `ppp` for `PPPoE User ID` and `PPPoE Password`<br>
- NOTE if you enable internet access you must match the username and password entered during the install or use the default `ppp`
- Choose `Automatic` for `DNS Settings` and `MTU Settings`<br>
- Choose `Do Not Use` for `Proxy Server`<br>


For GoldHen you need to place the goldhen.bin file onto the root of a usb drive and plug it into the console.<br>
Once goldhen has been loaded for the first time it will be copied to the consoles internal hdd and the usb is no longer required.<br>
To update goldhen just repeat the above process and the new version will be copied to the internal hdd<br>


## FTP / Binload

If the pi pwn was setup to allow internet access you can use the ftp, klog, and binloader servers on the console<br>
Your pi must be also connected to your home network via wifi or a second ethernet connection<br>
To connect to the servers from your pc just connect to the raspberry pi ip on your network and all requests will be forwarded to the console<br>

For ftp make sure you set the transfer mode on your ftp client software to `Active` not passive.<br>


## USB pass through drive

You can put a usb flash drive in the pi and that will be mounted to the console, you must put a folder on the root of the drive called "payloads"<br>
To use this feature you must plug the raspberry pi 4 / 400 / 5 into the consoles usb port using the usb-c connection on the pi.<br>
If you have power issues you can use a usb Y cable to inject power from another source but in my tests both pi variants ran using a single cable.<br>


## Rest Mode

You can enable the option to detect if goldhen is running in the options which will cause pi-pwn to check if goldhen is active before running pppwn, this is useful for rest mode<br>
If you have the pi powered from the console usb port you must disable "Supply Power to USB Ports" in the rest mode settings of the console.<br>
The console must also use the PPPoe user and pass set for the "console internet connection" of pi-pwn or the defaults if you never changed them which are ppp for both user and password.<br>


## What it does

Once everything is setup and the ethernet cable is plugged in between the pi and the console the pi should automatically try and pwn the console.<br>
The exploit may fail many times but the pi will continue to purge the console to keep trying to pwn itself.<br>
Once pwned the process will stop and the pi will shut down if you are not using internet access. <br>

You will need to restart the pi if you wish to pwn the console again.<br>

The idea is you boot the console and the pi together and the pi will keep trying to pwn the console without any input from you, just wait on the home screen until the process completes<br>

## Updating

You can edit the exploit scripts by putting the sd card in your computer and going to the PPPwn folder.<br>
The commands above can also be run again to install updates or change the settings.<br>
You can also click the update button on the web ui.<br>
