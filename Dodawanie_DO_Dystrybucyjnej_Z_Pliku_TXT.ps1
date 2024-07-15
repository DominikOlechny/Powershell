#początek skryptu
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName XXXX@xxx.xx -ShowProgress $true #tutaj daj poprawnego admina tenanta
# Wczytaj listę użytkowników
$users = Get-Content "sciezka_do_pliku.txt" #tutaj zmień

# Nazwa grupy dystrybucyjnej
$group = "XXXX@xxx.xx" #tutaj zmien grupe dystrybucyjna na swoja 

# Dodaj użytkowników do grupy dystrybucyjnej
foreach ($user in $users) {
    Add-DistributionGroupMember -Identity $group -Member $user
}
##koniec skryptu
