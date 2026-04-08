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

$Servers11 = Get-IntersightComputeRackUnit -DeviceMoId "698d5fcb6f726131016e23d4" -Dn "sys/rack-unit-1"
$ValidInstallTarget = New-IntersightOsValidInstallTarget -Servers @($Servers11)
$OsSupport = New-IntersightOsOsSupport -OsVersion "ESXi 8.0"
$Account1 = Get-IntersightIamAccount -Name "my-account"
$Organization1 = Get-IntersightOrganizationOrganization -Name "Org-Auto-8332" -Account $Account1
$Catalog1 = Get-IntersightSoftwarerepositoryCatalog -Name "user-catalog" -Organization $Organization1
$Image31 = Get-IntersightSoftwarerepositoryOperatingSystemFile -Name "Esxi80u2_embedded" -Catalog $Catalog1
$OsduImage31 = Get-IntersightFirmwareServerConfigurationUtilityDistributable -Name "ucsxe-scu-7.1.7.260010.iso" -Catalog $Catalog1
$IpV4Config31 = Initialize-IntersightCommIpV4Interface -ObjectType "CommIpV4Interface" -Gateway "" -IpAddress "" -Netmask ""
$IpConfiguration31 = Initialize-IntersightOsIpv4Configuration -ObjectType "OsIpv4Configuration" -IpV4Config $IpV4Config31
$Answers31 = Initialize-IntersightOsAnswers -ObjectType "OsAnswers" -Hostname "google" -IpConfigType "DHCP" -IpConfiguration $IpConfiguration31 -IsRootPasswordCrypted $false -Nameserver "" -NetworkDevice "" -ProductKey "" -Source "Template" -RootPassword "123456"
$Organization4 = Get-IntersightOrganizationOrganization -Moid "5da9f0b76972652d30b3bae7"
if ($Organization4) {
    $Catalog3 = Get-IntersightOsCatalog -Name "shared" -Organization $Organization4
} else {
    $Catalog3 = Get-IntersightOsCatalog -Name "shared"
}
$ConfigurationFile31 = Get-IntersightOsConfigurationFile -Name "ESXi8.0ConfigFile" -Catalog $Catalog3
$InstallTarget31 = Initialize-IntersightOsPhysicalDisk -ObjectType "OsPhysicalDisk" -Name "Disk 1" -SerialNumber "W0K40V960000K141L1Z5" -StorageControllerSlotId "MRAID"
$Body31 = Initialize-IntersightOsInstall -Description "" -InstallMethod "VMedia" -Image $Image31 -OsduImage $OsduImage31 -OverrideSecureBoot $true -Organization $Organization1 -Answers $Answers31 -ConfigurationFile $ConfigurationFile31 -InstallTarget $InstallTarget31 -Server $Servers11
$Requests13 = Initialize-IntersightBulkRestSubRequest -ObjectType "BulkRestSubRequest" -Body $Body31
$BulkInstallRequest = New-IntersightBulkRequest -Verb "POST" -Uri "/v1/os/Installs" -Requests @($Requests13)