; #FUNCTION# ====================================================================================================================
; Name ..........: checKmcyversion
; Description ...: Check MCY version
; Syntax ........: checKmcyversion()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func checKmcyversion()
	$ReadAccs = IniRead($sConfigPath, "Accessibility", "Enable enanced accessibility", "")
	writeinlog("Checking for updates...")
	Local $yourexeversion = $sProgram_ver
	$fileinfo = InetGet("https://www.dropbox.com/s/hcx20lgvjem0wz1/MCYWeb.dat?dl=1", @TempDir & "\MCYWeb.dat")
	$latestver = IniRead(@TempDir & "\MCYWeb.dat", "updater", "LatestVersion", "")
	If $ReadAccs = "Yes" Then
		Select
			Case $latestver <> $yourexeversion
				writeinlog("Warning! Update available. Your version:" & $yourexeversion & ". New version:" & $latestver)
				CreateTTSDialog(translate($lng, "Update available!"), translate($lng, "You have the version") & " " & $yourexeversion & " " & translate($lng, "and is available the") & " " & $latestver, translate($lng, " press enter to continue, space to repeat information."))
				GUIDelete($main_u)
				If $sArchitecture = "x64" Then
					_Updater_update("MCY.exe", "https://www.dropbox.com/s/d49pf4blsv61aoz/extract.exe?dl=1")
				Else
					_Updater_update("MCY.exe", "https://www.dropbox.com/s/ccp9mjaw35gzn9s/extract_x86.exe?dl=1")
				EndIf
			Case Else
				GUIDelete($main_u)
				checkmotd()
		EndSelect
	EndIf
	If $ReadAccs = "No" Then
		Select
			Case $latestver <> $yourexeversion
				writeinlog(translate($lng, "You have the version") & " " & $sProgram_ver & " " & translate($lng, "and is available the") & " " & $latestver)
				MsgBox(0, translate($lng, "Update available!"), translate($lng, "You have the version") & " " & $sProgram_ver & " " & translate($lng, "and is available the") & " " & $latestver)
				If $sArchitecture = "x64" Then
					_Updater_update("MCY.exe", "https://www.dropbox.com/s/d49pf4blsv61aoz/extract.exe?dl=1")
				Else
					_Updater_update("MCY.exe", "https://www.dropbox.com/s/ccp9mjaw35gzn9s/extract_x86.exe?dl=1")
				EndIf
			Case Else
				checkmotd()
		EndSelect
	EndIf
	InetClose($fileinfo)
	GUIDelete($main_u)
EndFunc   ;==>checKmcyversion

; #FUNCTION# ====================================================================================================================
; Name ..........: updcomponents
; Description ...: Update youtube-dl or youtube-dlp
; Syntax ........: updcomponents()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func updcomponents()
	writeinlog("Updating Yt-Dlp...")
	If Not FileExists($sYouTube_DL) Then
		MsgBox(16, translate($lng, "Error"), translate($lng, "YT-dlp not found."))
		exitpersonaliced()
	EndIf
	$update = $device.opensound("sounds/update.ogg", 0)
	;Plays bagground music when UPDATE.
	$update.play
	$update.repeating = 1
	$g_hGui = GUICreate(translate($lng, "Looking for YT-DLP update"))
	GUISetState(@SW_SHOW)
	$updatelabel = GUICtrlCreateLabel(translate($lng, "Please wait."), 25, 16)
	TrayTip(translate($lng, "Please wait."), translate($lng, "Please wait while the YouTube library update is being searched."), 0, $TIP_ICONASTERISK)
	Local $iPID = Run(@ComSpec & ' /C "' & $sYouTube_DL & '" --update', @ScriptDir, @SW_HIDE, 6)
	ProcessWaitClose($iPID)
	$update.stop
	If Not StringInStr(StdoutRead($iPID), 'yt-dlp is up to date') Then
		writeinlog(StdoutRead($iPID))
		MsgBox(48, translate($lng, "Done"), translate($lng, "Yt-dlp should be updated. Enjoin!"))
	Else
		MsgBox(48, translate($lng, "Everything is up to date"), translate($lng, "There is no update at the moment."))
	EndIf
	GUIDelete($g_hGui)
	GUISetState(@SW_SHOW, $PROGRAMGUI)
EndFunc   ;==>updcomponents