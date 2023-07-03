# PAT from Trym Todalshaug 2022-10-31
$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($env:PAT)")) }

# Target branch in the pull request is now the source branch since the PR is completed
$sourceBranch = $env:Build_SourceBranch.Replace("refs/heads/", "")
$repoId = $env:Build_Repository_Name
$baseUri = "https://dev.azure.com/$($env:organization)"

Write-Host "Source branch: $($sourceBranch), RepoId: $($repoId)"

# Do not run if the target branch of the PR is not a release branch
if (($sourceBranch -notlike "release/*") -and ($sourceBranch -notlike "develop")) {
    Write-Host "Target branch '$($sourceBranch)' is not a release branch or develop branch. Exiting"
    Exit
}

# If commit happens on release branch
if ($sourceBranch -like "release/*") 
{
    # Get tag name (release name) from target branch
    $tag = $sourceBranch.Substring($sourceBranch.IndexOf("/")+1)
} 
# If commit happens on develop (before release branch is created)
else
{
    $pathToBuildNumberFile = $env:BuildNumberFilePath

    if (-not (Test-Path $pathToBuildNumberFile))
    {
        Write-Warning "Build number file not found on path $pathToBuildNumberFile";
        return
    }

    $content = (Get-Content $pathToBuildNumberFile -ErrorAction Stop)
    $parts = $null
    $parts = $content.Split('.')[0 .. 2];

    if ($parts.Count -ne 3) {
        Write-Error "Expected $pathToBuildNumberFile to contain three digits separated by a dot. Actual contents: $content";
    } else {

        # Create tag from version number
        if ($parts[2] -eq "0") {
            $q = "$($parts[1])"
        } else {
            $q = "$($parts[1]).$($parts[2])"
        }
        $tag = "L$($parts[0].Substring(2))-$($q)"
    }
}

# Get ID of latest pull request
$url = "$($baseUri)/$($env:System_TeamProject)/_apis/git/repositories/$($repoId)/pullrequests/?searchCriteria.status=completed&searchCriteria.targetRefName=refs/heads/$($sourceBranch)&api-version=7.0"
Write-Host $url
$pullRequests = (Invoke-RestMethod -Uri $url -Method Get -Headers $AzureDevOpsAuthenicationHeader).value | ConvertTo-Json | ConvertFrom-Json

$prId = $pullRequests[0].pullRequestId
Write-Host "PullRequest ID: $($prId)"
Write-Host "Tag: $($tag)"

# Get all work items linked to the pull request
$prUri = "$($baseUri)/$($env:System_TeamProject)/_apis/git/repositories/$($repoId)/pullRequests/$($prId)/workitems?api-version=7.0"
$workItemsJson = (Invoke-RestMethod -Uri $prUri -Method Get -Headers $AzureDevOpsAuthenicationHeader).value | ConvertTo-Json
$workItems = $workItemsJson | ConvertFrom-Json

if ($workItems.Length -eq 0) {
    Write-Host "No work items linked to pull request. Exiting"
    Exit
} else {
    Write-Host "Work Items linked to pull request: $($workItemsJson)"
}

# Construct body for adding tag to work item
$body = @(
    @{
        op = "add"
        path = "/fields/System.Tags"
        value = "$($tag)"
    }
)

# Add tag to all work items fetched in previous step
foreach ($workItem in $workItems) {
    Write-Host "Adding tag '$($tag)' to work item with id [$($workItem.id)]"
    
    # Omit project name (Grunndata/Virksomhet) from url to enable tagging in both virksomhet and personell task boards
    $workItemUri = "$($baseUri)/_apis/wit/workitems/$($workItem.id)?api-version=7.0"
    
    Invoke-RestMethod -Uri $workItemUri -Method Patch -Headers $AzureDevOpsAuthenicationHeader -Body (ConvertTo-Json -InputObject $body) -ContentType "application/json-patch+json"
}