<#
Author: Tim Zelle
Purpose: Find snapshots.
selection of all vms on selected cluster to check the snapshot
includes function to select cluster.
includes function to choose type of snapshot to find.
to do: function for The VCenter you are connecting too.
to do: delete snapshots from menu.

#>
$quit = "q"
function show-menu
{
    Param (
        [string]$title = 'options' 
    )
    clear-host
    Write-Host "~~~~~~$title~~~~~~"
    write-host "1: Option 1: Find snapshots NOT made by VEEAM"
    Write-Host "2: Option 2: Find all snapshots  made by VEEAM backup" 
    Write-Host "Q: Option to quit"
}
asnp vmware*
$vcserver = Read-Host "Enter the hostname or IP for the vCenter Server"#set the vcenter server name or IP.
Connect-VIServer $vcserver
    Clear       

    # Getting Cluster info   

    $Cluster = Get-Cluster #sourcing array for selection. 
    $countCL = 0  
    Clear
    #clear console and write pretty lines with text and selection table.   
    Write-Output " "
    Write-Output "Clusters: "
    Write-Output " "
        foreach($oC in $Cluster){  #create selectable array

            Write-Output "[$countCL] $oc"
            $countCL = $countCL+1  
            }  

    $choice = Read-Host "On which cluster do you check snapshots?" #make sure source list has the VM's split from the clusters. 
    $cluster = get-cluster $cluster[$choice] #created list from the get-cluster command in variable array. 
    Write-Output "$cluster `n............................................................"
    do
{
show-menu -title 'options'
$selection = Read-Host "press the number for selected option"
    switch ($selection)
{
    '1'{get-cluster $cluster | get-vm | get-snapshot| 
where name -ne "VEEAM BACKUP TEMPORARY SNAPSHOT"| 
select vm, created, Description, name, ParentSnapshot, Children  | 
ft -AutoSize}
    '2'{get-cluster $cluster | get-vm | get-snapshot| 
where name -EQ "VEEAM BACKUP TEMPORARY SNAPSHOT"| 
select vm, created, Description, name, ParentSnapshot, Children  | 
ft -AutoSize}
    'q'{"'$quit' You choose to quit" }
   
    }pause{ 
}
}
until ($selection -eq 'q')
