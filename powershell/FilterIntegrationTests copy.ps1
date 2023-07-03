$global:SkipImportersTests = $true
$global:SkipProxyServerTests = $true
$global:SkipArTests = $true
$global:SkipArProxyTests = $true
$global:SkipBusinessTests = $true
$global:SkipCodesTests = $true
$global:SkipCommonTests = $true
$global:SkipCppaTests = $true
$global:SkipFlrTests = $true
$global:SkipHprTests = $true
$global:SkipHtkTests = $true
$global:SkipKrkTests = $true
$global:SkipLsrTests = $true
$global:SkipOfrTests = $true
$global:SkipPtTests = $true
$global:SkipRabbitMqMigrationTests = $true
$global:SkipReshTests = $true
$global:SkipUserAdminTests = $true

# The dependencies of the different test projects
$global:ImportersDeps = @("NHN.Palantir.ImportersTest", "NHN.Palantir.Importers.AnatomiskLokalisasjonImporter", "NHN.Palantir.Importers.ArOrganizationCreator", "NHN.Palantir.Importers.CodeSelectionLists", "NHN.Palantir.Importers.CPPAImporter", "NHN.Palantir.Importers.ZipAndMunicipalityUpdater")
$global:ProxyServerDeps = @("NHN.Palantir.Proxy.Server.IntegrationTests", "NHN.Palantir.Proxy.Server", "NHN.Palantir.Proxy.Client", "NHN.Palantir.Proxy.ClientLauncher", "NHN.Palantir.RPRegistry.ArProxy", "NHN.Palantir.RPRegistry.Common")
$global:ArDeps = @("NHN.Palantir.RPRegistry.AddressRegistry.IntegrationTests", "NHN.Palantir.RPRegistry.AddressRegistry", "NHN.Palantir.MessageBus", "NHN.Palantir.RPRegistry.AddressRegister", "NHN.Palantir.RPRegistry.Codes", "NHN.Palantir.RPRegistry.BusManager", "NHN.Palantir.RPRegistry.BusManager.v2")
$global:ArProxyDeps = @("NHN.Palantir.RPRegistry.ArProxy.IntegrationTests", "NHN.Palantir.RPRegistry.ArProxy")
$global:BusinessDeps = @("NHN.Palantir.RPRegistry.Business.IntegrationTests", "NHN.Palantir.MessageBus", "NHN.Palantir.RPRegistry.Business", "NHN.Palantir.RPRegistry.Codes", "NHN.Palantir.WebServices.External.Brreg")
$global:CodesDeps = @("NHN.Palantir.RPRegistry.Codes.IntegrationTests", "NHN.Palantir.MessageBus", "NHN.Palantir.RPRegistry.Codes")
$global:CommonDeps = @("NHN.Palantir.RPRegistry.Common.IntegrationTests", "NHN.Palantir.RPRegistry.Common")
$global:CppaDeps = @("NHN.Palantir.RPRegistry.Cppa.IntegrationTests", "NHN.Palantir.MessageBus", "NHN.Palantir.RPRegistry.AddressRegister", "NHN.Palantir.RPRegistry.Codes", "NHN.Palantir.RPRegistry.Common", "NHN.Palantir.RPRegistry.Cppa")
$global:FlrDeps = @("NHN.Palantir.RPRegistry.Flr.IntegrationTests", "NHN.Common.ServiceModel", "NHN.Palantir.MessageBus", "NHN.Palantir.RPRegistry.Common", "NHN.Palantir.RPRegistry.Flr", "NHN.Palantir.RPRegistry.Orchestration")
$global:HprDeps = @("NHN.Palantir.RPRegistry.Hpr.IntegrationTests", "NHN.Palantir.MessageBus", "NHN.Palantir.RPRegistry.Codes", "NHN.Palantir.RPRegistry.Common", "NHN.Palantir.RPRegistry.Hpr")
$global:HtkDeps = @("NHN.Palantir.RPRegistry.HTK.IntegrationTests", "NHN.Palantir.MessageBus", "NHN.Palantir.RPRegistry.Common", "NHN.Palantir.RPRegistry.Flr", "NHN.Palantir.RPRegistry.HTK")
$global:KrkDeps = @("NHN.Palantir.RPRegistry.Krk.IntegrationTests", "NHN.Palantir.RPRegistry.Codes", "NHN.Palantir.RPRegistry.Common", "NHN.Palantir.RPRegistry.Krk")
$global:LsrDeps = @("NHN.Palantir.RPRegistry.Lsr.IntegrationTests", "NHN.Palantir.MessageBus", "NHN.Palantir.RPRegistry.Common", "NHN.Palantir.RPRegistry.Lsr.Common", "NHN.Palantir.RPRegistry.Lsr", "NHN.Palantir.RPRegistry.Resh", "NHN.Palantir.LsrDistributionFixer")
$global:OfrDeps = @("NHN.Palantir.RPRegistry.Ofr.IntegrationTests", "NHN.Palantir.RPRegistry.Common", "NHN.Palantir.RPRegistry.Ofr")
$global:PtDeps = @("NHN.Palantir.RPRegistry.PT.IntegrationTests", "NHN.Palantir.RPRegistry.Codes", "NHN.Palantir.RPRegistry.PT")
$global:RabbitMqMigrationDeps = @("NHN.Palantir.RPRegistry.RabbitMqMigration.IntegrationTests", "NHN.Palantir.RPRegistry.AddressRegister", "NHN.Palantir.RPRegistry.RabbitMqMigration")
$global:ReshDeps = @("NHN.Palantir.RPRegistry.Resh.IntegrationTests", "NHN.Palantir.MessageBus", "NHN.Palantir.RPRegistry.Business", "NHN.Palantir.RPRegistry.Common", "NHN.Palantir.RPRegistry.Resh")
$global:UserAdminDeps = @("NHN.Palantir.RPRegistry.UserAdmin.IntegrationTests", "NHN.Palantir.MessageBus", "NHN.Palantir.RPRegistry.Common", "NHN.Palantir.RPRegistry.UserAdmin")

