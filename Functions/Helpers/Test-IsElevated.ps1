function Test-IsElevated {   
    
    $CurrentUserId = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $CurrentUser = New-Object System.Security.Principal.WindowsPrincipal($CurrentUserId)

    if ($CurrentUser.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        return $true
    }
    else {
        throw "Please run Script as Administrator"
    }
}