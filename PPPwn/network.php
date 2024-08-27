<?php 


if (isset($_POST['back'])){
	header("Location: index.php");
	exit;
}

if (isset($_POST['saveppp'])){
	exec('echo \'"'.$_POST["pppu"].'"  *  "'.$_POST["pppw"].'"  192.168.2.2\' | sudo tee /etc/ppp/pap-secrets');
	sleep(1);
	echo "<script type='text/javascript'>alert('PPP Settings Saved');</script>";
}


if (isset($_POST['savewifi'])){
	if (!empty($_POST["wifip"]) && !empty($_POST["wifis"]))
	{   
        exec('sudo rm /etc/NetworkManager/system-connections/preconfigured.nmconnection');
    	$cmd = 'sudo nmcli dev wifi connect "'.$_POST["wifis"].'" password "'.$_POST["wifip"].'"';
        exec($cmd ." 2>&1", $data, $ret);
        foreach ($data as $x) {
            if (!empty($x))
            {			
                if (str_contains($x, 'success')) {
                    echo "<script type='text/javascript'>alert('Wifi Settings Saved');</script>";
                }
    			else
    			{
    				echo "<script type='text/javascript'>alert('Error Saving Wifi Settings');</script>";
    			}
            }
        }
	}
	else
	{
		echo "<script type='text/javascript'>alert('SSID and Password must not be empty');</script>";
	}
}


$cmd = 'sudo cat /etc/ppp/pap-secrets';
exec($cmd ." 2>&1", $data, $ret);
foreach ($data as $x) {
	if (!empty($x))
    { 
		$pppusr= explode("\"", $x)[1];
		$ppppw= explode("\"", $x)[3];
    }
}

if (empty($pppusr)){ $pppusr = "ppp";}
if (empty($ppppw)){ $ppppw = "ppp";}



$cmd = 'sudo cat /etc/NetworkManager/system-connections/preconfigured.nmconnection';
exec($cmd ." 2>&1", $data, $ret);
foreach ($data as $x) {
	if (!empty($x))
    { 
        if (str_contains($x, 'ssid=')) {
            $wifiss= explode("ssid=", $x)[1];
        }
	    if (str_contains($x, 'psk=')) {
            $wifipw= explode("psk=", $x)[1];
        }
    }
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
    color: FFFFFF;
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

input[type=password] {
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
if (window.history.replaceState) {
   window.history.replaceState(null, null, window.location.href);
}
</script>
</head>
<body>
<script>
function showpw() {
  var x = document.getElementById('wifip');
  if (x.type === 'password') {
    x.type = 'text';
  } else {
    x.type = 'password';
  }
}
</script>

");


print("<center><br>
<br>
<br><table align=center><td><form method=\"post\">
<input type=\"text\" name=\"pppu\" id=\"pppu\" value=\"".$pppusr."\" onclick=\"setEnd()\">
<label for=\"pppu\">PPP Username</label>
<br><br>
<input type=\"text\" name=\"pppw\" id=\"pppw\" value=\"".$ppppw."\" onclick=\"setEnd()\">
<label for=\"pppw\">PPP Password</label>
<br><br><br>
<center><button name=\"saveppp\" value=\"saveppp\">Save PPP</button>
</table>
</center>");



print("<center><br>
<br><br><br>
<br><table align=center><td><form method=\"post\">
<input type=\"text\" name=\"wifis\" id=\"wifis\" value=\"".$wifiss."\" onclick=\"setEnd()\">
<label for=\"wifis\">WiFi SSID</label>
<br><br>
<input type=\"password\" name=\"wifip\" id=\"wifip\" value=\"".$wifipw."\" onclick=\"setEnd()\">
<label for=\"wifip\">WiFi Password</label><br>
<input type='checkbox' onclick='showpw()'><label style=\"font-size:12px; padding:4px;\">Show Password</label>
<br><br><br>
<center><button name=\"savewifi\" value=\"savewifi\">Save WiFi</button>
</table>
</center>");


print("<br><br><center>
<form method=\"post\"><input type=\"hidden\" value=\"back\"><input type=\"submit\" name=\"back\" value=\"Back to config page\"/></form></center>");
print("</body></html>");

?>