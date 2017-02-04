#Define variables as needed for your environment:
$K2FarmNameFQDN='K2.conundrum.com'	
$SiteName = "K2"

#Create self-signed certificate
New-SelfSignedCertificate -DnsName $K2FarmNameFQDN -CertStoreLocation cert:Localmachine\My

#Create web site
$SiteFolder = Join-Path -Path 'C:\inetpub\wwwroot' -ChildPath $SiteName
New-WebSite -Name $SiteName -PhysicalPath $SiteFolder -Force
$IISSite = "IIS:\Sites\$SiteName"
Set-ItemProperty $IISSite -name  Bindings -value @{protocol="https";bindingInformation="*:443:$K2Farm"}
#Assign certificate to site bindinf
Get-ChildItem cert:\LocalMachine\My | where { $_.Subject -match $K2FarmNameFQDN } | select -First 1 | New-Item IIS:\SslBindings\0.0.0.0!443