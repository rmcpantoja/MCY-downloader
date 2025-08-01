#include-once

; #FUNCTION# ====================================================================================================================
; Name ..........: motdprincipal
; Description ...: Download MOTD
; Syntax ........: motdprincipal()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func download_motd($sMotd, $sAccess, $sMode)
	$sound = $device.opensound("sounds/selected.ogg", 0)
	$background = $device.opensound("sounds/update.ogg", 0)
	$downloadingmotd = GUICreate(translate($lng, "Downloading message of the day..."))
	GUICtrlCreateLabel(translate($lng, "Please wait."), 85, 20)
	GUISetState(@SW_SHOW)
	$background.play
	$background.repeating = 1
	$ok = IniWrite($sConfigPath, "misc", "motdversion", $sMotd)
	_CustomLog("Downloading MOTD.")
	Select
		Case $sMode = "audio"
			$audio = InetGet("https://drive.google.com/uc?id=1epPH-945GiUFfnHuUcevYk_txhCFFSwt&export=download", "tmp_motd_es.ogg", 1, 0)
			;While @InetGetActive
			Sleep(100)
			;Wend
			InetClose($audio)
			$motd = $device.opensound("tmp_motd_es.ogg", 0)
			GUICtrlCreateLabel(translate($lng, "Reproduciendo audio..."), 85, 20)
			If $background.playing = "1" Then
				$background.stop
			EndIf
			$motd.play
			While $motd.playing = 1
				Sleep(10)
			WEnd
		Case $sMode = "text"
			If $background.playing = "1" Then $background.stop
			$M_text = IniRead(@TempDir & "\MCYWeb.dat", "motd", "Text_" & $sLang, "")
			$sound.play
			If $sAccess = "Yes" Then
				CreateTTSDialog("MOTD", $M_text)
			Else
				MsgBox(0, translate($lng, "Message of the day"), $M_text)
			EndIf
	EndSelect
	GUIDelete($downloadingmotd)
EndFunc   ;==>download_motd
