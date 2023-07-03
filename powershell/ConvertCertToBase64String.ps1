param(
    [parameter(ParameterSetName = 'file')]
    [string]$FilePath
)

#$Cert = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate2($FilePath)
$CertBytes = Get-Content $FilePath -Encoding Byte

$content = @(
    '-----BEGIN CERTIFICATE-----'
    [System.Convert]::ToBase64String($CertBytes, 'InsertLineBreaks')
    '-----END CERTIFICATE-----'
)

#$BinCert = $Cert.GetRawCertData()
Write-Output [System.Convert]::ToBase64String($content)