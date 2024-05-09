#Skrypt powershell kopiuje WSZYSTKIE DOSTEPY, od jednego do drugiego uzytkownika, niezaleznie od ich lokalizacji na ActiveDirectory, 
#czyli wszystkie grupy które są dostępne zostaną skopiowane,
#Wersja 1.0
#Opracowal Dominik Olechny
#09.05.2024

$sourceUser = Read-Host "Podaj login usera od ktorego chcesz kopiowac grupy" #user od ktorego kopiujemy
$targetUser = Read-Host "Podaj login usera do ktorego chcesz przekleic groupy" #user docelowy
try {
    # Pobierz grupy, do których należy użytkownik źródłowy 
    $sourceUserAD = Get-ADUser $sourceUser -ErrorAction Stop -Properties MemberOf

    Write-Host "Czy na pewno chcesz skopiowac grupy usera $sourceUser i nadac ja userowi $targetUser"
    Read-Host "Jesli sie zgadzasz nacisnij enter...."

    if ($sourceUserAD) {
        $sourceGroups = $sourceUserAD.MemberOf

        # Dodaj użytkownika docelowego do wszystkich grup, do których należy użytkownik źródłowy
        foreach ($group in $sourceGroups) {
            Add-ADGroupMember -Identity $group -Members $targetUser -ErrorAction Stop
        
        }
        
        Write-Host "Pomyślnie dodano użytkownika $targetUser do wszystkich grup użytkownika $sourceUser."
        Read-Host "Nacisnij enter aby kontynuowac...."
    } else {
        Write-Host "Użytkownik $sourceUser nie istnieje."
        Read-Host "Nacisnij enter aby kontynuowac...."
        
    }
} catch {
    Write-Host "Wystąpił błąd: $_"
    Read-Host "Nacisnij enter aby kontynuowac...."
}
