$path = @($out_path)

Function Inspect-Description{
    $Users = @()

    #Define objects and patterns to match
    $SSN = "(\d{3}-\d{2}-\d{4})"
    $phone = "(\d{3}-\d{3}-\d{4})"
    $unc = '.*(\\{2}[^\\"]+\\[^\\"]+\\{^"]+).*'
    $ip = '(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
    $strings = @("creds","pass","password","username","credential","VNC","remote","un","pw",$SSN,$phone,$unc,$ip)

    foreach ($string in $strings){
        $Users += Get-ADUser -Filter * -Property Description | Where-Object {$_.Description -match $string}
    }

    $uniqueUsers = $Users | Select-Object -Unique
    
    if ($uniqueUsers.count -ne 0){
        $uniqueUsers | Export-Csv "$path\UserswithSensitiveInformationinDescription.csv" -NoTypeInformation
        Return $uniqueUsers.count
    }

    Return $null
}

Return Inspect-Description