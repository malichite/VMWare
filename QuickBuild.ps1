#vmbuild
$vmname="server1","server2","server3","server4"
$vmHosts = get-cluster vmCluster | get-vmhost
$custom=get-OSCustomizationSpec customizationSpec
$template=get-template templateName
$datastore=get-vmhost someHost | get-datastore
foreach ($vm in $vmname){
    $vmhost=get-random -input $vmhosts
    new-vm -name $vm -OScustomizationspec $custom -template $template -vmhost $vmhost -datastore $datastore -RunAsync -DiskStorageFormat Thin
    }