param (
    [Parameter()]
    [string]
    $VcpkgPath = $PWD
)

. $PSScriptRoot/scripts/Call.ps1
. $PSScriptRoot/scripts/Git.ps1

Git-Clone -Repository 'https://github.com/microsoft/vcpkg.git' -Branch 'master' -Name 'vcpkg' -Path $PSScriptRoot -RemoveIfInvalid -ForceSet

# Set the environment variable for binary caching location
$ArchivesPath = [System.IO.Path]::Join($PSScriptRoot, 'archives')
$env:VCPKG_DEFAULT_BINARY_CACHE = $ArchivesPath

# Make sure the archives folder is available
if(!(Test-Path -Path $ArchivesPath))
{
    New-Item -Name $ArchivesPath -Type Directory
}

# Bootstrap vcpkg to ensure it is correct
Verify-Call $PSScriptRoot\vcpkg\bootstrap-vcpkg.bat
