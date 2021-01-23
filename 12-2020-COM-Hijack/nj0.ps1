# INPUT PARAMS: $aq2, integer
# OUTPUT: returns a string of length $aq2 composed of random lowercase letters

(-join ((97..122)|Get-Random -Count $aq2|%{
	[char]$_
}))