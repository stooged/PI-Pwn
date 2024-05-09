# PI Pwn

this is a script to setup <a href=https://github.com/TheOfficialFloW/PPPwn>PPPwn</a> on the raspberry pi and run <a href=https://github.com/GoldHEN/GoldHEN>GoldHen</a> on the PS4 fw 11.0<br>




[![https://www.youtube.com/watch?v=ebaVTBpM2-0](https://img.youtube.com/vi/ebaVTBpM2-0/0.jpg)](https://www.youtube.com/watch?v=ebaVTBpM2-0)

https://www.youtube.com/watch?v=ebaVTBpM2-0<br>

<br>

Tested on the following models<br>
<a href=https://www.raspberrypi.com/products/raspberry-pi-3-model-b-plus/>Raspberry Pi 3B+</a><br>
<a href=https://www.raspberrypi.com/products/raspberry-pi-4-model-b/>Raspberry Pi 4 Model B</a><br>
<a href=https://www.raspberrypi.com/products/raspberry-pi-5/>Raspberry Pi 5</a><br>

<br>

you need to install <a href=https://www.raspberrypi.com/software/operating-systems/>Raspberry Pi OS Lite</a> onto a sd card.<br>
place the sd card into your computer and copy the PPPwn folder to the sd card.<br>

place the sd card into the raspberry pi and run the following commands<br>


```sh
sudo chmod 777 /boot/firmware/PPPwn/install.sh
sudo bash /boot/firmware/PPPwn/install.sh
```

once the pi reboots pppwn will run automatically.<br>



On your PS4:<br>

- Go to `Settings` and then `Network`<br>
- Select `Set Up Internet connection` and choose `Use a LAN Cable`<br>
- Choose `Custom` setup and choose `PPPoE` for `IP Address Settings`<br>
- Enter anything for `PPPoE User ID` and `PPPoE Password`<br>
- Choose `Automatic` for `DNS Settings` and `MTU Settings`<br>
- Choose `Do Not Use` for `Proxy Server`<br>


for GoldHen you need to place the goldhen.bin file onto the root of a usb drive and plug it into the console


once everything is setup and the ethernet cable is plugged in between the pi and the console the pi should automatically try and pwn the console.<br>
the exploit may fail many times but the pi will continue to purge the console to keep trying to pwn itself.<br>
once pwned the process will stop and the pi will shut down. <br>

you will need to restart the pi if you wish to pwn the console again.<br>

the idea is you boot the console and the pi together and the pi will keep trying to pwn the console without any input from you, just wait on the home screen until the pppwn succeedes.<br>


you can edit the exploit scripts by putting the sd card in your computer and going to the PPPwn folder.<br>
