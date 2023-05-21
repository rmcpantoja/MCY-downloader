#include <AutoItConstants.au3>
#include "GuiConstantsEx.au3"
#include "radio.au3"
; #FUNCTION# ====================================================================================================================
; Name ..........: search
; Description ...: Search whit youtube-dl or youtube-dlp
; Syntax ........: search()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func search()
	Global $searchgui = GUICreate(translate($lng, "Search"))
	$ReadAccs = IniRead("config\config.st", "Accessibility", "Enable enanced accessibility", "")
	$showtip = IniRead("config\config.st", "misc", "Show tips", "")
	$sayProgresses = IniRead("config\config.st", "Accessibility", "Read download progress bar", "")
	$sayTime = IniRead("config\config.st", "Accessibility", "Read download remaining time", "")
	$BeepProgresses = IniRead("config\config.st", "Accessibility", "Beep for progress bars", "")
	Global $cantidad = IniRead("config\config.st", "search", "Number of results", "")
	Select
		Case $sayProgresses = ""
			IniWrite("config\config.st", "Accessibility", "Read download progress bar", "Yes")
	EndSelect
	Select
		Case $sayTime = ""
			IniWrite("config\config.st", "Accessibility", "Read download remaining time", "No")
	EndSelect
	Select
		Case $BeepProgresses = ""
			IniWrite("config\config.st", "Accessibility", "Beep for progress bars", "Yes")
	EndSelect
	Select
		Case $cantidad = ""
			IniWrite("config\config.st", "search", "Number of results", "25")
	EndSelect
	$idSearchlabel = GUICtrlCreateLabel(translate($lng, "Write what you want to search for:"), 10, 30, 20, 20)
	Global $inputsearch = GUICtrlCreateInput("", 10, 50, 20, 30)
	$search_btn = GUICtrlCreateButton(translate($lng, "Search"), 45, 50, 20, 25)
	$close_btn = GUICtrlCreateButton(translate($lng, "Close"), 110, 50, 20, 25)
	GUISetState(@SW_SHOW)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $close_btn
				GUIDelete($searchgui)
				Menuprogram()
			Case $search_btn
				Global $textoBusqueda = GUICtrlRead($inputsearch)
				guiResultados()
		EndSwitch
	WEnd
EndFunc   ;==>search
; #FUNCTION# ====================================================================================================================
; Name ..........: ytsearch
; Description ...: Youtube search handler
; Syntax ........: ytsearch($text [, $DownloadAllVideos="0"])
; Parameters ....: $text                - A dll struct value.
;                  $DownloadAllVideos   - [optional] An AutoIt controlID. Default is "0".
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func ytsearch($text, $DownloadAllVideos = "0")
	Local $line
	$bagground = $device.opensound("sounds/update.ogg", True)
	$bagground.volume = 0.25
	$bagground.play
	$bagground.repeating = 1
	;Local $runcmd = Run(@ComSpec & " /C " & "engines64\youtube-dl-.exe -e ytsearch" &$cantidad &":" &$text, @ScriptDir, @SW_HIDE, 6)
	Select
		Case $DownloadAllVideos = "0"
			If @OSArch = "x64" Then
				Local $runcmd = Run(@ComSpec & " /C " & "engines64\yt-dlp.exe -e ytsearch" & $cantidad & ":" & $text, @ScriptDir, @SW_HIDE, 6)
				MsgBox(0, "Debug", "engines64\yt-dlp.exe ytsearch" & $cantidad & ":" & $text)
			Else
				Local $runcmd = Run(@ComSpec & " /C " & "engines\yt-dlp_x86.exe -e -g ytsearch" & $cantidad & ":" & $text, @ScriptDir, @SW_HIDE, 6)
			EndIf
		Case $DownloadAllVideos = "1"
			If @OSArch = "x64" Then
				Local $runcmd = Run(@ComSpec & " /C " & "engines64\yt-dlp.exe ytsearch" & $cantidad & ":" & $text, @ScriptDir, @SW_HIDE, 6)
			Else
				Local $runcmd = Run(@ComSpec & " /C " & "engines\yt-dlp_x86.exe ytsearch" & $cantidad & ":" & $text, @ScriptDir, @SW_HIDE, 6)
			EndIf
	EndSelect
	If @error Then
		MsgBox(16, translate($lng, "Error"), translate($lng, "The operation cannot be performed because the Youtube-dl.exe file cannot be found."))
	Else
	EndIf
	ProcessWaitClose($runcmd)
	Local $line = StdoutRead($runcmd)
	If @error Then MsgBox(16, translate($lng, "Error"), translate($lng, "Can't read stdout"))
	$bagground.stop
	MsgBox(48, "Linea de resultados", $line)
	Return $line
EndFunc   ;==>ytsearch
; #FUNCTION# ====================================================================================================================
; Name ..........: guiResultados
; Description ...: Search results
; Syntax ........: guiResultados()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func guiResultados()
	GUISetState(@SW_HIDE, $searchgui)
	Global $results = GUICreate(translate($lng, "Search results"))
	Local $idReslabel = GUICtrlCreateLabel(translate($lng, "List of results below:"), 120, 30, 20, 20)
	Local $idSlist = GUICtrlCreateList("", 150, 30, 200, 50)
	GUICtrlSetLimit(-1, 300)
	$cname_btn = GUICtrlCreateButton(translate($lng, "Copy title"), 190, 50, 20, 25)
	$clink_btn = GUICtrlCreateButton(translate($lng, "Copy download link"), 220, 50, 20, 25)
	$preb_btn = GUICtrlCreateButton(translate($lng, "Listen preview"), 250, 50, 20, 25)
	$cs_btn = GUICtrlCreateButton(translate($lng, "Close"), 280, 50, 30, 30)
	$loTengo = ytsearch($textoBusqueda)
	GUISetState(@SW_SHOW)
	$listita = StringSplit($loTengo, @LF)
	For $listartitulos = 1 To $cantidad
		;GUICtrlSetData($idSlist, translate($lng, "Title:") &": " &$listita[$listartitulos])
		GUICtrlSetData($idSlist, $listita[$listartitulos])
	Next
	; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $cs_btn
				GUIDelete($results)
				GUISetState(@SW_SHOW, $searchgui)
				ExitLoop
			Case $clink_btn
				ClipPut(GUICtrlRead($idSlist))
			Case $preb_btn
				Global $seleccionado = GUICtrlRead($idSlist)
				preb()
		EndSwitch
	WEnd
EndFunc   ;==>guiResultados
; #FUNCTION# ====================================================================================================================
; Name ..........: preb
; Description ...: Plays a preview
; Syntax ........: preb()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func preb()
	$playing = GUICreate(translate($lng, "Playing..."))
	GUISetState(@SW_SHOW)
	If Not StringInStr($seleccionado, "https://") Then
		MsgBox(16, translate($lng, "error"), translate($lng, "The URL is not recognized"))
	EndIf
	Local $MusicHandle
	_Audio_init_start()
	$MusicHandle = _Set_url($seleccionado)
	If @error Then
		MsgBox(16, translate($lng, "error"), translate($lng, "An error occurred while playing the URL. Reason: ") & @extended)
		;Exit
	EndIf
	_Audio_play($MusicHandle)
	Local $idBtn_Stop = GUICtrlCreateButton(translate($lng, "Stop"), 75, 40, 50, 25)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $idBtn_Stop
				_Audio_stop($MusicHandle)
				_Audio_init_stop($MusicHandle)
				GUIDelete($playing)
		EndSwitch
	WEnd
EndFunc   ;==>preb
