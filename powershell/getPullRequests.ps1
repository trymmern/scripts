# PAT from Trym Todalshaug 2022-10-31
$AzureDevOpsPAT = "m5lxsivumuzml343qifu7vcxrdyxyddonizu3osu4olftadyp2ka"
$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($AzureDevOpsPAT)")) }

$url = "https://dev.azure.com/NorskHelsenettUtvikling/Grunndata/_apis/git/repositories/palantir/pullrequests/?searchCriteria.status=completed&searchCriteria.targetRefName=refs/heads/release/L1337-Q500&api-version=7.0"

$pullRequestsJson = (Invoke-RestMethod -Uri $url -Method Get -Headers $AzureDevOpsAuthenicationHeader).value | ConvertTo-Json
Write-Host $pullRequestsJson