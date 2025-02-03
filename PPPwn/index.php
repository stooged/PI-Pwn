<?php 

$firmwares = array("7.00", "7.01", "7.02", "7.50", "7.51", "7.55", "8.00", "8.01", "8.03", "8.50", "8.52", "9.00", "9.03", "9.04", "9.50", "9.51", "9.60", "10.00", "10.01", "10.50", "10.70", "10.71", "11.00");
$ledacts = array("off", "normal", "status");

if (isset($_POST['save'])){
	$config = "#!/bin/bash\n";
	$config .= "INTERFACE=\\\"".str_replace(" ", "", trim($_POST["interface"]))."\\\"\n";
	$config .= "FIRMWAREVERSION=\\\"".$_POST["firmware"]."\\\"\n";
	$config .= "SHUTDOWN=".(isset($_POST["shutdownpi"]) ? "true" : "false")."\n";
	$config .= "USBETHERNET=".(isset($_POST["usbether"]) ? "true" : "false")."\n";
	$config .= "PPPOECONN=".(isset($_POST["pppoeconn"]) ? "true" : "false")."\n";
	$config .= "VMUSB=".(isset($_POST["vmusb"]) ? "true" : "false")."\n";
	$config .= "DTLINK=".(isset($_POST["dtlink"]) ? "true" : "false")."\n";
	$config .= "PPDBG=".(isset($_POST["ppdbg"]) ? "true" : "false")."\n";
	$config .= "TIMEOUT=\\\"".str_replace(" ", "", trim($_POST["timeout"]))."\\\"\n";
	$config .= "RESTMODE=".(isset($_POST["restmode"]) ? "true" : "false")."\n";
	$config .= "PYPWN=".(isset($_POST["upypwn"]) ? "true" : "false")."\n";
	$config .= "LEDACT=\\\"".$_POST["ledact"]."\\\"\n";
	$config .= "DDNS=".(isset($_POST["ddns"]) ? "true" : "false")."\n";
	$config .= "OIPV=".(isset($_POST["oipv"]) ? "true" : "false")."\n";
	$config .= "UGH=".(isset($_POST["ugh"]) ? "true" : "false")."\n";
	exec('echo "'.$config.'" | sudo tee /boot/firmware/PPPwn/config.sh');
	exec('echo "'.trim($_POST["plist"]).'" | sudo tee /boot/firmware/PPPwn/ports.txt');
 	exec('sudo iptables -P INPUT ACCEPT');
 	exec('sudo iptables -P FORWARD ACCEPT');
 	exec('sudo iptables -P OUTPUT ACCEPT');
 	exec('sudo iptables -t nat -F');
 	exec('sudo iptables -t mangle -F');
 	exec('sudo iptables -F');
 	exec('sudo iptables -X');
	exec('sudo sysctl net.ipv4.ip_forward=1');
 	exec('sudo sysctl net.ipv4.conf.all.route_localnet=1');
 	exec('sudo iptables -t nat -I PREROUTING -s 192.168.2.0/24 -p udp -m udp --dport 53 -j DNAT --to-destination 127.0.0.1:5353');
	$plst = explode(",",trim($_POST["plist"]));
	for($i = 0; $i < count($plst); ++$i) {
	 	exec('sudo iptables -t nat -I PREROUTING -p tcp --dport '.str_replace("-", ":", $plst[$i]).' -j DNAT --to 192.168.2.2:'.str_replace(":", "-", $plst[$i]));
		exec('sudo iptables -t nat -I PREROUTING -p udp --dport '.str_replace("-", ":", $plst[$i]).' -j DNAT --to 192.168.2.2:'.str_replace(":", "-", $plst[$i]));
	}
 	exec('sudo iptables -t nat -A POSTROUTING -s 192.168.2.0/24 ! -d 192.168.2.0/24 -j MASQUERADE');

    if (isset($_POST["vmusb"]) == true)
	{
      exec('sudo bash /boot/firmware/PPPwn/remount.sh &');
	}
	else
	{
      exec('sudo rmmod g_mass_storage');
	}
	if (isset($_POST["ddns"]) == true)
	{
      exec('sudo bash /boot/firmware/PPPwn/disdns.sh &');
	}
	else
	{
      exec('sudo bash /boot/firmware/PPPwn/endns.sh &');
	}
	if (isset($_POST["pppoeconn"]) == true)
	{
      $cmd = 'sudo systemctl is-active pipwn';
      exec($cmd ." 2>&1", $sresp, $pret);
	  if (implode($sresp) != "active")
	  {
		$cmd = 'sudo systemctl is-active pppoe';
		exec($cmd ." 2>&1", $presp, $pret);
		if (implode($presp) != "active")
		{
			exec('sudo systemctl start pppoe'); 
		}
	  }
	}
	else
	{
      exec('sudo systemctl stop pppoe');
	}
	sleep(1);
}
 