function Main([bool]$CIRun)
{
    # Initiate script with all tests skipped
    ToggleAllTests -CIRun $CIRun -Skip $true

    # Diff since branch creation
    if ($CIRun)
    {
        $targetBranch = "develop" #$env:System_PullRequest_TargetBranch.Replace("refs/heads/", "")
    }
    else
    {
        $targetBranch = "develop"
    }
    $branch = $(git branch --show-current)
    Write-Output $branch $targetBranch
    $files = $(git diff origin/develop...$branch --name-only)
    $fileList = $files.Split(' ')
    $projects = $fileList | % { $_.Split('/')[1] } | Get-Unique
    
    Write-Output "Changed files ($($fileList.Length)):"
    foreach ($file in $fileList) 
    {
        Write-Output $file
    }

    # If contracts, commons, DB projects or ServiceHosts have changes, Exit this script and run all tests
    $contractsChanged = ContractsChanged -Projects $projects
    $commonsChanged = CommonsChanged -Projects $projects
    $efDatabaseChanged = EFDatabaseChanged -Projects $projects
    $shChanged = SHChanged -Projects $projects
    if ($contractsChanged -or $commonsChanged -or $efDatabaseChanged -or $shChanged) 
    {
        ToggleAllTests -Skip $false
        Write-Output "Important projects changed. Running all tests"
        Exit
    }

    
    foreach ($project in $projects)
    {
        Write-Output "Checking project [$($project)]..."
        FilterTestRunners -CIRun $CIRun -Project $project
    }

    PrintAll
}

function PrintAll()
{
    Write-Output $(SkipImportersTests)
    Write-Output $(SkipProxyServerTests)
    Write-Output $(SkipArTests)
    Write-Output $(SkipArProxyTests)
    Write-Output $(SkipBusinessTests)
    Write-Output $(SkipCodesTests)
    Write-Output $(SkipCommonTests)
    Write-Output $(SkipCppaTests)
    Write-Output $(SkipFlrTests)
    Write-Output $(SkipHprTests)
    Write-Output $(SkipHtkTests)
    Write-Output $(SkipKrkTests)
    Write-Output $(SkipLsrTests)
    Write-Output $(SkipOfrTests)
    Write-Output $(SkipPtTests)
    Write-Output $(SkipRabbitMqMigrationTests)
    Write-Output $(SkipReshTests)
    Write-Output $(SkipUserAdminTests)
}

