
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

task InstallDependencies

task InstallDependencies {
    Install-Module Pester -Force
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


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#=======================================================================================================================
#-----------------------------------------------------------------------------------------------------------------------
