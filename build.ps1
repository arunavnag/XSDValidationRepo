#!/usr/bin/env pwsh

<#
.SYNOPSIS
Build the documentation from repos (provided you have a valid personal access token in .pat)
#>

param (
    [String][parameter(Mandatory = $false, Position = 0, ParameterSetName = 'siteFile')]$siteFile="site.yml"
)
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

Write-Host "Building ${siteFile}"

$personalAccessToken = Get-Content -Path $scriptPath\.pat

Set-Item -Path Env:GIT_CREDENTIALS -Value https://${personalAccessToken}:@dev.azure.com
Try {
    antora ${siteFile} --stacktrace
    Copy-Item -force -Path src\docs\html\* -Destination build\site\
    Start-Process "file:///${scriptPath}/build/site/index.html"
}
Finally {
    # remember to unset credentials
    Set-Item -Path Env:GIT_CREDENTIALS -Value ""
}



