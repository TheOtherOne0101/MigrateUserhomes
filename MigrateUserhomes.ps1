param (
    [Parameter(Mandatory)]
    [array]
    $ExcludedUsers,

    [Parameter(Mandatory)]
    [String] # TODO - ValidateOU
    $OU,

    [Parameter(Mandatory)]
    [String] # TODO -ValidatePath
    $NewLocation
)

Import-Module ".\Functions\MigrateUserhomes.psm1" -Force

if (!Test-IsElevated) {
    throw $_
}

$Users = get-aduser -filter 'enabled -eq $true' -Properties HomeDirectory -SearchBase $OU | Select-Object samaccountname, HomeDirectory

if ($null -eq $Users) {
    throw "Couldn't retrieve any Users from given OU"
}
else {
    foreach($user in $Users){
        if((!($null -eq $user.HomeDirectory)) -or (!($ExcludedUsers -contains $user.samaccountname))){
            
            try {
                $user = Set-NewHomeDirectory -User $user -Path $NewLocation
            }
            catch {
                Write-PSFMessage -Level Error -Message $_
                continue
            }
            
            try {
                Edit-HomeDirectoryACL -User $user
            }
            catch {
                Write-PSFMessage -Level Error -Message $_
            }
        }
    }
}