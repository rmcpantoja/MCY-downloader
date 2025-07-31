; MCY Downloader globals

#include "Functions.au3"
#include "..\reader.au3"

#include-once

; Program:
Global $sProgramName = "MCY Downloader"
Global $sArchitecture = "x64"
Global $sProgram_ver = "1.0B1"
; Paths:
global $sConfigFolder = @ScriptDir &"\config"
global $sConfigPath = $sConfigFolder &"\config.st"
global $sDest_folder
;configs:
global $sEnableProgresses, $sEnhancedAccessibility, $sShowTips, $sSaveLogs, $sCheckForUpdate, $sYouTube_DL, $sLang = "en"
global $sLatestRadioURL
; handlings:
global $hFileLog = null

;register:
;New command line options! Incredible as it may seem, it is.
If _StringInArray($cmdline, '/radio') Then
	radio()
	exitpersonaliced()
ElseIf _StringInArray($cmdline, '/help') Then
	MsgBox(0, "command line instructions", "/radio: open MCY Radio" & @CRLF & "/help: query this help.")
	exitpersonaliced()
EndIf


; funcs:

; #FUNCTION# ====================================================================================================================
; Name ..........: exitpersonaliced
; Description ...: Custom exit function
; Syntax ........: exitpersonaliced()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func exitpersonaliced()
	_nvdaControllerClient_free()
	_CustomLog("exiting...")
	Global $soundclose = $device.opensound("sounds/close.ogg", 0)
	$soundclose.play
	Sleep(500)
	FileDelete(@TempDir & "\MCYWeb.dat")
	FileDelete(@ScriptDir & "\tmp_motd_es.ogg")
	FileClose($hFileLog)
	Exit
EndFunc   ;==>exitpersonaliced
