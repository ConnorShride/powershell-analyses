# GETS MAJOR AND MINOR OS VERSIONS
# returns integers defined in outer scope based on results

# OUTPUT... integer
    # 0 - Any OS older than Vista, Vista Workstations
    # 7 - Server 2008
    # 9 - Windows 7 workstation
    # 8 - 2008 R2 server
    # 10 - server 2012
    # 11 - Windows 8 workstation
    # 12 - server 2012 R2
    # 13 - Windows 8.1 workstation
    # 14 - Server 2016 or 2019
    # 15 - Windows 10 workstation


$zu6 = [environment]::OSVersion.Version|Select-Object -ExpandProperty Major;
$fv0 = [environment]::OSVersion.Version|Select-Object -ExpandProperty Minor;
$mi9 = (Get-WmiObject -Class Win32_OperatingSystem).ProductType;

# windows 10, server 2019 or 2016
if ($zu6 -eq 10) {
	if ($fv0 -eq 0) {
        # workstation
        if ($mi9 -eq 1) {
            return $nm3 
        }
        # DC or server
        else {
            return $au9 
        }
    }
}
# return 0 for anything lower than Windows Vista
if ($zu6 -ne 6) {
	 return $th5 
}
# Vista or Server 2008
if ($fv0 -eq 0) {

    # vista workstation, return 0
    if ($mi9 -eq 1) {
        return $th5 
    }

    # server 2008
    else {
        return $bg1 
    }
}
# Windows 7 or 2008 R2
elseif ($fv0 -eq 1) {

    # 7 workstation
	if ($mi9 -eq 1) {
	    return $vs5 
    }
    # 2008 R2 server
    else {
        return $xh8 
    }
}
# windows 8 or server 2012
elseif ($fv0 -eq 2) {

    # windows 8 workstation
	if ($mi9 -eq 1) {
        return $tu9 
    }
    # server 2012
    else {
        return $fp2 
    }
}
# windows 8.1 or server 2012 R2
elseif ($fv0 -eq 3) {

    # windows 8.1 workstation
	if ($mi9 -eq 1) {
        return $lk7 
    }
    # server 2012 R2
    else {
        return $sx5 
    }
}
return $th5