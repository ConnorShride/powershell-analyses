# INPUT PARAMS...
    # $hf2: path to a reg key
    # $tp9: value to set for the entry "(Default)"
# OUTPUT: 
    # sets the registry entry (Default):<value of $tp9>

New-ItemProperty -Path $hf2 -Name "(Default)" -PropertyType String -Value $tp9 -force|Out-Null