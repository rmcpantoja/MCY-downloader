#include-once
#include <AutoItConstants.au3>
#include "..\Bass.au3"
#include "..\BassConstants.au3"
#include "globals.au3"
#include <GUIConstantsEx.au3>
#include <InetConstants.au3>
#include <SliderConstants.au3>
#include <WindowsConstants.au3>
Global const $sRadio_ver = "0.5.3"
; #FUNCTION# ====================================================================================================================
; Name ..........: Mcyradio
; Description ...: MCY radio!
; Syntax ........: Mcyradio()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func MCYRadio()
	$hWindow_radio = GUICreate("MCY Radio " & $sRadio_ver)
	Global $BASS_PAUSE_POS
	$iVolLevel = 100
	local $aRadios[][] = [["SONVA radio", "https://stream.zeno.fm/qhpfuuaq11zuv"], ["Blaster Radio", "https://blasterradio.net/blaster"], ["ALD prod radio", "http://stream.zeno.fm/1d6tptefguhvv"]]
	Dim $aHelpButtons[7]
	Global $hMusicHandle
	Global $sInfo1
	_Audio_init_start()
	$label = GUICtrlCreateLabel(translate($sLang, "Welcome!"), 0, 50, 100, 20)
	Local $idpause = GUICtrlCreateButton(TRANSLATE($sLang,"Pause"), 90, 50, 70, 25)
	Local $idStop = GUICtrlCreateButton(TRANSLATE($sLang,"Stop"), 90, 115, 70, 25)
	Local $idvolumelabel = GUICtrlCreateLabel(translate($sLang, "Change volume"), 50, 140, 70, 25)
	Local $idvolume = GUICtrlCreateSlider(90, 140, 70, 25, BitOR($GUI_SS_DEFAULT_SLIDER, $WS_TABSTOP))
	GUICtrlSetLimit(-1, 100, 0)
	GUICtrlSetData(-1, 50)
	Local $idselector = GUICtrlCreateButton(translate($sLang, "Radio selector"), 90, 175, 70, 25)
	Local $idInfo = GUICtrlCreateButton(translate($sLang, "stream/song info"), 90, 210, 70, 25)
	Local $idShowhelp = GUICtrlCreateButton(translate($sLang, "Help") & ", " & translate($sLang, "collapsed"), 90, 250, 70, 25)
	$aHelpButtons[0] = GUICtrlCreateButton(translate($sLang, "Visit YouTube channel"), 150, 50, 70, 25)
	$aHelpButtons[1] = GUICtrlCreateButton(translate($sLang, "&User manual"), 150, 120, 70, 25)
	$aHelpButtons[2] = GUICtrlCreateButton(translate($sLang, "Changes"), 150, 175, 70, 25)
	$aHelpButtons[3] = GUICtrlCreateButton(translate($sLang, "Get version for android"), 150, 230, 70, 25)
	$aHelpButtons[4] = GUICtrlCreateButton(translate($sLang, "About..."), 150, 260, 70, 25)
	$aHelpButtons[5] = GUICtrlCreateButton(translate($sLang, "install only MCY Radio"), 150, 300, 70, 25)
	$aHelpButtons[6] = GUICtrlCreateButton(translate($sLang, "Privacy policy"), 150, 375, 70, 25)
	For $I = 0 To UBound($aHelpButtons, $UBOUND_ROWS) - 1
		GUICtrlSetState($aHelpButtons[$I], $GUI_HIDE)
	Next
	Local $idBtn_Close = GUICtrlCreateButton(translate($sLang, "close"), 200, 200, 100, 25)
	GUISetState(@SW_SHOW)
	Local $bRadioStopPressed = False, $bRadioPausePressed = False, $bShowHelpPressed = False, $bInstPressed = False
	$hMusicHandle = _Set_url($aRadios[$sLatestRadioURL][1])
	sleep(1000)
	If @error Then
		MsgBox(0, translate($sLang, "Error"), translate($sLang, "The URL cannot be loaded. Reason:") & " " & @extended)
		GUIDelete($hWindow_radio)
		_Audio_stop($hMusicHandle)
		_Audio_init_stop($hMusicHandle)
	Else
		_Audio_play($hMusicHandle)
		While 1
			Switch GUIGetMsg()
				Case $GUI_EVENT_CLOSE, $idBtn_Close
					GUIDelete($hWindow_radio)
					_Audio_stop($hMusicHandle)
					_Audio_init_stop($hMusicHandle)
					ExitLoop
				Case $idInfo
					$sStreamInfo = _Get_streamtitle($hMusicHandle)
					If $sEnhancedAccessibility = "yes" Then
						If $sStreamInfo = "0" Then
							speaking(translate($sLang, "no song is playing"))
							ContinueLoop
						EndIf
						speaking(translate($sLang, "stream/song name:") & " " & $sStreamInfo)
					Else
						MsgBox(0, translate($sLang, "stream/song name:"), $sStreamInfo)
					EndIf
				Case $idpause
					$bRadioPausePressed = Not $bRadioPausePressed
					If $bRadioPausePressed Then
						_Audio_pause($hMusicHandle)
						GUICtrlSetData($idpause, TRANSLATE($sLang,"Play"))
					Else
						_Audio_play($hMusicHandle)
						GUICtrlSetData($idpause, TRANSLATE($sLang,"Pause"))
					EndIf
				Case $idStop
					$bRadioStopPressed = Not $bRadioStopPressed
					If $bRadioStopPressed Then
						_Audio_stop($hMusicHandle)
						GUICtrlSetData($idStop, TRANSLATE($sLang,"Play"))
					Else
						_Audio_play($hMusicHandle)
						GUICtrlSetData($idStop, TRANSLATE($sLang,"Stop"))
					EndIf
				Case $idvolume
					$iRadiovol = GUICtrlRead($idvolume)
					_Set_volume($iRadiovol)
					If $sEnhancedAccessibility = "yes" Then speaking(translate($sLang, "music volume set to") & " " & $iRadiovol & "%")
				Case $idselector
					RadioSelector($hWindow_radio, $aRadios)
				Case $idShowhelp
					$bShowHelpPressed = Not $bShowHelpPressed
					If $bShowHelpPressed Then
						For $I = 0 To UBound($aHelpButtons, $UBOUND_ROWS) - 1
							GUICtrlSetState($aHelpButtons[$I], $GUI_SHOW)
						Next
						GUICtrlSetData($idShowhelp, translate($sLang, "Help") & ", " & translate($sLang, "expanded"))
					Else
						For $I = 0 To UBound($aHelpButtons, $UBOUND_ROWS) - 1
							GUICtrlSetState($aHelpButtons[$I], $GUI_HIDE)
						Next
						GUICtrlSetData($idShowhelp, translate($sLang, "Help") & ", " & translate($sLang, "collapsed"))
					EndIf
				Case $aHelpButtons[0]
					ShellExecute("https://www.youtube.com/channel/UC85GqFKqjaAFrpJ7IPt6gcQ")
					If @error Then MsgBox(16, translate($sLang, "Error"), translate($sLang, "Cannot run browser. It is likely that you have to add an association."))
				Case $aHelpButtons[1]
					ShellExecute(@ScriptDir & "\documentation\" & $sLang & "\manual_radio.txt")
				Case $aHelpButtons[2]
					ShellExecute(@ScriptDir & "\documentation\" & $sLang & "\changes_radio.txt")
				Case $aHelpButtons[3]
					ShellExecute("https://www.appcreator24.com/app1372446")
					If @error Then MsgBox(16, translate($sLang, "Error"), translate($sLang, "Cannot run browser. It is likely that you have to add an association."))
				Case $aHelpButtons[4]
					MsgBox(0, translate($sLang, "About..."), translate($sLang, "MCY Radio, version") & " " & $sRadio_ver & ". " & translate($sLang, "Program to listen to content such as music, live broadcasts from users, other radios, comedy and more.") & @CRLF & "This product is sponsored by SONVA Radio")
				Case $aHelpButtons[5]
					if not @compiled then
						MsgBox(16, translate($sLang, "Error"), translate($sLang, "Can't install MCY Radio from source code"))
						ContinueLoop
					EndIf
					$bInstPressed = Not $bInstPressed
					If $bInstPressed Then
						GUICtrlSetData($aHelpButtons[5], translate($sLang, "uninstall MCY Radio"))
						installmcyradio()
					Else
						GUICtrlSetData($aHelpButtons[5], translate($sLang, "install only MCY Radio"))
						uninstallmcyradio()
					EndIf
				Case $aHelpButtons[6]
					$hPrivacy = InetRead("http://www.e-droid.net/privacy.php?ida=1372446&idl=es")
					$sPolicy = BinaryToString($hPrivacy)
					MsgBox(48, translate($sLang, "Privacy Policy"), $sPolicy)
			EndSwitch
		WEnd
		_Audio_init_stop($hMusicHandle)
	EndIf
EndFunc   ;==>Mcyradio
; #FUNCTION# ====================================================================================================================
; Name ..........: installmcyradio
; Description ...: Install MCY radio on the desktop
; Syntax ........: installmcyradio()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func installmcyradio()
	If Not FileExists(@DesktopDir & "\MCY Radio.lnk") Then
		$iInstallResult = FileCreateShortcut(@ScriptDir & "\MCY.exe", @DesktopDir & "\MCY Radio.lnk", @ScriptDir, "/radio", _
				translate($sLang, "Enjoy the best radio content, like music and live broadcasts."), "", "^!R", "", @SW_SHOW)
		if $iInstallResult == 1 then
			MsgBox(48, translate($sLang, "Information"), translate($sLang, "MCY Radio has been installed on the desktop"))
		else
			MSGBox(16, translate($sLang, "Error"), translate($sLang, "An error ocurred while installing MCY radio"))
		EndIf
	Else
		MsgBox(16, translate($sLang, "Error"), translate($sLang, "MCY Radio is already installed"))
	EndIf
	return $iInstallResult
EndFunc   ;==>installmcyradio
; #FUNCTION# ====================================================================================================================
; Name ..........: uninstallmcyradio
; Description ...: Uninstall MCY radio from computer
; Syntax ........: uninstallmcyradio()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func uninstallmcyradio()
	$confirmuninst = MsgBox(4, translate($sLang, "Uninstall MCY Radio"), translate($sLang, "Are you sure?"))
	Select
		Case $confirmuninst = 6
			$uninst = FileDelete(@DesktopDir & "\MCY Radio.lnk")
			If $uninst = 0 Then
				MsgBox(16, translate($sLang, "Error"), translate($sLang, "Failed to uninstall MCY Radio. It is likely that it has already been uninstalled."))
			Else
				MsgBox(48, translate($sLang, "Information"), translate($sLang, "MCY Radio has been uninstalled"))
			EndIf
			Return 1
	EndSelect
EndFunc   ;==>uninstallmcyradio
; #FUNCTION# ====================================================================================================================
; Name ..........: RadioSelector
; Description ...: Radio selector
; Syntax ........: RadioSelector()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func RadioSelector($hMainWindow, $aRadioList)
	$sCurrent = ""
	GUISetState(@SW_HIDE, $hMainWindow)
	$hRadio = GUICreate(translate($sLang, "List of radios"))
	GUISetBkColor(0x00E0FFFF)
	$idSelectorStatus = GUICtrlCreateLabel(translate($sLang, "select a radio from the list to turn it on and hit apply when done:"), 0, 10, 50, 20)
	GUICtrlCreateLabel(translate($sLang, "radio list"), 85, 10, 50, 20)
	$idRadioList = GUICtrlCreateListView(translate($sLang, "Number") & "|" & translate($sLang, "Radio") & "|" & translate($sLang, "URL"), 85, 90, 300, 20)
	For $I = 0 To UBound($aRadioList, $UBOUND_ROWS) - 1
		If $sLatestRadioURL = $I Then $sCurrent &= $aRadioList[$I][0] & " " & translate($sLang, "is set as default") & "."
		GUICtrlCreateListViewItem($I &"|" & $aRadioList[$I][0] & "|" & $aRadioList[$I][1], $idRadioList)
	Next
	GUICtrlSetData($idSelectorStatus, translate($sLang, "Status:") & " " & $sCurrent)
	$idCopy = GUICtrlCreateButton(translate($sLang, "Copy &URL"), 140, 10, 50, 20)
	$idAply = GUICtrlCreateButton(translate($sLang, "&Aply"), 140, 60, 50, 20)
	$idRadioClose = GUICtrlCreateButton(translate($sLang, "&Close"), 140, 120, 50, 20)
	GUISetState(@SW_SHOW)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $idRadioClose
				GUIDelete($hRadio)
				GUISetState(@SW_SHOW, ($hMainWindow)
				ExitLoop
			Case $idCopy
				$aCurrentSelection = StringSplit(GUICtrlRead(GUICtrlRead($idRadioList)), "|")
				ClipPut($aCurrentSelection[3])
				GUIDelete($hRadio)
				GUISetState(@SW_SHOW, $hMainWindow)
				ExitLoop
			Case $idAply
				$aCurrentSelection = StringSplit(GUICtrlRead(GUICtrlRead($idRadioList)), "|")
				_Audio_stop($hMusicHandle)
				_Audio_init_stop($hMusicHandle)
				$sLatestRadioURL = $aCurrentSelection[1]
				IniWrite($sConfigPath, "radio", "Last radio loaded", $sLatestRadioURL)
				_Audio_init_start()
				$MusicHandle = _Set_url($aRadioList[$sLatestRadioURL][1])
				_Audio_play($MusicHandle)
				GUIDelete($hRadio)
				GUISetState(@SW_SHOW, $hMainWindow)
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>RadioSelector
; #FUNCTION# ====================================================================================================================
; Name ..........: sayinfo
; Description ...: Stream or song information
; Syntax ........: sayinfo()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func sayinfo()
	;$MusicHandle = _Set_url(IniRead($sConfigPath, "Misc", "Last radio loaded", ""))
	Local $sInfo = _Get_streamtitle($MusicHandle)
	speaking(translate($sLang, "stream/song name:") & " " & $sInfo)
	If $sInfo = "0" Then speaking(translate($sLang, "no song is playing"))
EndFunc   ;==>sayinfo
; #FUNCTION# ====================================================================================================================
; Name ..........: _Audio_init_start
; Description ...: BASS init
; Syntax ........: _Audio_init_start()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Audio_init_start()
	If _BASS_STARTUP(@ScriptDir & "\bass.dll") Then
		If _BASS_Init(0, -1, 48000, 0) Then
			If _BASS_SetConfig($BASS_CONFIG_NET_PLAYLIST, 1) = 0 Then
				SetError(3)
			EndIf
		Else
			SetError(2)
		EndIf
	Else
		SetError(@error)
	EndIf
EndFunc   ;==>_Audio_init_start
; #FUNCTION# ====================================================================================================================
; Name ..........: _Set_buffer
; Description ...: Set buffer
; Syntax ........: _Set_buffer($buffer)
; Parameters ....: $buffer              - A boolean value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Set_buffer($buffer)
	_BASS_SetConfig($BASS_CONFIG_NET_BUFFER, $buffer)
EndFunc   ;==>_Set_buffer
; #FUNCTION# ====================================================================================================================
; Name ..........: _Audio_stop
; Description ...: Stops and audio handle
; Syntax ........: _Audio_stop($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Audio_stop($MusicHandle)
	_BASS_ChannelStop($MusicHandle)
EndFunc   ;==>_Audio_stop
; #FUNCTION# ====================================================================================================================
; Name ..........: _Audio_play
; Description ...: Plays a specific sound
; Syntax ........: _Audio_play($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Audio_play($MusicHandle)
	_BASS_ChannelPlay($MusicHandle, 1)
EndFunc   ;==>_Audio_play
; #FUNCTION# ====================================================================================================================
; Name ..........: _Audio_pause
; Description ...: stops playing a specific audio
; Syntax ........: _Audio_pause($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Audio_pause($MusicHandle)
	If _Get_playstate($MusicHandle) = 2 Then
		$BASS_PAUSE_POS = _BASS_ChannelGetPosition($MusicHandle, $BASS_POS_BYTE)
		_BASS_ChannelPause($MusicHandle)
	ElseIf _Get_playstate($MusicHandle) = 3 Then
		_Audio_play($MusicHandle)
		_BASS_ChannelSetPosition($MusicHandle, $BASS_PAUSE_POS, $BASS_POS_BYTE)
	EndIf
EndFunc   ;==>_Audio_pause
; #FUNCTION# ====================================================================================================================
; Name ..........: _Audio_init_stop
; Description ...: stops playing a specific audio
; Syntax ........: _Audio_init_stop($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Audio_init_stop($MusicHandle)
	_BASS_StreamFree($MusicHandle)
	_BASS_Free()
EndFunc   ;==>_Audio_init_stop
; #FUNCTION# ====================================================================================================================
; Name ..........: _Set_url
; Description ...: set a URL as a sound to load to BASS
; Syntax ........: _Set_url($file)
; Parameters ....: $file                - A floating point number value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Set_url($file)
	If FileExists($file) Then
		$MusicHandle = _BASS_StreamCreateFile(False, $file, 0, 0, 0)
	Else
		$MusicHandle = _BASS_StreamCreateURL($file, 0, 1)
	EndIf
	If @error Then
		Return SetError(1)
	EndIf
	Return $MusicHandle
EndFunc   ;==>_Set_url
; #FUNCTION# ====================================================================================================================
; Name ..........: _Get_pos
; Description ...: get the position of a song
; Syntax ........: _Get_pos($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Get_pos($MusicHandle)
	$current = _BASS_ChannelGetPosition($MusicHandle, $BASS_POS_BYTE)
	Return Round(_Bass_ChannelBytes2Seconds($MusicHandle, $current))
EndFunc   ;==>_Get_pos
; #FUNCTION# ====================================================================================================================
; Name ..........: _Get_len
; Description ...: get the lenght of a song
; Syntax ........: _Get_len($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Get_len($MusicHandle)
	$current = _BASS_ChannelGetLength($MusicHandle, $BASS_POS_BYTE)
	Return Round(_Bass_ChannelBytes2Seconds($MusicHandle, $current))
EndFunc   ;==>_Get_len
; #FUNCTION# ====================================================================================================================
; Name ..........: _Set_pos
; Description ...: Set's the lenght of a song
; Syntax ........: _Set_pos($MusicHandle, $seconds)
; Parameters ....: $MusicHandle         - An unknown value.
;                  $seconds             - A string value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Set_pos($MusicHandle, $seconds)
	_BASS_ChannelSetPosition($MusicHandle, _BASS_ChannelSeconds2Bytes($MusicHandle, $seconds), $BASS_POS_BYTE)
EndFunc   ;==>_Set_pos
; #FUNCTION# ====================================================================================================================
; Name ..........: _Set_volume
; Description ...: Set's the volume of a song
; Syntax ........: _Set_volume($volume)
; Parameters ....: $volume              - A variant value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Set_volume($volume)
	_BASS_SetConfig($BASS_CONFIG_GVOL_STREAM, $volume * 100)
EndFunc   ;==>_Set_volume
; #FUNCTION# ====================================================================================================================
; Name ..........: _Get_volume
; Description ...: Gets the volume of a song
; Syntax ........: _Get_volume()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Get_volume()
	Return _BASS_GetConfig($BASS_CONFIG_GVOL_STREAM) / 100
EndFunc   ;==>_Get_volume
; #FUNCTION# ====================================================================================================================
; Name ..........: _Get_bitrate
; Description ...: get the bit rate of an audio
; Syntax ........: _Get_bitrate($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Get_bitrate($MusicHandle)
	$iAudioLen = Round(_Bass_ChannelBytes2Seconds($MusicHandle, _BASS_ChannelGetLength($MusicHandle, $BASS_POS_BYTE)))
	$return = Round(_BASS_StreamGetFilePosition($MusicHandle, $BASS_FILEPOS_END) * 8 / $iAudioLen / 1000)
	If StringInStr($return, "-") Then
		$return = _BASS_StreamGetFilePosition($MusicHandle, $BASS_FILEPOS_END) * 8 / _BASS_GetConfig($BASS_CONFIG_NET_BUFFER)
	EndIf
	Return $return
EndFunc   ;==>_Get_bitrate
; #FUNCTION# ====================================================================================================================
; Name ..........: _Get_playstate
; Description ...: Get the playback status of a song
; Syntax ........: _Get_playstate($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Get_playstate($MusicHandle)
	Switch _BASS_ChannelIsActive($MusicHandle)
		Case $BASS_ACTIVE_STOPPED
			$returnstate = 1
		Case $BASS_ACTIVE_PLAYING
			$returnstate = 2
		Case $BASS_ACTIVE_PAUSED
			$returnstate = 3
		Case $BASS_ACTIVE_STALLED
			$returnstate = 4
	EndSwitch
	Return $returnstate
EndFunc   ;==>_Get_playstate
; #FUNCTION# ====================================================================================================================
; Name ..........: _Get_streamtitle
; Description ...: get the name of the song
; Syntax ........: _Get_streamtitle($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Get_streamtitle($MusicHandle)
	$pPtr = _BASS_ChannelGetTags($MusicHandle, $BASS_TAG_META)
	$sStr = _BASS_PtrStringRead($pPtr)
	If StringInStr($sStr, ";") Then
		$infosplit = StringSplit($sStr, ";")
		$infosplit[1] = StringReplace($infosplit[1], "'", "")
		$infosplit[1] = StringReplace($infosplit[1], "StreamTitle=", "")
		If StringInStr($infosplit[1], "-") Then
			Return $infosplit[1]
		EndIf
	EndIf
EndFunc   ;==>_Get_streamtitle
