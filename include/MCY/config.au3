; MCY Downloader config
#include "checkupdate.au3"
#include "file.au3"
#include "globals.au3"
#include "language_manager.au3"
#include "motd.au3"
#include "..\translator.au3"
#include "..\updater.au3"
#include-once

Func _config_start($sConfigFolder, $sConfigPath)
	If Not FileExists($sConfigFolder) Then
		$hPath = DirCreate($sConfigFolder)
		if $hPath = 0 then
			MsgBox(16, Translate($lng, "Error"), Translate($lng, "Config folder could not be created. If so, please run the program as administrator."))
			exitpersonaliced()
		EndIf
	EndIf
	$sLang = IniRead($sConfigPath, "General settings", "language", "")
	If $sLang = "" Then Selector()
	$sEnhancedAccessibility = IniRead($sConfigPath, "Accessibility", "Enable enhanced accessibility", "")
	If Not $sEnhancedAccessibility = "Yes" Or Not $sEnhancedAccessibility = "No" Then
		$sEnhancedAccessibility = _Configure_Accessibility($sConfigPath)
	EndIf
	$sSaveLogs = IniRead(@ScriptDir & "\config\config.st", "General settings", "Save Logs", "")
	if $sSaveLogs = "" then
		IniWrite(@ScriptDir & "\config\config.st", "General settings", "Save Logs", "yes")
		$sSaveLogs = "yes"
	EndIf
	if $sSaveLogs = "yes" then $hFileLog  = FileOpen(@ScriptDir & "\logs\" & @YEAR & @MON & @MDAY & ".log", 1)
	$sProgramType = IniRead($sConfigPath, "General settings", "Program Type", "")
	if $sProgramType = "" then
		If @ScriptDir = "C:\MCY" Then
			IniWrite($sConfigPath, "General settings", "Program Type", "Installable")
			_CustomLog("Copy: Installable.")
		else
			IniWrite($sConfigPath, "General settings", "Program Type", "Portable")
			_CustomLog("Copy: Portable.")
		EndIf
	EndIf
	If @OSArch = "x64" And $sArchitecture = "x86" Then
		MsgBox(48, Translate($lng, "Warning"), Translate($lng, "You run a 64-bit pc with the 32-bit version of the program. For better performance in the program, we recommend that you download the 64-bit version at http://mateocedillo.260mb.net/programs.html"))
		exitpersonaliced()
	elseIf @OSArch = "x86" And $sArchitecture = "x64" Then
		MsgBox(48, Translate($lng, "Warning"), Translate($lng, "You run a 32-bit pc with the 64-bit version of the program. For better performance in the program, we recommend that you download the 32-bit version at http://mateocedillo.260mb.net/programs.html"))
		exitpersonaliced()
	EndIf
	; Yt-DLP (global:
	If @OSArch = "x64" Then
		$sYouTube_DL = IniRead($sConfigPath, 'General Settings', 'Youtube-DL', 'engines64\yt-dlp.exe')
	ElseIf @OSArch = "x86" Then
		$sYouTube_DL = IniRead($sConfigPath, 'General Settings', 'Youtube-DL', 'engines\yt-dlp_x86.exe')
	EndIf
	$sDest_folder = IniRead($sConfigPath, "General settings", "Destination folder", "")
	if $sDest_folder = "" then
		$sDest_folder = "C:\MCY\Download"
		IniWrite($sConfigPath, "General settings", "Destination folder", $sDest_folder)
		_create_folders($sDest_folder)
	EndIf
	$sWantUpdates = IniRead($sConfigPath, "General settings", "Check updates", "")
	if $sWantUpdates = "" and @compiled then
		IniWrite($sConfigPath, "General settings", "Check updates", "Yes")
		$sWantUpdates = "yes"
	EndIf
	$sLocalMOTD = IniRead($sConfigPath, "misc", "motdversion", "")
	$sLatestMotd = IniRead(@TempDir & "\MCYWeb.dat", "motd", "Latest", "")
	$sLatestMotdMode = IniRead(@TempDir & "\MCYWeb.dat", "motd", "Mode", "")
	_CustomLog("Website motd: " & $sLatestMotd & "actual motd: " & $sLocalMOTD)
	if $sLatestMotd > $sLocalMOTD then
		$downloading = $device.opensound("sounds/update_downloading.ogg", 0)
		$downloading.play
		download_motd($sLatestMotd, $sEnhancedAccessibility, $sLatestMotdMode)
	EndIf
	; Finally:
	if $sWantUpdates = "yes" then
		If @Compiled Then checKmcyversion()
	else
		_CustomLog("the user does not want updates")
	EndIf
EndFunc

Func _radio_config_start($sConfigFolder, $sConfigPath)
	If Not FileExists($sConfigFolder) Then
		$hPath = DirCreate($sConfigFolder)
		if $hPath = 0 then
			MsgBox(16, Translate($lng, "Error"), Translate($lng, "Config folder could not be created. If so, please run the program as administrator."))
			exitpersonaliced()
		EndIf
	EndIf
	$sLatestRadioURL = IniRead($sConfigPath, "radio", "Last radio loaded", "")
	if $sLatestRadioURL = "" then
		$sLatestRadioURL = "0"
		IniWrite($sConfigPath, "radio", "Last radio loaded", $sLatestRadioURL)
	EndIf
EndFunc

func _create_folders($d_folder)
	If Not FileExists($d_folder & "\audio") Then DirCreate($d_folder & "\audio")
	If Not FileExists($d_folder & "\video") Then DirCreate($d_folder & "\video")
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _ConfigureAccessibility
; Description ...: Function that questions to the user if he want enhanced accessibility.
; Syntax ........: _ConfigureAccessibility($sConfigPath)
; Parameters ....: $sConfigPath         - The full path to the ini or ST.
; Return values .: The answered question.
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Configure_Accessibility($sConfigPath)
	Local $iAccessMSG = MsgBox(4, Translate($sLang, "Enable enhanced accessibility?"), Translate($sLang, "This functionality is designed for the visually impaired, in which most of the program interface can be used by voice and keyboard shortcuts. Would you like to enable it?"))
	Local $sEnhancedAccessibility
	If $iAccessMSG = 6 Then
		IniWrite($sConfigPath, "accessibility", "Enable enhanced accessibility", "Yes")
		$sEnhancedAccessibility = "Yes"
	Else
		IniWrite($sConfigPath, "accessibility", "Enable enhanced accessibility", "No")
		$sEnhancedAccessibility = "No"
	EndIf
	Return $sEnhancedAccessibility
EndFunc   ;==>_Configure_Accessibility

func _CustomLog($sText)
local $iRet
if $sSaveLogs = "yes" then
if not $hFileLog = "" then
$iRet = _FileWriteLog($hFileLog, $sText)
if @error then Return SetError(1, 0, "")
else
Return SetError(2, 0, "")
EndIf
EndIf
return $iRet
EndFunc