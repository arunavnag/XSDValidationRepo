#!/usr/bin/env pwsh

<#
.SYNOPSIS

Build the documentation from repos (provided you have a valid personal access token in .pat)

.PARAMETER serve

Serve the result via http - this is needed so API docs can be displayed (depends on redoc js).
Common errors include:
a) not having installed the node httpserver (fix by `npm i -g http-server`)
b) not having access to

.PARAMETER fetch

Use this parameter when building from remote repositories to bypass local cache.

.PARAMETER help

Get more help
#>

param (
    [String][parameter(Mandatory = $false, ValueFromPipeline)]$siteFile="site.yml",
    [switch][parameter()]$serve,
    [switch][parameter()]$fetch,
    [switch][parameter()][alias('h')]$help
)
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
if ($help) {Get-Help $PSCommandPath -detailed; exit(1)}

Write-Host "Building ${siteFile} $PSCommandPath"

$extraParameters=@()
if ($fetch) { $extraParameters += "--fetch" }

$personalAccessToken = Get-Content -Path $scriptPath\.pat
Set-Item -Path Env:GIT_CREDENTIALS -Value "https://${personalAccessToken}:@dev.azure.com"

Try {
    antora generate ${siteFile} --stacktrace $extraParameters
    Set-Item -Path Env:GIT_CREDENTIALS -Value ""
    Copy-Item -force -Recurse -Path src\docs\html\* -Destination build\site\
    if  ($serve) {
        Write-Host "opening server (to test js + apidoc)"
        Start-Process "http://localhost:8080"
        http-server -c-1 ${scriptPath}/build/site
    } else {
        Write-Host "opening file (not working for Javascript)"
        Start-Process "file:///${scriptPath}/build/site/index.html"
    }
}
Finally {
    # regardless of errors unset credentials
    Set-Item -Path Env:GIT_CREDENTIALS -Value ""
}


