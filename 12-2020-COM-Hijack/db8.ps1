# INPUT PARAMS: $wh8, number of characters to generate
# OUTPUT: string of random printable non-whitespace characters

-join ((33..126) | Get-Random -Count $wh8 | % {
	[char]$_
})