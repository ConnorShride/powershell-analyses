The PowerShell pulled down from meows://sun-city-cafe[.]com/update.dat (**cmd3.ps1**) writes more PowerShell code to load and run a DLL via reflective DLL injection, and installs persistence via COM Object Hijacking or installing a scheduled task with a COM handler. Performs the DLL injection immediately at the end of the script as well as via the installed persistence mechanisms.

Sets multiple registry keys/properties utilizing random GUIDs. Up to 3 random GUIDs may be used that will differ each time this PowerShell is run, so the exact IOCs in the registry will vary in each instance. These GUIDs are expressed as "random_GUID_X".

Registry keys are expressed as "hk(lm|cu):\..." becuase the script will set keys in the "Local Machine" hive if it's running as admin, and "Current User" hive if not.

**For cleanliness, each function in cmd3.ps1 that is used is decoded and separated out into its own file.**

# Function Call Chain
<pre>
cmd1 (download and execute cmd2)
    cmd2    (download and execute cmd3)
        cmd3    (define all functions, call am3)

            am3    (main script)

                fi6    (recon OS version)

                te2    (compile list of GUIDs, task names)
                    vr4    (generate GUIDS, recon and select task name)
                        zt2    (gather scheduled tasks)
                            zt2
                        jv4    (build task paths)
                    yw3    (generate random GUID)

                it2    (set "Default" reg entry)

                sb4Mshta    (wrap loader in mshta.exe)
                    sb4
                        de8   
                        nj0    

                sb4   (build powershell loader)
                    de8   (b64 decode string)
                    nj0   (generate random chars)

                aw9    (build DLL injection script)
                    pz1    (generate useless arithmetic)
                        pz1
                    rq1    (generate random variable/function names)
                        nj0
                    bi8    (build b64 encoded function)
                        de8
                    de8
                    pz0    (generate fake functions)
                        rq1
                        bi8

                xq4    (install admin scheduled task)
                
                nj0_uplow    (generate random chars or digits)
                
                ub3    (obfuscate the DLL)
                
                dc7-secret    (obfuscate the DLL XOR key)
                    db8
</pre>

# Install Persistence...

### If the process is running as Local Administrator...

* installs a scheduled task that runs on boot with the highest privileges under the local service account

* registers the task in a folder that already contains a registered task, with the same name as another randomly selected currently registered task. 
  * If a task already exists under that path and name, overwrites it
  
* task Author and Description are both "Microsoft Corporation"

* task action is a COM handler

### If the process is NOT running as Local Administrator...

* Hijacks the COM handler of either the TextServicesFramework monitor task or the System Sound Service task (see **COM Hijack**)
  * Picks randomly
  * Both run at user logon
  * in either case the COM handler of the scheduled task will invoke the powershell loader when the task is run (see **Loader**)

# Loader

* Script stores the loader in entry (Default) of the registry key mostly unobfuscated
  * hk(lm|cu):\software\classes\CLSID\\<random_GUID_0>\LocalServer

* reads the obfuscated DLL injection script from another reg key, decodes it with the hardcoded key stored in the loader and invokes the script (see **DLL Injection Script**)

* assembled powershell loader in file **sb4-embedded.ps1**, built by **sb4.ps1**

### If the machine is a Windows 10 workstation...

* COM handler of the scheduled task action just runs the powershell loader directly

### If the machine is anything else...

* COM handler of the scheduled task action runs mshta.exe as a parent process to the powershell loader (see **sb4Mshta.ps1**)

# COM Hijack (if process is not running as admin)

Uses a technique called "COM Key Linking" to effectively hijack the COM handler action of a registered scheduled task to run the powershell loader instead, purely by adding and modifying registry keys. Creates a valid COM handler CLSID node structure in the registry and references it as an "emulator" of the hijacked COM handler using the "TreatAs" key in the hijacked handler's CLSID node structure. 

