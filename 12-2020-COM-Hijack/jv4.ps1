# INPUT PARAM: $aq3, full path of a registered task
# OUTPUT: same path rebuilt without \\?

$aq3=$aq3.Split("\");
$mg5="";
for($lc3=0; $lc3 -lt ($aq3.Count-1); $lc3++){
	if($aq3[$lc3].Length){
	    $mg5+=("\"+$aq3[$lc3])
    }
}
$mg5