
<#
.LINK
https://bitsofknowledge.net/2018/03/24/powershell-must-have-tools-for-development/

.LINK
https://github.com/nightroman/Invoke-Build

.LINK
http://duffney.io/GettingStartedWithInvokeBuild#powershell-module-development-workflow
#>

#-----------------------------------------------------------------------------------------------------------------------
#=======================================================================================================================
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Clear-Host # CLS
#Start-Sleep -Milliseconds 100 #Bugfix: Clear-Host acts so quickly, sometimes it won't actually wipe the terminal properly. If you force it to wait, then after PowerShell will display any specially-formatted text properly.

#=======================================================================================================================

# Install dependencies

#task . InstallDependencies, Analyze, Test, UpdateVersion, Clean, Archive
task . InstallDependencies, Test, IntegrateFunctions

task InstallDependencies {
    Install-Module PSScriptAnalyzer -Force
    Install-Module Pester -Force
}

#-----------------------------------------------------------------------------------------------------------------------

task Analyze {
    $scriptAnalyzerParams = @{
        Path = "$BuildRoot\DSCClassResources\TeamCityAgent\"
        Severity = @('Error', 'Warning')
        Recurse = $true
        Verbose = $false
        ExcludeRule = 'PSUseDeclaredVarsMoreThanAssignments'
    }

    $saResults = Invoke-ScriptAnalyzer @scriptAnalyzerParams

    if ($saResults) {
        $saResults | Format-Table
        throw "One or more PSScriptAnalyzer errors/warnings where found."
    }
}

#-----------------------------------------------------------------------------------------------------------------------

# Test our cmdlets/libraries

task Test {
    $invokePesterParams = @{
        Strict = $true
        PassThru = $true
        Verbose = $false
        EnableExit = $false
    }

    # Publish Test Results as NUnitXml
    $testResults = Invoke-Pester @invokePesterParams;

    $numberFails = $testResults.FailedCount
    assert($numberFails -eq 0) ('Failed "{0}" unit tests.' -f $numberFails)
}

#-----------------------------------------------------------------------------------------------------------------------

# Build the .psm1 module by combining all the different function/library scripts saved individually into one script and renaming it to .psm1

task IntegrateFunctions {

    $ModuleContent = Get-Content "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\Convert-AMPMhourTo24hour.ps1"

    $ModuleContent += Get-Content "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\Convert-TimeZones.ps1"

    $ModuleContent += Get-Content "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\PromptForChoice-DayDate.ps1"

    $ModuleContent += Get-Content "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\ReadPrompt-AMPM24.ps1"
    
    $ModuleContent += Get-Content "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\Read-PromptTimeValues.ps1"

    Set-Content -Path "TimeFunctions.psm1" -Value $ModuleContent

}

#-----------------------------------------------------------------------------------------------------------------------


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#=======================================================================================================================
#-----------------------------------------------------------------------------------------------------------------------
