<?php 

if (isset($_POST['payload'])){
$fso = fsockopen("tcp://192.168.2.2", 9090, $errn, $errs, 30);
if ($fso){
$file = fopen(urldecode($_POST['payload']), "rb");
while (!feof($file)) 
{
   fwrite($fso, fgets($file));
}
fclose($fso);
fclose($file);
}
}
 
if (isset($_POST['reload'])){
	header("Location: payloads.php");
}

if (isset($_POST['back'])){
	header("Location: index.php");
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
</head>
<body>");

print("<br><table align=center><td><form method=\"post\">");

$cmd = 'sudo ls /media/pwndrives';
exec($cmd ." 2>&1", $rdir, $ret);
foreach ($rdir as $x) {
	$cmd = 'sudo ls /media/pwndrives/'.$x;
	exec($cmd ." 2>&1", $pdir, $ret);
	foreach ($pdir as $y) {
		if (strtolower($y) == "payloads")
		{
			$cnt=0;
			$cmd = 'sudo ls /media/pwndrives/'.$x.'/'.$y;
			exec($cmd ." 2>&1", $pldata, $ret);
			if ($ret == 2)
			{
			 	//print("mount error");
			}
			else
			{
			foreach ($pldata as $z) 
			{
				if (str_ends_with($z, ".bin") || str_ends_with($z, ".elf"))
				{
					print("<button name=\"payload\" value=".urlencode('/media/pwndrives/'.$x.'/'.$y.'/'.$z).">".$z."</button>&nbsp; ");
					$cnt++;
					if ($cnt >= 4)
					{
						print("<br>");
						$cnt=0;
					}
				}
		    }
		    goto done;
		    }
		}
	}
}

print("<button name=\"reload\" value=\"reload\">Reload page</button>");
done:
print("</form></td></table><br><br><center>Place payloads in a folder called \"<b>payloads</b>\" on a usb drive and plug it in to the pi.<br>You must also enable the binloader server in goldhen.<br><form method=\"post\"><input type=\"hidden\" value=\"back\"><input type=\"submit\" name=\"back\" value=\"Back to config page\"/></form></center>");
print("</body></html>");

?>