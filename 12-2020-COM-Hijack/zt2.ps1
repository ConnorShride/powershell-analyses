# INPUT PARAM: $jw1, Task Scheduler folder COM Object
# OUTPUT: list of tasks in given folder (recursive)

$pm2 = $jw1.GetTasks(0);
$pm2|foreach-object {
	 $_ 
}

$ko2=$jw1.GetFolders(0);
$ko2|foreach-object {
	 zt2 $_ $TRUE 
}
 