; #FUNCTION# ====================================================================================================================
; Name ..........: PlayDirectAudioURL
; Description ...: reproductor URL
; Syntax ........: PlayDirectAudioURL($url)
; Parameters ....: $url                 - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func PlayDirectAudioURL($url)
	HotKeySet("{i}", "info")
	$player_window = GUICreate("MCY Downloader: Playing " & $url)
	Global $BASS_PAUSE_POS
	Global $Volume = "100"
	StartAudio()
EndFunc   ;==>PlayDirectAudioURL
; #FUNCTION# ====================================================================================================================
; Name ..........: StartAudio
; Description ...: Starts the audio playback and controls
; Syntax ........: StartAudio()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func StartAudio()
	$ReadAccs = IniRead("config\config.st", "Accessibility", "Enable enanced accessibility", "")
	Local $MusicHandle
	Local $infox
	_Audio_init_start()
	$MusicHandle = _Set_url($Enlace)
	_Audio_play($MusicHandle)
	Local $idMenu = GUICtrlCreateButton(translate($lng, "Open menu"), 90, 50, 70, 25)
	Local $idBtn_Close = GUICtrlCreateButton(translate($lng, "Close"), 140, 50, 70, 25)
	GUISetState(@SW_SHOW)
	Global $infox = _Get_streamtitle($MusicHandle)
	; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $idBtn_Close
				GUIDelete()
				_Audio_stop($MusicHandle)
				_Audio_init_stop($MusicHandle)
			Case $idMenu
				$menutab = Reader_Create_Menu(TRANSLATE($lng, "Use the arrows to navigate the multimedia controls:"), TRANSLATE($lng, "change volume") & "|" & TRANSLATE($lng, "Play") & "|" & translate($lng, "Pause") & "|" & translate($lng, "Stop") & "|" & translate($lng, "File info") & "|" & translate($lng, "close this menu"))
				Select
					Case $menutab = 1
						$volumeSlider = Reader_create_menu(translate($lng, "change volume") & ": slider 100", "actual (100)|0|10|20|30|40|50|60|70|80|90")
						Select
							Case $volumeSlider = "1"
								Speaking(translate($lng, "cancelled"))
							Case $volumeSlider = "2"
								_Set_volume(0)
								$Volume = "0"
								speaking(translate($lng, "Sample volume set to") &" " &"0%.")
							Case $volumeSlider = "3"
								_Set_volume(10)
								$Volume = "10"
								speaking(translate($lng, "Sample volume set to") &" " &"10%.")
							Case $volumeSlider = "4"
								_Set_volume(20)
								$Volume = "20"
								speaking(translate($lng, "Sample volume set to") &" " &"20%.")
							Case $volumeSlider = "5"
								_Set_volume(30)
								$Volume = "30"
								speaking(translate($lng, "Sample volume set to") &" " &"30%.")
							Case $volumeSlider = "6"
								_Set_volume(40)
								$Volume = "40"
								speaking(translate($lng, "Sample volume set to") &" " &"40%.")
							Case $volumeSlider = "7"
								_Set_volume(50)
								$Volume = "50"
								speaking(translate($lng, "Sample volume set to") &" " &"50%.")
							Case $volumeSlider = "8"
								_Set_volume(60)
								$Volume = "60"
								speaking(translate($lng, "Sample volume set to") &" " &"60%.")
							Case $volumeSlider = "9"
								_Set_volume(70)
								$Volume = "70"
								speaking(translate($lng, "Sample volume set to") &" " &"70%.")
							Case $volumeSlider = "10"
								_Set_volume(80)
								$Volume = "80"
								speaking(translate($lng, "Sample volume set to") &" " &"80%.")
							Case $volumeSlider = "11"
								_Set_volume(90)
								$Volume = "90"
								speaking(translate($lng, "Sample volume set to") &" " &"90%.")
						EndSelect
					Case $menutab = 2
						_Audio_play($MusicHandle)
					Case $menutab = 3
						_Audio_pause($MusicHandle)
					Case $menutab = 4
						_Audio_stop($MusicHandle)
					Case $menutab = 5
						_Set_volume(25)
						speaking(translate($lng, "the real name of your audio is:") & $infox)
						If $infox = "0" Then
							speaking(translate($lng, "There is no information"))
						EndIf
						_Set_volume($Volume)
				EndSelect
		EndSwitch
	WEnd
	_Audio_init_stop($MusicHandle)
EndFunc   ;==>StartAudio
; #FUNCTION# ====================================================================================================================
; Name ..........: info
; Description ...: Info of the real name of a song
; Syntax ........: info()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func info()
	;local $info2 = _Get_streamtitle($MusicHandle)
	$MusicHandle = _Set_url($ENlace)
	_Set_volume(25)
	Sleep(300)
	speaking(translate($lng, "stream/song name:") & _Get_streamtitle($MusicHandle))
	If $infox = "0" Then
		speaking(translate($lng, "no song is playing"))
	EndIf
	_Set_volume($Volume)
EndFunc   ;==>info
