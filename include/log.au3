#include <fileConstants.au3>
global $ifSabe = IniRead("config\config.st", "General settings", "Sabe Logs", "")
select
case $IfSabe ="yes"
Local $logfile = FileOpen("logs\" & @year & @mon & @MDAY & ".log",$FC_OVERWRITE  + $FC_CREATEPATH)
case $IfSabe ="no"
sleep(5)
case else
IniWrite("config\config.st", "General settings", "Sabe Logs", "Yes")
EndSelect
func writeinlog($text)
if $ifSabe ="yes" then
FileWrite($logfile,@Year & "-" & @mon & "-" & @Mday &" " & @hour & ":" &@min &": " &$text &@crlf)
EndIf
endfunc
Func ___DeBug($iError, $sAction)
	Switch $iError
		Case -1
FileWrite($logfile,@CRLF & "-" & $sAction & @CRLF)
		Case 0
FileWrite($logfile,@CRLF & "+" & $sAction & " - OK" & @CRLF)
		Case Else
FileWrite($logfile,@CRLF & "!" & $sAction & " - FAILED" & @CRLF)
			Exit
	EndSwitch
EndFunc   ;==>___DeBug