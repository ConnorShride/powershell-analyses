# INPUT PARAM: $an9, random number
# OUTPUT: 3 element list...
    # random scheduled task path from currently registered tasks in \Microsoft\Windows
    # random scheduled task name from currently registered tasks in \Microsoft\Windows
    # random GUID, either {01575CFE-9A55-4003-A5E1-F38D1EBDCBE1} or {2DEA658F-54C1-4227-AF9B-260AB5FC3543}"

$yl8 = "\Microsoft\Windows";
$rg6 = new-object -comobject "Schedule.Service";
$rg6.Connect();

# get scheduled tasks stored in folder \Microsoft\Windows
$hx1 = $rg6.GetFolder($yl8);
$hv7 = zt2 $hx1;

$ig7 = @(); # names of scheduled tasks
$sa7 = @(); # full paths of scheduled tasks
$yh0 = @();

# iterate over the registered tasks in that folder, save all names and paths
foreach ($rn6 in $hv7) {
    $ig7 += $rn6.Name;
    $sa7 += (jv4 $rn6.Path);
}

$cn8 = "";
$fr9 = "";
$ms6 = "";

# choose a random path from that list of tasks
if($sa7.Length) {
	$sa7 = $sa7 | sort -Unique;
    $cn8 = Get-Random -SetSeed $an9 -InputObject $sa7;
    $an9++ 
}

# choose a random name from that list of tasks
if($ig7.Length) {
	$fr9 = Get-Random -SetSeed $an9 -InputObject $ig7;
    $an9++ 
}

# choose a random SID
$ms6 = @("{01575CFE-9A55-4003-A5E1-F38D1EBDCBE1}", "{2DEA658F-54C1-4227-AF9B-260AB5FC3543}")| Get-Random;

@($cn8, $fr9, $ms6)