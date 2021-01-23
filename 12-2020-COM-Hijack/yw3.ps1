# INPUT PARAM: $an9, random number, seed for random GUID
# OUTPUT: a random GUID

$jp3 = "{";
$oc3 = @(4,2,2,2,6);

foreach($sh6 in $oc3) {

	for($bj9=0; $bj9 -lt $sh6; $bj9++) {
	    $jp3 += %{'{0:X2}' -f (Get-Random -SetSeed $an9 -Max 20); $an9++}
    }
 
    if($sh6 -ne 6) {
	    $jp3 += "-" 
    }
}

$jp3 += "}";
$jp3