if (isset($_POST['restart'])){
   exec('echo "\033[32mRestarting\033[0m"  | sudo tee /dev/tty1 && sudo systemctl restart pipwn');
}

if (isset($_POST['reboot'])){
	
   print("<html><head><title>PI-Pwn</title><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"></head><style>body{user-select: none;-webkit-user-select: none;background-color: #0E0E14;color: white;font-family: Arial;font-size:20px;}a {padding: 5px 5px;font-size:20px; padding:4px; color:6495ED;} a:hover,a:focus {color: #999999;text-decoration: none;cursor: pointer;}</style><body><br><br><br><center>The PI is rebooting...<br><br><a href=index.php>Reload Page</a></center></body></html>");
   exec('sudo reboot');
   exit;
}
 
if (isset($_POST['shutdown'])){
   print("<html><head><title>PI-Pwn</title><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"></head><style>body{user-select: none;-webkit-user-select: none;background-color: #0E0E14;color: white;font-family: Arial;font-size:20px;}</style><body><br><br><br><center>The PI is shutting down!</center></body></html>");
   exec('sudo poweroff');
   exit;
}

if (isset($_POST['payloads'])){
   header("Location: payloads.php");
   exit;
}

if (isset($_POST['network'])){
   header("Location: network.php");
   exit;
}

if (isset($_POST['remount'])){
   exec('sudo bash /boot/firmware/PPPwn/remount.sh &');
}


$cmd = 'sudo cat /boot/firmware/PPPwn/config.sh';
exec($cmd ." 2>&1", $data, $ret);
if ($ret == 0){
foreach ($data as $x) {
   if (str_starts_with($x, 'INTERFACE')) {
      $interface = (explode("=", str_replace("\"", "", $x))[1]);
   }
   elseif (str_starts_with($x, 'FIRMWAREVERSION')) {
      $firmware = (explode("=", str_replace("\"", "", $x))[1]);
   }
   elseif (str_starts_with($x, 'SHUTDOWN')) {
      $shutdownpi = (explode("=", $x)[1]);
   }
   elseif (str_starts_with($x, 'USBETHERNET')) {
      $usbether = (explode("=", $x)[1]);
   }
   elseif (str_starts_with($x, 'PPPOECONN')) {
      $pppoeconn = (explode("=", $x)[1]);
   }
   elseif (str_starts_with($x, 'VMUSB')) {
      $vmusb = (explode("=", $x)[1]);
   }
   elseif (str_starts_with($x, 'DTLINK')) {
      $dtlink = (explode("=", $x)[1]);
   }
   elseif (str_starts_with($x, 'PPDBG')) {
      $ppdbg = (explode("=", $x)[1]);
   }
   elseif (str_starts_with($x, 'TIMEOUT')) {
      $timeout = (explode("=", str_replace("\"", "", $x))[1]);
   }
   elseif (str_starts_with($x, 'RESTMODE')) {
      $restmode = (explode("=", $x)[1]);
   }
   elseif (str_starts_with($x, 'PYPWN')) {
      $upypwn = (explode("=", $x)[1]);
   }
   elseif (str_starts_with($x, 'LEDACT')) {
      $ledact = (explode("=", str_replace("\"", "", $x))[1]);
   }
   elseif (str_starts_with($x, 'DDNS')) {
      $ddns = (explode("=", $x)[1]);
   }
   elseif (str_starts_with($x, 'OIPV')) {
      $oipv = (explode("=", $x)[1]);
   }
   elseif (str_starts_with($x, 'UGH')) {
      $ugh = (explode("=", $x)[1]);
   }
}
}else{
   $interface = "eth0";
   $firmware = "11.00";
   $shutdownpi = "true";
   $usbether = "false";
   $pppoeconn = "false";
   $vmusb = "false";
   $dtlink = "false";
   $ppdbg = "false";
   $timeout = "5m";
   $restmode = "false";
   $upypwn = "false";
   $ledact = "normal";
   $ddns = "false";
   $oipv = "false";
   $ugh = "true";
}


if (empty($interface)){ $interface = "eth0";}
if (empty($firmware)){ $firmware = "11.00";}
if (empty($shutdownpi)){ $shutdownpi = "true";}
if (empty($usbether)){ $usbether = "false";}
if (empty($pppoeconn)){ $pppoeconn = "false";}
if (empty($vmusb)){ $vmusb = "false";}
if (empty($dtlink)){ $dtlink = "false";}
if (empty($ppdbg)){ $ppdbg = "false";}
if (empty($timeout)){ $timeout = "5m";}
if (empty($upypwn)){ $upypwn = "false";}
if (empty($ledact)){ $ledact = "normal";}
if (empty($ddns)){ $ddns = "false";}
if (empty($oipv)){ $oipv = "false";}
if (empty($ugh)){ $ugh = "true";}


$cmd = 'sudo cat /boot/firmware/PPPwn/ports.txt';
exec($cmd ." 2>&1", $pdata, $pret);
if ($pret == 0){
   $portlist = "";
   foreach ($pdata as $x) {
      $portlist .= trim($x);
   }
}else{
   $portlist = "2121,3232,9090,8080,12800,1337";	
}


print("<html> 
<head>
<title>PI-Pwn</title>
<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
<style>

body {
	user-select: none;
    -webkit-user-select: none;
    background-color: #0E0E14;
    color: white;
    font-family: Arial;
}

select {
    background: #454545;
	color: #FFFFFF;
	padding: 3px 5px;
    border-radius: 3px;
	border: 1px solid #6495ED;
}


input[type=text] {
    background: #454545;
	color: #FFFFFF;
	padding: 5px 5px;
    border-radius: 3px;
	border: 1px solid #6495ED;
}

a:active,a:hover,
a:focus {
    outline: 0;
    border: none;
	color: #999999;
    text-decoration: none;
    cursor: pointer;
}

a {
	font-size:12px; 
	text-decoration: none;
	color:6495ED;
}

button {
    border: 1px solid #6495ED;
    color: #FFFFFF;
    background: #454545;
    padding: 10px 20px;
    margin-bottom:12px;
    border-radius: 3px;
}

button:hover {
    background: #999999;
}

input:focus {
    outline:none;
}

label {
    padding: 5px 5px;
}

input[type=checkbox] {
    position: relative;
    cursor: pointer;
}

input[type=checkbox]:before {
    content: \"\";
    display: block;
    position: absolute;
    width: 17px;
    height: 17px;
    top: 0;
    left: 0;
    background-color:#e9e9e9;
}

input[type=checkbox]:checked:before {
    content: \"\";
    display: block;
    position: absolute;
    width: 17px;
    height: 17px;
    top: 0;
    left: 0;
    background-color:#1E80EF;
}

input[type=checkbox]:checked:after {
    content: \"\";
    display: block;
    width: 3px;
    height: 8px;
    border: solid white;
    border-width: 0 2px 2px 0;
    -webkit-transform: rotate(45deg);
    -ms-transform: rotate(45deg);
    transform: rotate(45deg);
    position: absolute;
    top: 2px;
    left: 6px;
}	
	
.logger {
    display: none; 
    position: fixed; 
    z-index: 1; 
    padding-top: 100px; 
    padding-bottom: 100px;
    left: 0;
    top: 0;
    width: 100%; 
    height: 60%; 
    overflow-x:hidden;
    overflow-y:hidden;
    background-color: #00000000;
}


.logger-content {
    position: relative;
    background-color: #0E0E14;
    margin: auto;
    padding: 0;
    border: 1px solid #6495ED;
    width: 80%;
    box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
    -webkit-animation-name: animatetop;
    -webkit-animation-duration: 0.4s;
    animation-name: animatetop;
    animation-duration: 0.4s
}


@-webkit-keyframes animatetop {
    from {top:-300px; opacity:0} 
    to {top:0; opacity:1}
}

@keyframes animatetop {
    from {top:-300px; opacity:0}
    to {top:0; opacity:1}
}


.close {
    color: #6495ED;
    float: right;
    font-size: 28px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: #999999;
    text-decoration: none;
    cursor: pointer;
}

.logger-header {
    padding: 2px 8px;
    background-color: #0E0E14;
    color: 0E0E14;
}

.logger-body 
{
    padding: 2px 8px;
}

textarea {
    resize: none;
    border: none;
    background-color: #0E0E14;
    color: #FFFFFF;
    box-sizing:border-box;
    height: 100%;
    width: 100%;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;    
    box-sizing: border-box;         
}

label[id=pwnlog] {
    padding: 5px 5px;
	font-size:12px; 
	padding:4px; 
	color:6495ED;
}

label[id=pwnlog]:hover,
label[id=pwnlog]:focus {
    color: #999999;
    text-decoration: none;
    cursor: pointer;
}

label[id=help] {
    padding: 5px 5px;
	font-size:12px; 
	padding:4px; 
	color:6495ED;
}

label[id=help]:hover,
label[id=help]:focus {
    color: #999999;
    text-decoration: none;
    cursor: pointer;
}

label[id=pconfig] {
    padding: 5px 5px;
	font-size:12px; 
	padding:4px; 
	color:6495ED;
}

label[id=pconfig]:hover,
label[id=pconfig]:focus {
    color: #999999;
    text-decoration: none;
    cursor: pointer;
}

div[id=help]{
    height:100%;
    overflow:auto;
    overflow-x:hidden;
	scrollbar-color: #6495ED #0E0E14;
    scrollbar-width: thin;
}

</style>
<script>
var fid;
if (window.history.replaceState) {
   window.history.replaceState(null, null, window.location.href);
}

function startLog(lf) {
   fid = setInterval(updateLog, 2000, lf);
}

function stopLog() {
  clearInterval(fid);
}

function updateLog(f) {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', '/' + f);
	xhr.setRequestHeader('Cache-Control', 'no-cache');
	xhr.responseType = \"text\";
	xhr.onload = () => {
	if (!xhr.responseURL.includes(f)) {
	xhr.abort();
	return;
	}
	if (xhr.readyState === xhr.DONE) {
    if (xhr.status === 200) {
	document.getElementById(\"text_box\").value = xhr.responseText;
	var textarea = document.getElementById('text_box');
	textarea.scrollTop = textarea.scrollHeight;
	}
  }
};
xhr.send();
}

function setEnd() {
	if (navigator.userAgent.includes('PlayStation 4')) {
		let name = document.getElementById(\"plist\");
		name.focus();
		name.selectionStart = name.value.length;
		name.selectionEnd = name.value.length;	
	}
}
</script>
</head>
<body>
<center>

<div id=\"pwnlogger\" class=\"logger\">
<div class=\"logger-content\">
<div class=\"logger-header\">
<a href=\"javascript:void(0);\" style=\"text-decoration:none;\"><span class=\"close\">&times;</span></a></div>
<div class=\"logger-body\">
</div></div></div>
<br>
<form method=\"post\"><button name=\"payloads\">Load Payloads</button> &nbsp; ");



$cmd = 'sudo tr -d \'\0\' </proc/device-tree/model';
exec($cmd ." 2>&1", $pidata, $ret);
if (str_starts_with(trim(implode($pidata)),  "Raspberry Pi 4") || str_starts_with(trim(implode($pidata)), "Raspberry Pi 5"))
{
$cmd = 'sudo cat /boot/firmware/config.txt | grep "dtoverlay=dwc2"';
exec($cmd ." 2>&1", $dwcdata, $ret);
$dwcval = trim(implode($dwcdata)); 
if ($vmusb == "true" && ! empty($dwcval))
{
print("<button name=\"remount\">Remount USB</button> &nbsp; ");
}
}


print("<button name=\"network\">Network Settings</button> &nbsp; <button name=\"restart\">Restart PPPwn</button> &nbsp; <button name=\"reboot\">Reboot PI</button> &nbsp; <button 
name=\"shutdown\">Shutdown PI</button> &nbsp; <button name=\"patch\">Update Raspbian/OS</button> &nbsp;  <button name=\"update\">Update</button>
</form>
</center><br><table align=center><td><form method=\"post\">");


print("<select name=\"interface\">");
$cmd = 'sudo ip link | cut -d " " -f-2 | cut -d ":" -f2-2 ';
exec($cmd ." 2>&1", $idata, $iret);
foreach ($idata as $x) {
$x = trim($x);
if ($x !== "" && $x !== "lo" && $x !== "ppp0" && !str_starts_with($x, "wlan"))
{
if ( $interface ==  $x)
{
print("<option value=\"".$x."\" selected>".$x."</option>");
}else{
print("<option value=\"".$x."\">".$x."</option>");
}
}
}
print("</select><label for=\"interface\">&nbsp; Interface</label><br><br>");



print("<select name=\"firmware\">");
foreach ($firmwares as $fw) {
if ($firmware == $fw)
{
	print("<option value=\"".$fw."\" selected>".$fw."</option>");
}else{
	print("<option value=\"".$fw."\">".$fw."</option>");
}
}
print("</select><label for=\"firmware\">&nbsp; Firmware version</label><br><br>");



print("<select name=\"timeout\">");
for($x =1; $x<=5;$x++)
{
   if ($timeout == $x."m")
   {
	   print("<option value=\"".$x."m\" selected>".$x."m</option>");
   }else{
	   print("<option value=\"".$x."m\">".$x."m</option>");
   }
} 
print("</select><label for=\"timeout\">&nbsp; Time to restart PPPwn if it hangs</label><br><br>");



print("<select name=\"ledact\">");
foreach ($ledacts as $la) {
if ($ledact == $la)
{
	print("<option value=\"".$la."\" selected>".$la."</option>");
}else{
	print("<option value=\"".$la."\">".$la."</option>");
}
}
print("</select><label for=\"ledact\">&nbsp; Led activity</label><br><br>");



$cmd = 'sudo dpkg-query -W --showformat="\${Status}\\n" python3-scapy | grep "install ok installed"';
exec($cmd ." 2>&1", $pypdata, $ret);
if (implode($pypdata) == "install ok installed")
{
$cval = "";
if ($upypwn == "true")
{
$cval = "checked";
}
print("<br><input type=\"checkbox\" name=\"upypwn\" value=\"".$upypwn."\" ".$cval.">
<label for=\"upypwn\">&nbsp;Use Python version</label>");
if ($upypwn == "false")
{
print("&nbsp; <a href=\"pconfig.php\" style=\"text-decoration:none;\"><label id=\"pconfig\">PPPwn C++ Options</label></a>");
}
print("<br>");
}else{
print("<a href=\"pconfig.php\" style=\"text-decoration:none;\"><label id=\"pconfig\">PPPwn C++ Options</label></a><br>");
}


$cval = "";
if ($ugh == "true")
{
$cval = "checked";
}
print("<br><input type=\"checkbox\" name=\"ugh\" value=\"".$ugh."\" ".$cval.">
<label for=\"ugh\">&nbsp;Use GoldHen if available for selected firmware</label>
<br>");



$cval = "";
if ($oipv == "true")
{
$cval = "checked";
}
print("<br><input type=\"checkbox\" name=\"oipv\" value=\"".$oipv."\" ".$cval.">
<label for=\"oipv\">&nbsp;Use original source ipv6<label style=\"font-size:12px; padding:4px;\">(fe80::4141:4141:4141:4141)</label></label>
<br>");



$cval = "";
if ($usbether == "true")
{
$cval = "checked";
}
print("<br><input type=\"checkbox\" name=\"usbether\" value=\"".$usbether."\" ".$cval.">
<label for=\"usbether\">&nbsp;Use usb ethernet adapter for console connection</label>
<br>");


if ($ugh == "true")
{
$cval = "";
if ($restmode == "true")
{
$cval = "checked";
}
print("<br><input type=\"checkbox\" name=\"restmode\" value=\"".$restmode."\" ".$cval.">
<label for=\"restmode\">&nbsp;Detect if goldhen is running<label style=\"font-size:12px; padding:4px;\">(useful for rest mode)</label></label>
<br>");
}


if ($shutdownpi == "false" || $pppoeconn == "true")
{
$cval = "";
if ($dtlink == "true")
{
$cval = "checked";
}
print("<br><input type=\"checkbox\" name=\"dtlink\" value=\"".$dtlink."\" ".$cval.">
<label for=\"dtlink\">&nbsp;Detect console shutdown and restart PPPwn</label>
<br>");
}



if ($ppdbg == "true")
{
print("<br><input type=\"checkbox\" name=\"ppdbg\" value=\"".$ppdbg."\" checked>
<label for=\"ppdbg\">&nbsp;Enable verbose PPPwn</label> &nbsp; <a href=\"javascript:void(0);\" style=\"text-decoration:none;\"><label id=\"pwnlog\">Open Log Viewer</label></a>
<br>");
}
else
{
print("<br><input type=\"checkbox\" name=\"ppdbg\" value=\"".$ppdbg."\">
<label for=\"ppdbg\">&nbsp;Enable verbose PPPwn</label>
<br>");
}



$cval = "";
if ($pppoeconn == "true")
{
$cval = "checked";
}
print("<br><input type=\"checkbox\" name=\"pppoeconn\" value=\"".$pppoeconn."\" ".$cval.">
<label for=\"pppoeconn\">&nbsp;Enable console internet access</label>
<br>");



$cval = "";
if ($ddns == "true")
{
$cval = "checked";
}
print("<br><input type=\"checkbox\" name=\"ddns\" value=\"".$ddns."\" ".$cval.">
<label for=\"ddns\">&nbsp;Disable DNS blocker</label>
<br>");



if ($pppoeconn == "false")
{
$cval = "";
if ($shutdownpi == "true")
{
$cval = "checked";
}
print("<br><input type=\"checkbox\" name=\"shutdownpi\" value=\"".$shutdownpi."\" ".$cval.">
<label for=\"shutdownpi\">&nbsp;Shutdown PI after PWN</label>
<br>");
}



if (str_starts_with(trim(implode($pidata)),  "Raspberry Pi 4") || str_starts_with(trim(implode($pidata)), "Raspberry Pi 5"))
{
if (! empty($dwcval))	
{	
$cval = "";
if ($vmusb == "true")
{
$cval = "checked";
}
print("<br><input type=\"checkbox\" name=\"vmusb\" value=\"".$vmusb."\" ".$cval.">
<label for=\"vmusb\">&nbsp;Enable usb drive to console</label>");
}
}


print("<br>
<br>
<label for=\"plist\">Ports: </label>
<input type=\"text\" name=\"plist\" id=\"plist\" value=\"".$portlist."\" onclick=\"setEnd()\"><br>
<div style=\"text-align:left; font-size:12px; padding:4px;\">
<label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Accepts ranges: 1000-1100</label>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href=\"javascript:void(0);\" style=\"text-decoration:none;\"><label id=\"help\">Show Help</label></a>

</div>");

print("</td></tr><td align=center><br><button name=\"save\">Save</button></td></tr>
</form>
</td>
</table>
<script>
var logger = document.getElementById(\"pwnlogger\");
var span = document.getElementsByClassName(\"close\")[0];
");


if ($ppdbg == "true")
{
print("var btn = document.getElementById(\"pwnlog\");
btn.onclick = function() {
  logger.style.display = \"block\";
  var lbody = document.getElementsByClassName(\"logger-body\")[0];
  lbody.innerHTML  = '<textarea disabled id=\"text_box\" rows=\"40\"></textarea>';
  startLog('pwn.log');
}
");
}


print("var btn1 = document.getElementById(\"help\");
btn1.onclick = function() {
  logger.style.display = \"block\";
  var lbody = document.getElementsByClassName(\"logger-body\")[0];
  lbody.innerHTML  = \"<br><div id=help style='text-align: left; font-size: 14px;'> <font color='#F28C28'>Interface</font> - this is the lan interface on the pi that is connected to the console.<br><br><font color='#F28C28'>Firmware version</font> - version of firmware running on the console.<br><br><font color='#F28C28'>Time to restart PPPwn if it hangs</font> - a timeout in minutes to restart pppwn if the exploit hangs mid process.<br><br><font color='#F28C28'>Led activity</font> - on selected pi models this will have the leds flash based on the exploit progress.<br><br><font color='#F28C28'>Use Python version</font> - enabling this will force the use of the original python pppwn released by <a href='https://github.com/TheOfficialFloW/PPPwn' target='_blank'>TheOfficialFloW</a> <br><br><font color='#F28C28'>Use GoldHen if available for selected firmware</font> - if this is not enabled or your firmware has no goldhen available vtx-hen will be used.<br><br><font color='#F28C28'>Use original source ipv6</font> - this will force pppwn to use the original ipv6 address that was used in pppwn as on some consoles it increases the speed of pwn.<br><br><font color='#F28C28'>Use usb ethernet adapter for console connection</font> - only enable this if you are using a usb to ethernet adapter to connect to the console.<br><br><font color='#F28C28'>Detect if goldhen is running</font> - this will make pi-pwn check if goldhen is loaded on the console and skip running pppwn if it is running.<br><br><font color='#F28C28'>Detect console shutdown and restart PPPwn</font> - with this enabled if the link is lost between the pi and the console pppwn will be restarted.<br><br><font color='#F28C28'>Enable verbose PPPwn</font> - enables debug output from pppwn so you can see the exploit progress.<br><br><font color='#F28C28'>Enable console internet access</font> - enabling this will make pi-pwn setup a connection to the console allowing internet access after pppwn succeeds.<br><br><font color='#F28C28'>Disable DNS blocker</font> - enabling this will turn off the dns blocker that blocks certain servers that are used for updates and telemetry. <br><br><font color='#F28C28'>Shutdown PI after PWN</font> - if enabled this will make the pi shutdown after pppwn succeeds.<br><br><font color='#F28C28'>Enable usb drive to console</font> - on selected pi models this will allow a usb drive in the pi to be passed through to the console.<br><br><font color='#F28C28'>Ports</font> - this is a list of ports that are forwarded from the pi to the console, single ports or port ranges can be used.<br><br><br><br><center><font color='#50C878'>Credits</font> - all credit goes to <a href='https://github.com/TheOfficialFloW' target='_blank'>TheOfficialFloW</a>, <a href='https://github.com/xfangfang' target='_blank'>xfangfang</a>, <a href='https://github.com/SiSTR0' target='_blank'>SiSTR0</a>, <a href='https://github.com/xvortex' target='_blank'>Vortex</a>, <a href='https://github.com/EchoStretch' target='_blank'>EchoStretch</a>, <a href='https://github.com/nn9dev' target='_blank'>nn9dev</a> and many other people who have made this project possible.</center>\";
}

span.onclick = function() {
  logger.style.display = \"none\";
  stopLog();
  var text1 = document.getElementById(\"text_box\");
  text1.value = '';
}

window.onclick = function(event) {
  if (event.target == logger) {
    logger.style.display = \"none\";
	stopLog();
	var text1 = document.getElementById(\"text_box\");
	text1.value = '';
  }
}
");

if (isset($_POST['patch'])){
        exec('sudo bash /boot/firmware/PPPwn/patch.sh >> /dev/null &');
    print("logger.style.display = \"block\";
    var lbody = document.getElementsByClassName(\"logger-body\")[0];
    lbody.innerHTML  = '<textarea disabled id=\"text_box\" rows=\"40\"></textarea>';
    startLog('patch.log');");
}

if (isset($_POST['update'])){
	exec('sudo bash /boot/firmware/PPPwn/update.sh >> /dev/null &');
    print("logger.style.display = \"block\";
    var lbody = document.getElementsByClassName(\"logger-body\")[0];
    lbody.innerHTML  = '<textarea disabled id=\"text_box\" rows=\"40\"></textarea>';
    startLog('upd.log');");
}

print("</script>
</body>
</html>");

?>
