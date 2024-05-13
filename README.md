# PI Pwn

This is a script to setup <a href=https://github.com/TheOfficialFloW/PPPwn>PPPwn</a> and <a href=https://github.com/xfangfang/PPPwn_cpp>PPPwn_cpp</a> on the raspberry pi and run <a href=https://github.com/GoldHEN/GoldHEN>GoldHen</a> on the PS4 fw 11.0<br>
It aso supports internet access after pwn and access to ftp, klog and binloader servers launched by goldhen.<br>
A dns blocker is also installed and used to prevent updates.<br>

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
If you choose to use the Python of PPPwn it is much slower especially on slower devices like the pi zero.<br>

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

## What it does

Once everything is setup and the ethernet cable is plugged in between the pi and the console the pi should automatically try and pwn the console.<br>
The exploit may fail many times but the pi will continue to purge the console to keep trying to pwn itself.<br>
Once pwned the process will stop and the pi will shut down if you are not using internet access. <br>

You will need to restart the pi if you wish to pwn the console again.<br>

The idea is you boot the console and the pi together and the pi will keep trying to pwn the console without any input from you, just wait on the home screen until the process completes<br>

# Updating

You can edit the exploit scripts by putting the sd card in your computer and going to the PPPwn folder.<br>
The install.sh script can also be run again to install changes or change the PPPoE user/password


## install video
[![https://player.vimeo.com/video/945141797?autoplay=1](https://i.vimeocdn.com/video/1850373616-93857870e2a0e3974e00b8e53991557af388fc14b13f305998b8757bc11407f7-d)](https://player.vimeo.com/video/945141797?autoplay=1)

<br>

## internet settings follow up video
[![https://player.vimeo.com/video/945142322?autoplay=1](https://i.vimeocdn.com/video/1850373112-c392e1538902fb22bb8c98558100943e7b8390c029f9e54cb9f27c22da1d6c42-d)](https://player.vimeo.com/video/945142322?autoplay=1)


