#Set VM Guest IP addresses
Function Set-WinVMIP ($VM, $HC, $GC, $IP, $SNM, $GW){
 $netsh = "c:\windows\system32\netsh.exe interface ip set address ""Local Area Connection 3"" static $IP $SNM $GW 1"
 Write-Host "Setting IP address for $VM..."
 Invoke-VMScript -VM $VM -HostCredential $HC -GuestCredential $GC -ScriptType bat -ScriptText $netsh
 Write-Host "Setting IP address completed."
}
 
#Connect-VIServer MYvCenter
 

$VM = Get-VM ( Read-Host "Enter VM name")
$ESXHost = $VM | Get-VMHost
$HostCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter ESX host credentials for $ESXHost", "root", "")
$GuestCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter Guest credentials for $VM", "", "")
 
$IP = read-host "IP"
$SNM = "255.255.255.0"
$GW = read-host "Gateway"
 
Set-WinVMIP $VM $HostCred $GuestCred $IP $SNM $GW