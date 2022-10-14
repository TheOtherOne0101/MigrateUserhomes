## Logging
$paramSetPSFLoggingProvider = @{
    Name         = 'logfile'
    FilePath     = "C:\temp\Logs\ModifyDataMigration-%Date%.log"
    Enabled      = $true
}
Set-PSFLoggingProvider @paramSetPSFLoggingProvider