###Skrypt zbierający info o stanowisku V2####
#Wykonał Dominik Olechny dnia 07.06.2024

#Write-host "to nie skrypt nie uruchamiać"
#Pause 
#exit

####uruchomienie następuje od tego miejsca proszę o przekleić####

$computerSystem = Get-WmiObject -Class Win32_ComputerSystem
$bios = Get-CimInstance -ClassName Win32_BIOS
$processor = Get-WmiObject -Class Win32_Processor
$totalRAM = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
$totalRAMGB = [math]::round($totalRAM / 1GB, 2)
$os = Get-WmiObject -Class Win32_OperatingSystem
# Pobieranie informacji o dyskach twardych
$drives = Get-WmiObject -Class Win32_DiskDrive
$partitions = Get-WmiObject -Class Win32_DiskPartition
$logicalDisks = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
$usbDevices = Get-WmiObject -Query "Select * from Win32_USBHub"
$usbDevices = Get-CimInstance -ClassName Win32_USBHub
$netIPConfig = Get-NetIPConfiguration

$monitorInfo = Get-WmiObject WmiMonitorID -Namespace root\wmi | Select-Object @{
    Name = "Manufacturer";
    Expression = {[System.Text.Encoding]::ASCII.GetString($_.ManufacturerName).Trim([char]0)}
}, @{
    Name = "Model";
    Expression = {[System.Text.Encoding]::ASCII.GetString($_.UserFriendlyName).Trim([char]0)}
}, @{
    Name = "SerialNumber";
    Expression = {[System.Text.Encoding]::ASCII.GetString($_.SerialNumberID).Trim([char]0)}
}

$Manufacturer = $monitorInfo.Manufacturer
$Model = $monitorInfo.Model
$SerialNumbermonitor = $monitorInfo.SerialNumber

Write-Host "-------------------------------------------------"
Write-Host "Informacje o PC:"
Write-Host ""
Write-Host "Hostname:" $hostname
Write-Host "Producent:" $computerSystem.Manufacturer #Producent
Write-Host "Model:" $computerSystem.Model #Model
Write-Host "SN:" $bios.SerialNumber #Bios serialnumber
Write-Host ""
Write-Host "Procesor:" $processor.Name
Write-Host ""
Write-Host "RAM:"
Write-Host ""
Write-Host "ILOSC RAMU W SYSTEMIE: $totalRAMGB GB"
Write-Host ""
$memoryModules = Get-CimInstance -ClassName Win32_PhysicalMemory

foreach ($module in $memoryModules) {
    $capacityGB = [math]::round($module.Capacity / 1GB, 2)
    Write-Host "PORT: $($module.BankLabel)"
    Write-Host "ILOSC PAMIECI: $capacityGB GB"
    Write-Host "PREDKOSC: $($module.Speed) MHz"
    Write-Host "PRODUCENT: $($module.Manufacturer)"
    Write-Host "PART NUMBER: $($module.PartNumber)"
    Write-Host "SERIAL NUMBER: $($module.SerialNumber)"
    Write-Host ""
}

Write-Host "Dyski twarde:"
Write-Host ""

foreach ($drive in $drives) {
    Write-Host "Model: $($drive.Model)"
    Write-Host "Producent: $($drive.Manufacturer)"
    Write-Host "Interface: $($drive.InterfaceType)"
    Write-Host "Serial Number: $($drive.SerialNumber)"
    Write-Host "Size: $([math]::round($drive.Size / 1GB, 2)) GB"

    # Określenie typu dysku SSD/HDD
    if ($drive.MediaType -eq 'Fixed hard disk media' -or $drive.MediaType -eq 'Removable Media') {
        $type = "SSD"
    } else {
        $type = "HDD"
    }
    Write-Host "Type: $type"
    
    # Powiązane partycje i dyski logiczne
    $drivePartitions = $partitions | Where-Object { $_.DiskIndex -eq $drive.Index }
    foreach ($partition in $drivePartitions) {
        $logicalDisk = $logicalDisks | Where-Object { $_.DeviceID -eq $partition.DeviceID }
        if ($logicalDisk) {
            Write-Host "  Drive Letter: $($logicalDisk.DeviceID)"
            Write-Host "  Volume Name: $($logicalDisk.VolumeName)"
            Write-Host "  File System: $($logicalDisk.FileSystem)"
            Write-Host "  Size: $([math]::round($logicalDisk.Size / 1GB, 2)) GB"
            Write-Host "  Free Space: $([math]::round($logicalDisk.FreeSpace / 1GB, 2)) GB"
        }
    }
    Write-Host ""
}

Write-Host "OS:"
Write-Host ""
Write-Host "OS: $($os.Caption)"
Write-Host "WERSJA: $($os.Version)"
Write-Host "OS Build: $($os.BuildNumber)"
Write-Host "Architektura: $($os.OSArchitecture)"

Write-Host ""
Write-HOST "BIOS:"
Write-Host ""
Write-Host "BIOS Version: $($bios.SMBIOSBIOSVersion)"
Write-Host "BIOS Manufacturer: $($bios.Manufacturer)"
Write-Host "BIOS Name: $($bios.Name)"

Write-Host ""
Write-Host "Sieciowe:"
Write-Host ""

if ($computerSystem.PartOfDomain) {
    Write-Host "Komputer jest członkiem domeny: $($computerSystem.Domain)"
    Write-Host "Nazwa domeny: $($computerSystem.Domain)"
    Write-Host "Nazwa komputera: $($computerSystem.Name)"
    Write-Host "Rola komputera w domenie: $($computerSystem.DomainRole)"
} else {
    Write-Host "Komputer nie jest członkiem domeny"
}

foreach ($config in $netIPConfig) {
    Write-Host "-------------------------------------------------"
    Write-Host "Adapter: $($config.InterfaceAlias)"
    Write-Host "  Description: $($config.InterfaceDescription)"
    Write-Host "  IPv4 Address: $($config.IPv4Address.IPAddress)"
    Write-Host "  IPv6 Address: $($config.IPv6Address.IPAddress)"
    Write-Host "  Subnet Mask: $($config.IPv4Address.PrefixLength)"
    Write-Host "  Default Gateway: $($config.IPv4DefaultGateway.NextHop)"
    Write-Host "  DHCP Enabled: $($config.Dhcp)"
    Write-Host "  DNS Servers: $($config.DnsServer.ServerAddresses -join ', ')"
    Write-Host "  MAC Address: $($config.MacAddress)"
}

Write-Host "----------------------"
write-Host "Peryferia" 
Write-Host ""
Write-Host "Monitory:"

Write-output $monitorInfo


