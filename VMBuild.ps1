$vms = Import-CSV D:\PSScripts\vmware\deploy.csv
$localPW = read-host  -AsSecureString “Please enter the local admin password”
$userName = read-host “Please type a username that can add machines to the domain”
$userPW = read-host -AsSecureString “Please enter your password”
$pLocalPW = [system.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.runtime.InteropServices.Marshal]::SecureStringToBSTR($localPW))
$pUserPW = [system.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.runtime.InteropServices.Marshal]::SecureStringToBSTR($userPW))
$Tasks = @()
foreach ($vm in $vms)
{
$Template = Get-Template $vm.template
$VMHost = Get-VMHost $vm.host
$Datastore = Get-Datastore $vm.datastore
$OSCustomization = Get-OSCustomizationSpec $vm.customization
$Task = New-VM -Name $vm.name -OSCustomizationSpec $OSCustomization -Template $Template -VMHost $VMHost -Datastore $Datastore -RunAsync  -DiskStorageFormat Thin
}
Wait-Task -Task $Task
Echo “Machines finished cloning.  Now applying Customization Templates.  Please wait.”
foreach ($vm in $vms)
{
$Network = $vm.network
Get-VM  $vm.name | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $Network -confirm:$false
Start-VM $vm.name
# while (get-guestvm)
}
echo “Waiting 30 minutes for machines to finish applying Customization Templates.  Please Wait.”
$x = 30*60
$length = $x / 100
while($x -gt 0)
{
$min = [int](([string]($x/60)).split(‘.’)[0])
$text = ” ” + $min + ” minutes ” + ($x % 60) + ” seconds left”
Write-Progress “Pausing Script” -status $text -perc ($x/$length)
start-sleep -s 1
$x–
}
cls
foreach ($vm in $vms)
{
$vmguest = $vm.name
$vmguestIP = get-vmguest $vmguest
$vmIP = $vmguestIP.IPaddress
.\psexec \\$vmIP -u administrator -p $plocalPW netdom join  $vmguest /domain:domain.com /userd:$userName /passwordd:$puserPW
.\psexec \\$vmIP -u administrator -p $plocalPW shutdown -r -t 0
}
$vms = Import-CSV D:\PSScripts\vmware\deploy.csv$localPW = read-host  -AsSecureString “Please enter the local admin password”$userName = read-host “Please type a username that can add machines to the domain”$userPW = read-host -AsSecureString “Please enter your password”$pLocalPW = [system.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.runtime.InteropServices.Marshal]::SecureStringToBSTR($localPW))$pUserPW = [system.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.runtime.InteropServices.Marshal]::SecureStringToBSTR($userPW))$Tasks = @()
foreach ($vm in $vms)	{	 $Template = Get-Template $vm.template	 $VMHost = Get-VMHost $vm.host	 $Datastore = Get-Datastore $vm.datastore	 $OSCustomization = Get-OSCustomizationSpec $vm.customization	 $Task = New-VM -Name $vm.name -OSCustomizationSpec $OSCustomization -Template $Template -VMHost $VMHost -Datastore $Datastore -RunAsync  -DiskStorageFormat Thin	}	Wait-Task -Task $Task Echo “Machines finished cloning.  Now applying Customization Templates.  Please wait.”  foreach ($vm in $vms)	{	 $Network = $vm.network	 Get-VM  $vm.name | Get-NetworkAdapter | Set-NetworkAdapter -NetworkName $Network -confirm:$false	 Start-VM $vm.name	 # while (get-guestvm)	}	echo “Waiting 30 minutes for machines to finish applying Customization Templates.  Please Wait.”
$x = 30*60$length = $x / 100while($x -gt 0) 	{  	 $min = [int](([string]($x/60)).split(‘.’)[0])   $text = ” ” + $min + ” minutes ” + ($x % 60) + ” seconds left”  	 Write-Progress “Pausing Script” -status $text -perc ($x/$length)  	 start-sleep -s 1  	 $x–	} cls	foreach ($vm in $vms) {	 $vmguest = $vm.name	 $vmguestIP = get-vmguest $vmguest	 $vmIP = $vmguestIP.IPaddress	 .\psexec \\$vmIP -u administrator -p $plocalPW netdom join  $vmguest /domain:corbis.com /userd:$userName /passwordd:$puserPW	 .\psexec \\$vmIP -u administrator -p $plocalPW shutdown -r -t 0	}
