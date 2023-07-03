function Get-WebServiceProxy {
    param(
        [string] $WsdlUri,
        [string] $Username,
        [SecureString] $SecurePassword
    )
    $credential = New-Object System.Management.Automation.PSCredential -ArgumentList ($Username, $SecurePassword)

    return New-WebServiceProxy -Uri $WsdlUri -Credential $credential
}

$serviceProxy = Get-WebServiceProxy "https://ws.dev.nhn.no/v1/AR?wsdl" "nhnadmin" (ConvertTo-SecureString "blymRin4" -AsPlainText -Force)

#$namespace = $service.getType().namespace

#$request = New-Object ($namespace + ".GetOrganizationDetails")
#$request.herId = 19396
#Write-Output $namespace

#$service.GetOrganizationDetails(
#$service.GetOrganizationDetails(

$organization = $serviceProxy.GetOrganizationDetails(59, "true")
$currentDate = Get-Date

foreach($service in $organization.Services) {
    if(($service.Valid.From -gt $currentDate) -or ($service.Valid.To -lt $currentDate)) {
        continue
    }
    
    
    Write-Output "Valid"
}

#Write-Output $foo


# $username = "nhnadmin"
# $password = ConvertTo-SecureString "PASSORD" -AsPlainText -Force

# $credential = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

# $wsdlUri = "https://ws.dev.nhn.no/v1/AR?wsdl"

# $service = New-WebServiceProxy -Uri $wsdlUri -Credential $credential
# $service.Ping()