See **COM Key Linking (with TreatAs)** in this [article](https://bohops.com/2018/08/18/abusing-the-com-registry-structure-part-2-loading-techniques-for-evasion-and-persistence/) for more info and **Registry IOCs** for all registry keys this script sets to pull off the attack.

### Hijacks the COM handler action of one of the following scheduled tasks...

* **msctfmonitor**
  * TextServicesFramework monitor task
  * GUID: 01575CFE-9A55-4003-A5E1-F38D1EBDCBE1
  * "TSF is device-independent and enables text services for multiple input devices including keyboard, pen, and microphone."

* **System Sound Service**
  * GUID: 2DEA658F-54C1-4227-AF9B-260AB5FC3543
  * "This scheduled task runs when users log on. It provides operating system-initiated sounds such as navigation sounds."

# DLL Injection Script

* script stores it in the entry *last_4_chars_of_GUID_0* of registry key
  * hk(lm|cu):\software\classes\CLSID\\<random_GUID_0>\ProgID

* assembled DLL injection script in **aw9-embedded.ps1**, built by **aw9.ps1**

* obfuscated by rotating XOR that increments by 4 each byte and never goes above 250 (resets to 0)

* reads both the obfuscated DLL and its decode key (also obfuscated) from other registry entries (see **DLL**)

* deobfuscates the key, decodes the DLL, and performs reflective DLL injection on its own process to run it

* waits 34-68 minutes before exiting to let the DLL finish

# DLL

* Script stores it in entry *last_4_chars_of_GUID_0* of reg key
  * hk(lm|cu):\software\classes\CLSID\\<random_GUID_0>\VersionIndependentProgID

* Script stores the obfuscated key in *first_4_chars_of_GUID_0* of the same reg key as above
  * key is obfuscated by wrapping it in a random number of garbage characters and reversing it (see **dc7-secret.ps1**)

* 64 bit: 99a0c3a57918273a370a2e9af1dc967e92846821c2198fcdddfc732f8cd15ae1
* 32 bit: 9d20722758c3f1a01a70ffddf91553b7a380b46b3690d11d8ba4ba3afe75ade0

* obfuscated by a rotating XOR key derived from the deobfuscated key above, and the length of the DLL itself (see **ub3.ps1**)

* entry point offsets...
    * 32 bit: 11498
    * 64 bit: 14044

# Anti-Analysis and Evasion Summary...

* both the DLL and the DLL injection script is obfuscated with a rotating XOR
  * on the DLL, the key is also obfuscated

* uses random GUIDs in all newly created registry keys

* if installing a scheduled task as admin, uses the name and path of one already registered

* if using COM object Hijacking, executes under one of two scheduled tasks already present on the system

* adds mshta.exe as a parent process to the loader on non-Win10 workstations

* doesn't create remote threads on other processes

* hardcoded integers in the DLL injection script are obfuscated with unnecessary arithmetic expressions

* variable and function names in the injection script are randomized for each instance
    
* in both cmd3.ps1 and the DLL injection script, functions are b64 encoded and intermixed with fake functions that aren't used

# Registry IOCs...

* hk(lm|cu):\software\classes

  * (Default): full path to this script

* hk(lm|cu):\software\classes\\<random_GUID_1>

  * (Default): <random_GUID_1>

* hk(lm|cu):\software\classes\\<random_GUID_1>\CLSID

  * (Default): <random_GUID_0>

* hk(lm|cu):\software\classes\CLSID\\<random_GUID_0>\VersionIndependentProgID

  * (Default): <random_GUID_1>
  * <last_4_chars_of_GUID_0>: obfuscated DLL
  * <first_4_chars_of_GUID_0>: obfuscated decode key

* hk(lm|cu):\software\classes\CLSID\\<random_GUID_0>\ProgID

  * (Default): <random_GUID_1>
  * <last 4 chars of random GUID 0>: obfuscated DLL injection script

* hk(lm|cu):\software\classes\CLSID\\<random_GUID_0>\LocalServer

  * (Default): DLL injection script loader

### If the process is running as Local Administrator

* hklm:\software\classes\CLSID\\<random_GUID_3>\TreatAs

  * (Default): <random_GUID_0>

### If the process is NOT running as Local Administrator

* hkcu:\software\classes\CLSID\\<COM_hijacked_task_GUID>\TreatAs

  * (Default): <random_GUID_0>
