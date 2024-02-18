Import-Module powershell-yaml 
$content =  Get-Content -Path "Test.yml" -Raw
$yaml = ConvertFrom-Yaml $content

$SecurePassword = ConvertTo-SecureString -String $yaml.secret -AsPlainText -Force
$TenantId = $yaml.tentID
$ApplicationId = $yaml.appID
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApplicationId, $SecurePassword
Connect-AzAccount -ServicePrincipal -TenantId $TenantId -Credential $Credential -Subscription $yaml.subID


[array]$subnets = @{name = $yaml.subnets[0].name; mask = $yaml.subnets[0].mask}
[array]$subnets += @{name = $yaml.subnets[1].name; mask = $yaml.subnets[1].mask}

New-AzResourceGroupDeployment -Name "HashTest" -ResourceGroupName $yaml.rg -TemplateFile "./azureDeploy.json" -testObj $subnets -subnetcount $subnets.Count