param (
    [Parameter()]
    [string]
    $Repository = 'https://github.com/microsoft/vcpkg.git',

    [Parameter()]
    [string]
    $Branch = 'master'
)

. $PSScriptRoot/scripts/Call.ps1
. $PSScriptRoot/scripts/Git.ps1

Git-Clone -Repository $Repository -Branch $Branch -Name 'vcpkg' -Path $PSScriptRoot -RemoveIfInvalid -ForceSet

# Set the environment variable for binary caching location
$ArchivesPath = [System.IO.Path]::Join($PSScriptRoot, 'vcpkg', 'archives')
$env:VCPKG_DEFAULT_BINARY_CACHE = $ArchivesPath

# Make sure the archives folder is available
if(!(Test-Path -Path $ArchivesPath))
{
    New-Item -Path $ArchivesPath -Type Directory -ErrorAction Stop
}

# Bootstrap vcpkg to ensure it is correct
if ($IsWindows)
{
    Verify-Call $PSScriptRoot/vcpkg/bootstrap-vcpkg.bat
}
else
{
    Verify-Call $PSScriptRoot/vcpkg/bootstrap-vcpkg.sh
}
