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
Func motdprincipal($sMotd, $sAccess, $sMode)
	$sound = $device.opensound("sounds/selected.ogg", 0)
	$bagground = $device.opensound("sounds/update.ogg", 0)
	$downloadingmotd = GUICreate(translate($lng, "Downloading message of the day..."))
	GUICtrlCreateLabel(translate($lng, "Please wait."), 85, 20)
	GUISetState(@SW_SHOW)
	$bagground.play
	$bagground.repeating = 1
	$ok = IniWrite($sConfigPath, "misc", "motdversion", $LatestMotd)
	writeinlog("Downloading MOTD.")
	Select
		Case $sMode = "audio"
			$audio = InetGet("https://drive.google.com/uc?id=1epPH-945GiUFfnHuUcevYk_txhCFFSwt&export=download", "tmp_motd_es.ogg", 1, 0)
			;While @InetGetActive
				Sleep(100)
			;Wend
			InetClose($audio)
			$motd = $device.opensound("tmp_motd_es.ogg", 0)
			GUICtrlCreateLabel(translate($lng, "Reproduciendo audio..."), 85, 20)
			If $bagground.playing = "1" Then
				$bagground.stop
			EndIf
			$motd.play
			While $motd.playing = 1
				Sleep(10)
			WEnd
		Case $M_mode = "text"
			If $bagground.playing = "1" Then $bagground.stop
			$M_text = IniRead(@TempDir & "\MCYWeb.dat", "motd", "Text_" & $sLang, "")
			$sound.play
			If $ReadAccs = "Yes" Then
				CreateTTSDialog("MOTD", $M_text)
			Else
				MsgBox(0, translate($lng, "Message of the day"), $M_text)
			EndIf
	EndSelect
	GUIDelete($downloadingmotd)
EndFunc   ;==>motdprincipal
