function TestApiDocsHtmlTagsForText([Microsoft.PowerShell.Commands.WebRequestSession]$session, [string]$tagName)
{
   $uri = "https://register-web.test.nhn.no/docs/api/NHN.Palantir.WebServices.Contracts.AR.Service.ICommunicationPartyService.html"

   Write-Host "Testing url: $uri"
   $content = ""
   $countWithOutText = 0
   $countWithText = 0
   $success=$false

    try
    {
        $response = Invoke-WebRequest -Uri $uri -Method Get -WebSession $session
        $success = $true
        $listOfText = $response.AllElements | Where{$_.TagName -eq $tagName} | Select-Object -Expand InnerText

        foreach($tag in $listOfText)
        {

           if ([string]::IsNullOrEmpty($tag) -or $tag.length -lt 2)
           {
               $countWithOutText++
               Write-Warning "The text in a <$tagName> tag may be empty in $uri : $tag"
           }
           else
           {
                $countWithText++
           }
        }
        Write-Host "The text in $countWithText <$tagName> tags looks good in $uri "
    }
    catch [System.Net.WebException]
    {
       $content = $_.ErrorDetails
       $response = $_.Exception.Response
       Write-Warning "An error occurred when testing text in $uri with content: $content and response: $response"
     }
    if ($countWithOutText -eq 0 -and $success -eq $true)
    {
        Write-Host -Foreground Green "The text in every <$tagName> tags looks good in $uri "
    }
}

TestApiDocsHtmlTagsForText $tagName 'p'