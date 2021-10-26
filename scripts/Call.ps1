function Invoke-Call {
    param (
        [Parameter(Mandatory)]
        $Cmd,

        [Parameter(ValueFromRemainingArguments)]
        $Args
    )

    Write-Host $Cmd @Args
    return & $Cmd @Args
}

function Check-Call {
    param (
        [Parameter(Mandatory)]
        $Cmd,

        [Parameter(ValueFromRemainingArguments)]
        $Args
    )

    Invoke-Call $Cmd @Args
    return ($LASTEXITCODE -eq 0)
}

function Verify-Call {
    param (
        [Parameter(Mandatory)]
        $Cmd,

        [Parameter(ValueFromRemainingArguments)]
        $Args
    )

    $Result = Invoke-Call $Cmd @Args
    if ($LASTEXITCODE -ne 0)
    {
        throw "'$Cmd $Args' failed with exit code $LASTEXITCODE"
    }

    return $Result
}
