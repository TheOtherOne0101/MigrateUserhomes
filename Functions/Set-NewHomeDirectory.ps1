function Set-NewHomeDirectory {
    [CmdletBinding()]
    param (
        [CmdletBinding()]
        [Parameter(Mandatory)]
        [PSCustomObject]
        $User,

        [Parameter(Mandatory)]
        [ValidateDirectoryExists()]
        [System.IO.FileInfo]
        $Path
    )
    
    process {
        $NewPath = $Path + "\" + $user.samaccountname

        try {
            Copy-Item $User.HomeDirectory -Destination $NewPath
        }
        catch {
            Write-PSFMessage -Level Error -Message $_
        }

        if (-not (Test-Path $NewPath)) {
            throw [System.IO.FileNotFoundException] "New Home Directory doenst exist. Check if HomeDirectory was copied correctly"
        }
        else {
            $User.HomeDirectory = $NewPath
        }
        
        try {
            Set-ADUser -Identity $User.samaccountname -HomeDirectory $NewPath
        }
        catch {
            throw "Could not set HomeDirectory for " + $User.samaccountname
        }
    }
    
    end {
        return $User
    }
}