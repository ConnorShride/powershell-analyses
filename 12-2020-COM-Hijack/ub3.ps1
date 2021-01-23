# INPUT PARAMS...
    # $zh0, bytes, DLL to XOR encode
    # $ft4, string, key to use
# OUTPUT: bytes of the XOR encoded DLL. The given key is merely an input for shuffling the integer
# range 0-255, which becomes the real key. The length of the DLL itself also affects the shuffling.

$kf9=0..255;
$gs5=0;
$aw3=$ft4.Length;

# shuffle the range 0-255 based on the contents of the key and it's length, stored in $kf9
0..255 | % {

    $gs5 = ($gs5 + $kf9[$_] + $ft4[$_ % $aw3]) % 256;
    $kf9[$_], $kf9[$gs5] = $kf9[$gs5], $kf9[$_]
}

# XOR bytes in the DLL after more transformations of the $kf9 0-255 range based on the 
# length of the dll
$qu2=$gs5=0;
foreach($qz6 in $zh0) {

    # shuffle the range some more based on the length of the dll
	$qu2 = ($qu2 + 1 ) % 256;
    $gs5 = ($gs5 + $kf9[$qu2]) % 256;
    $kf9[$qu2], $kf9[$gs5] = $kf9[$gs5], $kf9[$qu2];

    $qz6 -bxor $kf9[($kf9[$qu2] + $kf9[$gs5]) % 256]
}