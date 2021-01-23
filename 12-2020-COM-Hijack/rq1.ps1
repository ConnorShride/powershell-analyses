# INPUT PARAMS...
    # $lt9, number of function names to produce (5)
    # $cf0, array of strings
        # 'do3','vb8','yx4','ny1','rt2','__arg1','__arg2','__arg3','__bin','__rwx','__i',
        # '__type', '__unsafe','__href','__size','__encbuf','__off','__key','__fb1','__pld_size','
        # __rva_offset','__prot'

# OUTPUT: an array of length $cf0, where the first $lt9 are random function 
    # names and the rest are random variable names of the format 
    # $<2_random_lowercase_letters><random_number>. Function names the same minus the dollar sign

$cy4=@();
$lc3=0;
for( $lc3; $lc3 -lt $cf0.Count){

	$wo8 =(nj0 2)+(-join ((48..57)|Get-Random -Count 1|%{
	    [char]$_
    }));

    if($lc3 -ge $lt9){
        $wo8 ="`$"+ $wo8 
    }
    if($cy4 -notcontains $wo8) {
        $cy4 += $wo8;
        $lc3++ 
    }
}
$cy4