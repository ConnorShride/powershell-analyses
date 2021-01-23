# INPUT PARAM: $wh8, integer
# OUTPUT: generate string of length $wh8 composed of either numbers or lowercase letters

-join ((48..57) + (97..122) | Get-Random -Count $wh8 | % {
	[char]$_
})