# Check Office 365 Groups that are soft-deleted and can still be recovered within the 30 day period. 
$CheckDate = (Get-Date).AddDays(-7)
$Today = (Get-Date)
$Grp = (Get-AzureADMSDeletedGroup -All:$True | Sort DeletedDateTime | Select Id, DisplayName, DeletedDateTime, Description)
ForEach ($G in $Grp) {
        If ($G.DeletedDateTime -le $CheckDate) {
           $TimeToGo = ($G.DeletedDateTime).AddDays(30) - $Today 
           $Line = $G.DisplayName + " is due for permanent removal on " + (Get-Date ($G.DeletedDateTime).AddDays(30) -Format g) + " You have " + $TimeToGo.Days + " days and about " + $TimeToGo.Hours + " hours to recover the group."
           Write-Host $Line -Foregroundcolor Red 
     }
    }
