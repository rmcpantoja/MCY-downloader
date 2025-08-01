; MCY Downloader globals

#include "Functions.au3"
#include "..\reader.au3"

#include-once

; Program:
Global $sProgramName = "MCY Downloader"
Global $sArchitecture = "x64"
Global $sProgram_ver = "1.0B1"
; Paths:
Global $sConfigFolder = @ScriptDir & "\config"
Global $sConfigPath = $sConfigFolder & "\config.st"
Global $sDest_folder
;configs:
Global $sEnableProgresses, $sEnhancedAccessibility, $sShowTips, $sSaveLogs, $sCheckForUpdate, $sYouTube_DL, $sLang = "en"
Global $sLatestRadioURL
; handlings:
Global $hFileLog = Null

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