function ContractsChanged([array]$Projects)
{
    $contractProjects = "NHN.DtoContracts", "NHN.Palantir.InternalContracts", "NHN.Palantir.WebServices.Contracts", "NHN.Palantir.WebServices.Security"
    foreach ($project in $Projects) 
    {
        if ($contractProjects -contains $project)
        {
            Write-Output "Contract project [$($project)] changed"
            return $true
        }
    }
    return $false
}

function CommonsChanged([array]$Projects)
{
    $commons = "NHN.Palantir.Commons", "NHN.Palantir.TestCommon", "NHN.Common.BaseLibrary", "NHN.Common.ServiceModel", "NHN.Palantir.Common.Web", "NHN.Palantir.MessageBus", "NHN.Palantir.MessageBus.Amqp", "NHN.Palantir.SharedLogic.csproj"
    foreach ($project in $Projects)
    {
        if ($commons -contains $project)
        {
            Write-Output "Project [$($project)] changed"
            return $true
        }
    }
    return $false
}

function EFDatabaseChanged([array]$Projects)
{
    $efProjects = "NHN.Palantir.Database.Schema", "NHN.Palantir.EFDatabase", "NHN.Palantir.EFDatabase.EntityDataModels", "NHN.Palantir.Log.Database.Schema", "NHN.Palantir.Log.EFDatabase"
    foreach ($project in $Projects)
    {
        if ($efProjects -contains $project)
        {
            Write-Output "Database project [$($project)] changed"
            return $true
        }
    }
    return $false
}

function SHChanged([array]$Projects)
{
    $sh =  "NHN.Palantir.ServicesHoster", "ServiceHost.DotNet6"
    foreach ($project in $Projects)
    {
        if ($sh -contains $project)
        {
            Write-Output "ServiceHost project [$($project)] changed"
            return $true
        }
    }
    return $false
}

function FilterTestRunners([bool]$CIRun, [string]$Project)
{
    if ($CIRun)
    {
        SetTestToggleCi -Project $Project -Deps $global:ImportersDeps -SkipTestToggle "SkipImportersTests"
        SetTestToggleCi -Project $Project -Deps $global:ProxyServerDeps -SkipTestToggle "SkipProxyServerTests"
        SetTestToggleCi -Project $Project -Deps $global:ArDeps -SkipTestToggle "SkipArTests"
        SetTestToggleCi -Project $Project -Deps $global:ArProxyDeps -SkipTestToggle "SkipArProxyTests"
        SetTestToggleCi -Project $Project -Deps $global:BusinessDeps -SkipTestToggle "SkipBusinessTests"
        SetTestToggleCi -Project $Project -Deps $global:CodesDeps -SkipTestToggle "SkipCodesTests"
        SetTestToggleCi -Project $Project -Deps $global:CommonDeps -SkipTestToggle "SkipCommonTests"
        SetTestToggleCi -Project $Project -Deps $global:CppaDeps -SkipTestToggle "SkipCppaTests"
        SetTestToggleCi -Project $Project -Deps $global:FlrDeps -SkipTestToggle "SkipFlrTests"
        SetTestToggleCi -Project $Project -Deps $global:HprDeps -SkipTestToggle "SkipHprTests"
        SetTestToggleCi -Project $Project -Deps $global:HtkDeps -SkipTestToggle "SkipHtkTests"
        SetTestToggleCi -Project $Project -Deps $global:KrkDeps -SkipTestToggle "SkipKrkTests"
        SetTestToggleCi -Project $Project -Deps $global:LsrDeps -SkipTestToggle "SkipLsrTests"
        SetTestToggleCi -Project $Project -Deps $global:OfrDeps -SkipTestToggle "SkipOfrTests"
        SetTestToggleCi -Project $Project -Deps $global:PtDeps -SkipTestToggle "SkipPtTests"
        SetTestToggleCi -Project $Project -Deps $global:RabbitMqMigrationDeps -SkipTestToggle "SkipRabbitMqMigrationTests"
        SetTestToggleCi -Project $Project -Deps $global:ReshDeps -SkipTestToggle "SkipReshTests"
        SetTestToggleCi -Project $Project -Deps $global:UserAdminDeps -SkipTestToggle "SkipUserAdminTests"
    }
    else
    {
        SetTestToggle -Project $Project -Deps $global:ImportersDeps -SkipTestToggle $global:SkipImportersTests
        SetTestToggle -Project $Project -Deps $global:ProxyServerDeps -SkipTestToggle $global:SkipProxyServerTests
        SetTestToggle -Project $Project -Deps $global:ArDeps -SkipTestToggle $global:SkipArTests
        SetTestToggle -Project $Project -Deps $global:ArProxyDeps -SkipTestToggle $global:SkipArProxyTests
        SetTestToggle -Project $Project -Deps $global:BusinessDeps -SkipTestToggle $global:SkipBusinessTests
        SetTestToggle -Project $Project -Deps $global:CodesDeps -SkipTestToggle $global:SkipCodesTests
        SetTestToggle -Project $Project -Deps $global:CommonDeps -SkipTestToggle $global:SkipCommonTests
        SetTestToggle -Project $Project -Deps $global:CppaDeps -SkipTestToggle $global:SkipCppaTests
        SetTestToggle -Project $Project -Deps $global:FlrDeps -SkipTestToggle $global:SkipFlrTests
        SetTestToggle -Project $Project -Deps $global:HprDeps -SkipTestToggle $global:SkipHprTests
        SetTestToggle -Project $Project -Deps $global:HtkDeps -SkipTestToggle $global:SkipHtkTests
        SetTestToggle -Project $Project -Deps $global:KrkDeps -SkipTestToggle $global:SkipKrkTests
        SetTestToggle -Project $Project -Deps $global:LsrDeps -SkipTestToggle $global:SkipLsrTests
        SetTestToggle -Project $Project -Deps $global:OfrDeps -SkipTestToggle $global:SkipOfrTests
        SetTestToggle -Project $Project -Deps $global:PtDeps -SkipTestToggle $global:SkipPtTests
        SetTestToggle -Project $Project -Deps $global:RabbitMqMigrationDeps -SkipTestToggle $global:SkipRabbitMqMigrationTests
        SetTestToggle -Project $Project -Deps $global:ReshDeps -SkipTestToggle $global:SkipReshTests
        SetTestToggle -Project $Project -Deps $global:UserAdminDeps -SkipTestToggle $global:SkipUserAdminTests
    }
}

