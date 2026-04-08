# Uncomment the following script and provide the below information to set up Intersight environment.
<#
    $intersightEnv = @{
    BasePath = if ($env:INTERSIGHT_ENDPOINT) { $env:INTERSIGHT_ENDPOINT } else { "https://intersight.com" }
    ApiKeyId = "xxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxx"
    ApiKeyFilePath = "C:\\Users\\admin\\Downloads\\ProductionSecretKey.txt" 
    HttpSigningHeader =  @("(request-target)", "Host", "Date", "Digest")
}

Set-IntersightConfiguration @intersightEnv
#>

$Source1 = Initialize-IntersightSoftwarerepositoryNfsServer -FileLocation "10.xx.xx.xx/shared/ucsc-845a-m8-huu-2.0.1.250000D.iso" -ObjectType "SoftwarerepositoryNfsServer"
$Account1 = Get-IntersightIamAccount -Name "my-account"
$Organization1 = Get-IntersightOrganizationOrganization -Name "test_new_org" -Account $Account1
$Catalog1 = Get-IntersightSoftwarerepositoryCatalog -Name "user-catalog" -Organization $Organization1
$FirmwareDistributable = New-IntersightFirmwareDistributable -Name "ucsc-845a-m8-huu-2.0.1.250000D" -ImportAction "None" -SupportedModels @("CAI-845A-M8") -Version "-" -Origin "User" -Source $Source1 -Catalog $Catalog1
$Organization2 = Get-IntersightOrganizationOrganization -Name "test_new_org" -Account $Account1
$Catalog2 = Get-IntersightSoftwarerepositoryCatalog -Name "user-catalog" -Organization $Organization2
$UpdatedFirmwareDistributable = $FirmwareDistributable | Set-IntersightFirmwareDistributable -Source $Source1 -Version "2.0(1.250000D)" -Catalog $Catalog2 -Name "ucsc-845a-m8-huu-2.0.1.250000D" -SupportedModels @("CAI-845A-M8") -Description "invalid CIFS image"
$DirectDownload3 = Initialize-IntersightFirmwareDirectDownload -ObjectType "FirmwareDirectDownload"
$NetworkShare3 = Initialize-IntersightFirmwareNetworkShare -Upgradeoption "NwUpgradeFull" -MapType "Nfs" -ObjectType "FirmwareNetworkShare"
$Server3 = Get-IntersightComputeRackUnit -DeviceMoId "69a54b3a6f72613101af857f" -Dn "/redfish/v1/Systems/system"
$FirmwareUpgrade = New-IntersightFirmwareUpgrade -UpgradeType "NetworkUpgrade" -Distributable $UpdatedFirmwareDistributable -DirectDownload $DirectDownload3 -NetworkShare $NetworkShare3 -Server $Server3 -ExcludeComponentList @()