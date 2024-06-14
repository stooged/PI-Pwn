<?php 

if (isset($_POST['save'])){
	$xfwap = str_replace(" ", "", trim($_POST["xfwap"]));
	$xfgd = str_replace(" ", "", trim($_POST["xfgd"]));
	$xfbs = str_replace(" ", "", trim($_POST["xfbs"]));
	$xfnwb = (isset($_POST["xfnwb"]) ? "true" : "false");
	if (empty($xfwap)){ $xfwap = "1";}
	if (empty($xfgd)){ $xfgd = "4";}
	if (empty($xfbs)){ $xfbs = "0";}
	if (empty($xfnwb)){ $xfnwb = "false";}
	$config = "#!/bin/bash\n";
	$config .= "XFWAP=\\\"".$xfwap."\\\"\n";
	$config .= "XFGD=\\\"".$xfgd."\\\"\n";
	$config .= "XFBS=\\\"".$xfbs."\\\"\n";
	$config .= "XFNWB=".$xfnwb."\n";
	exec('echo "'.$config.'" | sudo tee /boot/firmware/PPPwn/pconfig.sh');
	sleep(1);
}


if (isset($_POST['back'])){
	header("Location: index.php");
	exit;
}


$cmd = 'sudo cat /boot/firmware/PPPwn/pconfig.sh';
exec($cmd ." 2>&1", $data, $ret);
if ($ret == 0){
foreach ($data as $x) {
   if (str_starts_with($x, 'XFWAP')) {
      $xfwap = (explode("=", str_replace("\"", "", $x))[1]);
   }
   elseif (str_starts_with($x, 'XFGD')) {
      $xfgd = (explode("=", str_replace("\"", "", $x))[1]);
   }
   elseif (str_starts_with($x, 'XFBS')) {
      $xfbs = (explode("=", str_replace("\"", "", $x))[1]);
   }
   elseif (str_starts_with($x, 'XFNWB')) {
      $xfnwb = (explode("=", $x)[1]);
   }
}
}else{
   $xfwap = "1";
   $xfgd = "4";
   $xfbs = "0";
   $xfnwb = "false";
}

if (empty($xfwap)){ $xfwap = "1";}
if (empty($xfgd)){ $xfgd = "4";}
if (empty($xfbs)){ $xfbs = "0";}
if (empty($xfnwb)){ $xfnwb = "false";}


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


input[type=text] {
    background: #454545;
	color: #FFFFFF;
	padding: 5px 5px;
    border-radius: 3px;
	border: 1px solid #6495ED;
}

a:active,
a:focus {
    outline: 0;
    border: none;
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

label[id=urllbl] {
    padding: 5px 5px;
	font-size:12px; 
	padding:4px; 
	color:6495ED;
}

label[id=urllbl]:hover,
label[id=urllbl]:focus {
    color: #999999;
    text-decoration: none;
    cursor: pointer;
}

input[type=submit] {
    padding:4px;
    color: #6495ED;
    margin-top: 10px;
    background-color: #0E0E14;
    border: none;
}

input[type=submit]:hover {
    text-decoration: underline;
}
</style>
<script>
var fid;
if (window.history.replaceState) {
   window.history.replaceState(null, null, window.location.href);
}
</script>
</head>
<body>");


print("<br><table align=center><td><form method=\"post\" autocomplete=\"off\">");

$cval = "";
if ($xfnwb == "true")
{
$cval = "checked";
}
print("<br><input type=\"checkbox\" name=\"xfnwb\" value=\"".$xfnwb."\" ".$cval.">
<label for=\"xfnwb\">&nbsp;Only wait for one PADI request</label>
<br>
<div style=\"text-align:left; font-size:12px; padding:10px;\">
By default pppwn will wait for two PADI requests.<br>
According to<a href=\"https://github.com/TheOfficialFloW/PPPwn/pull/48\" style=\"text-decoration:none;\" target=\"_blank\"><label id=\"urllbl\">TheOfficialFloW/PPPwn/pull/48</label></a>this helps to improve stability
</div>
<br><br>");

print("<label for=\"xfwap\">Wait after pin </label><input size=\"4\" type=\"text\" name=\"xfwap\" value=\"".$xfwap."\" style=\"text-align:center;\"><label style=\"text-align:left; font-size:12px; padding:10px;\"> (Default: 1)</label><br>
<div style=\"text-align:left; font-size:12px; padding:10px;\">
According to<a href=\"https://github.com/SiSTR0/PPPwn/pull/1\" style=\"text-decoration:none;\" target=\"_blank\"><label id=\"urllbl\">SiSTR0/PPPwn/pull/1</label></a>setting this parameter to 20 helps to improve stability
</div>
<br><br>");

print("<label for=\"xfgd\">Groom delay&nbsp;</label><input size=\"4\" type=\"text\" name=\"xfgd\" value=\"".$xfgd."\" style=\"text-align:center;\"><label style=\"text-align:left; font-size:12px; padding:10px;\"> (Default: 4)</label><br>
<div style=\"text-align:left; font-size:12px; padding:10px;\">
The Python version of pppwn does not set any wait at Heap grooming. <br>
If the C++ version does not add some wait there is a probability of kernel panic.<br>
You can set any value within 1-4097 (4097 is equivalent to not doing any wait).
</div>
<br><br>");

print("<label for=\"xfbs\">Buffer size&nbsp;&nbsp;&nbsp;&nbsp; </label><input size=\"4\" type=\"text\" name=\"xfbs\" value=\"".$xfbs."\" style=\"text-align:center;\"><label style=\"text-align:left; font-size:12px; padding:10px;\"> (Default: 0)</label><br>
<div style=\"text-align:left; font-size:12px; padding:10px;\">
When running on low-end devices this value can be set to reduce memory usage.<br>
Setting it to 10240 can run normally and the memory usage is about 3MB.<br>
(Note: A value that is too small may cause some packets to not be captured properly)
</div>
<br>");


print("</td></tr><td align=center><br><button name=\"save\">Save</button></td></tr>
</form>
</td>
</table>
<center><form method=\"post\"><input type=\"hidden\" value=\"back\"><input type=\"submit\" name=\"back\" value=\"Back to config page\"/></form></center>
</body>
</html>");

?>