function SetTestToggle([string]$Project, [array]$Deps, [bool]$SkipTestToggle)
{
    if ($Deps -contains $Project)
    {
        $SkipTestToggle = $false
        Write-Output "Because of changes in [$($Project)], [$($Deps[0])] will run"
    }
}

function SetTestToggleCi([string]$Project, [array]$Deps, [string]$SkipTestToggle)
{
    if ($Deps -contains $Project)
    {
        Write-Host "##vso[task.setvariable variable=$($SkipTestToggle);isOutput=true;]$false"
        Write-Output "Because of changes in [$($Project)], [$($Deps[0])] will run"
    }
}

function ToggleAllTests([bool]$CIRun, [bool]$Skip)
{
    if ($CIRun)
    {
        Write-Host "##vso[task.setvariable variable=SkipImportersTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipProxyServerTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipArTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipArProxyTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipBusinessTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipCodesTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipCommonTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipCppaTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipFlrTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipHprTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipHtkTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipKrkTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipLsrTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipOfrTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipPtTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipRabbitMqMigrationTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipReshTests;isOutput=true;]$Skip"
        Write-Host "##vso[task.setvariable variable=SkipUserAdminTests;isOutput=true;]$Skip"
    }
    else
    {
        $global:SkipImportersTests = $Skip
        $global:SkipProxyServerTests = $Skip
        $global:SkipArTests = $Skip
        $global:SkipArProxyTests = $Skip
        $global:SkipBusinessTests = $Skip
        $global:SkipCodesTests = $Skip
        $global:SkipCommonTests = $Skip
        $global:SkipCppaTests = $Skip
        $global:SkipFlrTests = $Skip
        $global:SkipHprTests = $Skip
        $global:SkipHtkTests = $Skip
        $global:SkipKrkTests = $Skip
        $global:SkipLsrTests = $Skip
        $global:SkipOfrTests = $Skip
        $global:SkipPtTests = $Skip
        $global:SkipRabbitMqMigrationTests = $Skip
        $global:SkipReshTests = $Skip
        $global:SkipUserAdminTests = $Skip
    }
}

# Invoke Main method to run script
Main -CIRun $true