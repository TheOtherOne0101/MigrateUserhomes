# Module for Helperfuctions of MigrateUserhomes

Install-Module PSFramework -Force

if (-not (Get-Module -ListAvailable -Name PSFramework)) {
    throw "PSFramework ist not installed. Please install manually!"
}

$Functions = Get-ChildItem $PSScriptRoot -Recurse | Where-Object { (".ps1" -in ($_.extension)) }

foreach ($item in $Functions) {
    . $item.FullName
}