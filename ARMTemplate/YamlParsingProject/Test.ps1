Import-Module powershell-yaml 
$content =  Get-Content -Path "Test.yml" -Raw
$yaml = ConvertFrom-Yaml $content
<# Lines 1-3
Imported the "Powershell-YAML" module to pull the YAML File and
convert it to a PSObject 
#>
Connect-AzAccount

$subnets = @()
For ($i=0; $i -lt $yaml.networks.subnets.Count; $i++) {
    [array]$subnets += @{name = $yaml.networks.subnets[$i].name; mask = $yaml.networks.subnets[$i].mask}
}

<#Line 18-21
Here is a workaround for passing a YAML object in "New-AzResourceGroupDeployment" command. 
When passing a regular PSObject in the command, I recieved an error because ARM wanted
a "System.Collection.Hashtable" instead of a "System.Object"

To pass mutiple hashtables in the ARM Template. I created ForLoop to append the subnet array 
to create mutiple hashtables to pass that parameter as an array instead of an object. 

In the ARM Template, I had to the change the "testObj" parameter to accept arrays instead
of objects.
#>

New-AzResourceGroupDeployment -Name "HashTest" -ResourceGroupName $yaml.rg -TemplateFile "./azureDeploy.json" -testObj $subnets