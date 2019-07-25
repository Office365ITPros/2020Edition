# These times are in UTC
$HolidayStart = "04-Aug-2019 17:00"
$HolidayEnd = "6-Aug-2019 09:00"

$InternalMessage = "Expect delays in answering messages to this mailbox due to the holiday between <b>" + $HolidayStart + "</b> and <b>" + $HolidayEnd + "</b>"
$ExternalMessage = "Thank you for your email. Your communication is important to us, but please be aware that some delay will occur in answering messages to this mailbox due to the public holiday between <b>" + $HolidayStart + "</b> and <b>" + $HolidayEnd + "</b>"

$Mbx = (Get-Mailbox -RecipientTypeDetails SharedMailbox | Select DisplayName, Alias, DistinguishedName)
   ForEach ($M in $Mbx) {
   # Set auto reply
   Write-Host "Setting auto-reply for shared mailbox:" $M.DisplayName
   Set-MailboxAutoReplyConfiguration -Identity $M.DistinguishedName -StartTime $HolidayStart -AutoReplyState "Scheduled" -EndTime $HolidayEnd -InternalMessage $InternalMessage –ExternalMessage  $ExternalMessage -ExternalAudience 'All' -CreateOOFEvent:$True }
