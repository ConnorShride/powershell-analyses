# INPUT PARAM: $rc1, string, key
# OUTPUT: obfuscates the key by reversing it and putting a random number of garbage bytes 
    # before and after it. The 33rd byte tells you how many more bytes there are before the
    # reversed key begins

$du2 = [System.Text.Encoding]::UTF8;
$jl1 = $du2.GetBytes($rc1);
[array]::Reverse($jl1);

# get a random number in range 41-96
$hd1 = (8..64)|Get-Random;
$wv9 = ($hd1 + (32 + 1));

# create byte array with 41-96 chars of garbage, the key, then 72-127 chars of garbage
[byte[]]$bx8 = $du2.GetBytes((db8 $wv9) + $du2.GetString($jl1) + (db8 (((8..64)|Get-Random) + 64)));

# the byte at index 32 tells you how many more bytes of garbage there are before the key starts
$bx8[32] = [byte]$hd1;
$bx8