#Skrypt kopiuje dostepy z uzytkownika A na uzytkownika B, ale grupy musza byc w odpowiednim OU, wymienionym w skrypcie, inne grupy w innych folderach nie beda pobierane.
#Wersja zautomatyzowana.
#Wersja 1.0
#Opracowal Dominik Olechny
#10.05.2024

$sourceUser = Read-Host "Podaj login usera od ktorego chcesz kopiowac grupy" #user od ktorego kopiujemy
$targetUser = Read-Host "Podaj login usera do ktorego chcesz przekleic grupy" #user docelowy
$ouname = Read-Host "Podaj nazwe OU z ktorego maja byc pobrane grupy" #tylko te grupy z tego ou zostana przekopiowane
$currentDomain = ([System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()).Name #Linijka odpowiedzialna za sciagniecie domeny serwera
$sourceOU = "OU=$ouname,DC=$($currentDomain.Replace('.', ',DC='))" #linika opowiedzialna za wyszukanie odpowiedniego OU.
try {
    # Pobierz grupy, do których należy użytkownik źródłowy 
    $sourceUserAD = Get-ADUser $sourceUser -ErrorAction Stop -Properties MemberOf
    Write-Host "Czy na pewno chcesz skopiowac grupy usera $sourceUser i nadac je userowi $targetUser"
    Read-Host "Jesli sie zgadzasz nacisnij enter...."

    if ($sourceUserAD) {
        $sourceGroups = $sourceUserAD.MemberOf

        # Dodaj użytkownika docelowego do wszystkich grup, do których należy użytkownik źródłowy
        foreach ($group in $sourceGroups) {
        if ($group -like "*,$sourceOU")
        {
            Add-ADGroupMember -Identity $group -Members $targetUser -ErrorAction Stop
        }

        }
        
        Write-Host "Pomyślnie dodano użytkownika $targetUser do wybranych grup użytkownika $sourceUser."
        Read-Host "Nacisnij enter aby kontynuowac...."
    } else {
        Write-Host "Użytkownik $sourceUser nie istnieje."
        Read-Host "Nacisnij enter aby kontynuowac...."
        
    }
} catch {
    Write-Host "Wystąpił błąd: $_"
    Read-Host "Nacisnij enter aby kontynuowac...."
}