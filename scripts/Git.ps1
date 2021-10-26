function Git-Clone {
    param (
        [Parameter()]
        [string]
        $Repository,

        [Parameter()]
        [string]
        $Branch,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Path = $PWD,

        [Parameter()]
        [switch]
        $RemoveIfInvalid,

        [Parameter()]
        [switch]
        $ForceSet
    )

    Get-Item -Path $Path -ErrorAction Stop

    . $PSScriptRoot/Call.ps1

    $ClonePath = [System.IO.Path]::Join($Path, $Name)

    # If the path exists, let's verify it has a git repository
    if(Test-Path $ClonePath)
    {
        Push-Location -Path $ClonePath
        $GitSucceeded = Check-Call git status
        Pop-Location

        # If it is not a valid git repository, just remove the folder
        if(!$GitSucceeded)
        {
            if($RemoveIfInvalid)
            {
                Remove-Item -Path $ClonePath -Recurse
            }
            else
            {
                throw "'$ClonePath' already exists. Use -RemoveIfInvalid to try removing the item and continue."
            }
        }
    }

    # Check the path again
    if(!(Test-Path $ClonePath))
    {
        # Clone the repo
        Verify-Call git clone $Repo $ClonePath
    }

    try
    {
        Push-Location $ClonePath

        # Verify we have a good git repo connected to 
        $Origin = Verify-Call git remote get-url origin
        if($Origin -ne $Repo -And $ForceSet)
        {
            # Set the url
            Verify-Call git remote set-url origin $Repo
        }

        # Fetch the commits
        Verify-Call git fetch -f -t

        # Switch branches
        Verify-Call git checkout $Branch

        # Make sure we are at the tip of the branch
        Verify-Call git reset --hard origin/$Branch
    }
    finally
    {
        Pop-Location
    }
}
