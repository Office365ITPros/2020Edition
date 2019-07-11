# Define GUIDs for the Privileged Roles (from Get-AzureADDirectoryRole)
$UserAccountAdmin = "0f3a91cd-4fdd-436e-97ed-f2a01b19bfe2"
$TenantAdmin = "36333bfe-4ff2-452a-a4a0-d11a668b44c7"
$TeamsAdmin = "4c962061-2581-417f-938a-7cc1b38fc2a2"
$ExchangeAdmin = "53add08e-5b0c-4276-a582-9ce02fb6c947"
$SharePointAdmin = "f35c2f36-b60d-4b17-b261-0de8af7da552"

# Find out the set of accounts that hold these admin roles in the tenant
$UserAccountAdmins = Get-AzureADDirectoryRoleMember -ObjectId $UserAccountAdmin | Select ObjectId, UserPrincipalName
$TenantAdmins = Get-AzureADDirectoryRoleMember -ObjectId $TenantAdmin | Select ObjectId, UserPrincipalName
$TeamsAdmins = Get-AzureADDirectoryRoleMember -ObjectId $TeamsAdmin | Select ObjectId, UserPrincipalName
$ExchangeAdmins = Get-AzureADDirectoryRoleMember -ObjectId $ExchangeAdmin | Select ObjectId, UserPrincipalName
$SharePointAdmins = Get-AzureADDirectoryRoleMember -ObjectId $SharePointAdmin | Select ObjectId, UserPrincipalName

$Report = @()
$i = 0
$Accounts = (Get-MsolUser -All | ? {$_.UserType -eq "Member" -and $_.Islicensed -eq $True} | Select ObjectId, DisplayName, UserPrincipalName, StrongAuthenticationMethods | Sort DisplayName)
ForEach ($Acc in $Accounts) {
   If ($Acc.StrongAuthenticationMethods -ne $Null) { Write-Host $Acc.DisplayName "has MFA enabled"
   $MFAStatus = "Enabled"}
   Else {
      $Roles = $Null
      Write-Host $Acc.DisplayName "does not have MFA enabled"
      $MFAStatus = "Not Enabled"
      If ($UserAccountAdmins.ObjectId -Contains $Acc.ObjectId) {
         Write-Host "Account holds the User Account Admin role" -ForegroundColor Red 
         $Roles = "User Account" }
      If ($TenantAccountAdmins.ObjectId -Contains $Acc.ObjectId) {
         Write-Host "Account holds the Tenant Admin role" -ForegroundColor Red 
         If ($Roles -eq $Null) { $Roles = "Tenant Admin" } Else { $Roles = $Roles + "; Tenant Admin" } }
      If ($TeamsAdmins.ObjectId -Contains $Acc.ObjectId) {
         Write-Host "Account holds the Teams Admin role" -ForegroundColor Red 
         If ($Roles -eq $Null) { $Roles = "Teams Admin" } Else { $Roles = $Roles + "; Teams Admin" } }
     If ($ExchangeAdmins.ObjectId -Contains $Acc.ObjectId) {
         Write-Host "Account holds the Exchange Admin role" -ForegroundColor Red
         If ($Roles -eq $Null) { $Roles = "Exchange Admin" } Else { $Roles = $Roles + "; Exchange Admin" } }
     If ($SharePointAdmins.ObjectId -Contains $Acc.ObjectId) {
         Write-Host "Account holds the SharePoint Admin role" -ForegroundColor Red 
         If ($Roles -eq $Null) { $Roles = "SharePoint Admin" } Else { $Roles = $Roles + "; SharePoint Admin" } }
     If ($Roles -ne $Null) {Write-Host "User" $Acc.DisplayName "has" $Roles -ForeGroundColor Yellow
     $i++ }
    $ReportLine = [PSCustomObject][Ordered]@{
       User      = $Acc.DisplayName
       UPN       = $Acc.UserPrincipalName
       Roles     = $Roles
       MFA       = $MFAStatus }   
   $Report += $ReportLine      }
} 
