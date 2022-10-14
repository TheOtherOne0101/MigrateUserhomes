function Edit-HomeDirectoryACL {
    [CmdletBinding()]
    param (
        [CmdletBinding()]
        [Parameter(Mandatory)]
        [PSCustomObject]
        $User
    )

    begin{
        # Inheritance- and PropagationFlags - TODO - Datentyp nötig? geht auch mit strings
        $INHERITANCEFLAG_SUBFOLDER_FILES = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
        $PROPAGATIONFLAG_SELF = [System.Security.AccessControl.PropagationFlags]::None

        # Set Owner - TODO - Maybe make optional param for owner
        $Owner = New-Object System.Security.Principal.Ntaccount("Administrator")

        if (Test-Path $User.HomeDirectory) {
            $Folder = Get-Item -Path $User.HomeDirectory
        }
        else {
            throw "Homedirectory doesn't exist"
        }
    }
    
    process {
        try {
            $ACL = Get-ACL -Path $Folder.FullName
        }
        catch {
            throw "Could not retrieve ACL of HomeDirectory: " + $Folder.FullName
        }

        $ACL.SetOwner($Owner)
        
        $AccessRules = @{
            System          = @("SYSTEM", "FullControl", $INHERITANCEFLAG_SUBFOLDER_FILES, $PROPAGATIONFLAG_SELF , "Allow")
            Administrator   = @("Administrator", "FullControl", $INHERITANCEFLAG_SUBFOLDER_FILES, $PROPAGATIONFLAG_SELF , "Allow")
            Administratoren = @("Administratoren", "FullControl", $INHERITANCEFLAG_SUBFOLDER_FILES, $PROPAGATIONFLAG_SELF , "Allow")
            User            = @($User.samaccountname, "FullControl", $INHERITANCEFLAG_SUBFOLDER_FILES, $PROPAGATIONFLAG_SELF , "Allow")
        }

        foreach ($permissions in $AccessRules.Values) {

            $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permissions

            $ACL.SetAccessRule($AccessRule)
        }

        try {
            $ACL | Set-Acl -Path $Folder.FullName
        }
        catch {
            throw "Couldn't set new ACL on Folder. Error Message:" + $_
        }
    }
}