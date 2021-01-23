# INPUT PARAMS...
    # $wh2, integer, number the expression will sum to
    # $av3, integer, influences number of terms to use?
# OUTPUT: produces an expression adding/subtracting terms to equal 256

if($wh2) {
    $fz4 = Get-Random -Maximum $wh2;
    if($av3) {
        $ij2 = $av3;
        $ij2--;
        $ja2 = $fz4.ToString();
        $ts9=@(((pz1 ($fz4 + $wh2) $ij2).ToString()+"-"+ $ja2),(($fz4 + $wh2).ToString()+"-"+(pz1 $fz4 $ij2).ToString()))|Get-Random;
        $au4=@(((pz1 ($wh2 - $fz4) $ij2).ToString()+"+"+ $ja2),(($wh2 - $fz4).ToString()+"+"+(pz1 $fz4 $ij2).ToString()))|Get-Random;
        $pr1 = @($ts9,$au4,(pz1 $wh2 $ij2))|Get-Random 
    }
    else{
        $ja2 = $fz4.ToString();
        $pr1 = @((($fz4 + $wh2).ToString()+"-"+ $ja2),(($wh2 - $fz4).ToString()+"+"+ $ja2),$wh2)|Get-Random 
    }
}
# if wh2 is zero, maybe do cheeky things like an XOR that yeilds a zero 
else {
    $fz4 = Get-Random -Maximum 0x54656845;
    $ja2 = $fz4.ToString();
    $pr1 = @(($ja2+"-"+ $ja2),($ja2+" -bxor "+ $ja2),0)|Get-Random 
}

$fz4 = $pr1 -split "";
if($fz4 -contains "+" -or $fz4 -contains "-"){
    ("("+ $pr1 +")")
}
else{
    $pr1 
}