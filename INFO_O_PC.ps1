﻿$hostname = hostname
$serialNumber = wmic bios get serialnumber
$model = (Get-WmiObject -Class Win32_ComputerSystem).Model
$username = $env:USERNAME

Write-Host "Zbieranie informacji na temat komputera"

$output = "Hostname: $hostname`r`n"
$output += "Nazwa domeny: $domainName`r`n"
$output += "Model: $model`r`n"
$output += "Numer seryjny: $serialNumber`r`n"
$output += "Nazwa zalogowanego użytkownika: $username`r`n"
Set-Content -Path "C:\Users\$username\Desktop\Informacje_o_komputerze_$hostname.txt" -Value $output
Write-Host "lokalizacja pliku: C:\Users\$username\Desktop\Informacje_o_komputerze_$hostname.txt"
Pause