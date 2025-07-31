#include "busqueda.au3"
#include "downloader.au3"
#include "globals.au3"
#include "..\miscstring.au3"
#include "Mp3_converter.au3"
#include "options.au3"
#include "Player.au3"
#include "radio.au3"
#include "reorder-gui.au3"
#include-once
; This is the function to support the MCY Downloader interface. We are going to create a window.
; #FUNCTION# ====================================================================================================================
; Name ..........: Menuprogram
; Description ...: Main interface
; Syntax ........: Menuprogram()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Menuprogram()
	; We create the window.
	Global $PROGRAMGUI = GUICreate("MCY Downloader " & $sProgram_ver, 500, 500)
	; We set the keyboard shortcut to view to the help document.
	;HotKeySet("{F1}", "playhelp")
	; Now we will create the menus along with their respective options.
	; We add multi-language support.
	Local $idDownload = GUICtrlCreateMenu("&MCY")
	Local $idDownloaditem = GUICtrlCreateMenuItem(translate($sLang, "Download multimedia link, playlists and more..."), $idDownload)
	Local $idSearchitem = GUICtrlCreateMenuItem(translate($sLang, "Search from youtube"), $idDownload)
	Local $idRadioitem = GUICtrlCreateMenuItem(translate($sLang, "Radio"), $idDownload)
	Local $idOptionsitem = GUICtrlCreateMenuItem(translate($sLang, "Options..."), $idDownload)
	GUICtrlSetState(-1, $GUI_DEFBUTTON)
	Local $idTSmenu = GUICtrlCreateMenu(translate($sLang, "Tools"))
	Local $idconvitem = GUICtrlCreateMenuItem(translate($sLang, "Convert files..."), $idTSmenu)
	Local $idURLitem = GUICtrlCreateMenuItem(translate($sLang, "Play audio URL online"), $idTSmenu)
	Local $idorderitem = GUICtrlCreateMenuItem(translate($sLang, "Re-organize audios and videos now"), $idTSmenu)
	Local $idHelpmenu = GUICtrlCreateMenu(translate($sLang, "Help"))
	Local $idChanges = GUICtrlCreateMenuItem(translate($sLang, "Changes"), $idHelpmenu)
	Local $idHelpitemc = GUICtrlCreateMenuItem(translate($sLang, "&User manual"), $idHelpmenu)
	Local $idErrorreporting = GUICtrlCreateMenuItem(translate($sLang, "Errors and suggestions"), $idHelpmenu)
	Local $idGitHub = GUICtrlCreateMenuItem(translate($sLang, "Errors and suggestions (gitHub)"), $idHelpmenu)
	Local $idHelpitemb = GUICtrlCreateMenuItem(translate($sLang, "&Visit website"), $idHelpmenu)
	Local $idCheckupdates = GUICtrlCreateMenuItem(translate($sLang, "Check for updates..."), $idHelpmenu)
	Local $idHelpitema = GUICtrlCreateMenuItem(translate($sLang, "About..."), $idHelpmenu)
	Local $idExititem = GUICtrlCreateMenuItem(translate($sLang, "E&xit"), $idDownload)
	GUICtrlCreateMenuItem("", $idDownload, 2)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateLabel(translate($sLang, "Open the menu or explore the following options:"), 20, 50)
	GUICtrlSetState(-1, $GUI_FOCUS)
	Local $idMenubtn = GUICtrlCreateButton(translate($sLang, "Open menu"), 20, 50 + (1 * 40), 100, 30)
	Local $idManualbutton = GUICtrlCreateButton(translate($sLang, "&User Manual"), 20, 50 + (2 * 40), 100, 30)
	Local $idChangesbutton = GUICtrlCreateButton(translate($sLang, "Changes"), 20, 50 + (3 * 40), 100, 30)
	Local $idGithubBTN = GUICtrlCreateButton("Github", 20, 50 + (4 * 40), 100, 30)
	Local $idShareBTN = GUICtrlCreateButton(translate($sLang, "Share"), 20, 50 + (5 * 40), 100, 30)
	Local $idExitbutton = GUICtrlCreateButton(translate($sLang, "E&xit"), 20, 50 + (6 * 40), 100, 30)
	GUISetState(@SW_SHOW)
	; Now we are going to give more meaning to each menu option, especially the one chosen by the user.
	While 1
		Switch GUIGetMsg()
			Case $idDownloaditem
				_FileWriteLog($hFileLog, "Function: download from link...")
				GUISetState(@SW_HIDE, $PROGRAMGUI)
				Imputdownload()
			Case $idSearchitem
				_FileWriteLog($hFileLog, "Function: Search.")
				GUISetState(@SW_HIDE, $PROGRAMGUI)
				Search()
			Case $idRadioitem
				_FileWriteLog($hFileLog, "Function: Radio.")
				Radio()
			Case $idconvitem
				_FileWriteLog($hFileLog, "Function: mp3Converter()")
				mp3Converter()
			Case $idURLitem
				_FileWriteLog($hFileLog, "Function: ReproducirURL()")
				ReproducirURL()
			Case $idorderitem
				_FileWriteLog($hFileLog, "Function: reOrganizar()")
				reOrganizar()
			Case $idOptionsitem
				_FileWriteLog($hFileLog, "Function: options")
				Sleep(100)
				If $sEnhancedAccessibility = "yes" Then
					$hOptionsGui = GUICreate("options menu (accessibility)")
					GUISetState(@SW_SHOW)
					Sleep(500)
					menu_options()
					GUIDelete($hOptionsGui)
				Else
					menu_options2()
				EndIf
			Case $idErrorreporting
				ShellExecute("https://docs.google.com/forms/d/e/1FAIpQLSdDW6LqMKGHjUdKmHkAZdAlgSDilHaWQG9VZjwLz0CJSXKqHA/viewform?usp=sf_link")
				If @error Then MsgBox(16, translate($sLang, "Error"), translate($sLang, "Cannot run browser. It is likely that you have to add an association."))
			Case $idGitHub
				ShellExecute("https://github.com/rmcpantoja/MCY-downloader/issues/new")
				If @error Then MsgBox(16, translate($sLang, "Error"), translate($sLang, "Cannot run browser. It is likely that you have to add an association."))
			Case $idCheckupdates
				_FileWriteLog($hFileLog, "Checking components...")
				GUISetState(@SW_HIDE, $PROGRAMGUI)
				updcomponents($PROGRAMGUI)
			Case $GUI_EVENT_CLOSE, $idExitbutton, $idExititem
				exitpersonaliced()
			Case $idHelpitema
				; This is the dialog about the program in which it will be shown on the screen.
				MsgBox(48, translate($sLang, "About..."), $sProgramName & ", " & translate($sLang, "version") & $sProgram_ver & ". " & translate($sLang, "Program developed by mateo cedillo. This software is used to download multimedia from a variety of sites. 2018-2022 MT programs."))
				ContinueLoop
			Case $idHelpitemb
				ShellExecute("http://mateocedillo.260mb.net/")
				If @error Then MsgBox(16, translate($sLang, "Error"), translate($sLang, "Cannot run browser. It is likely that you have to add an association."))
			Case $idHelpitemc, $idManualbutton
				_FileWriteLog($hFileLog, "function: User manual.")
				_ReadDoc($sLang, "Manual", $sEnhancedAccessibility)
			Case $idMenubtn
				Send("{alt}")
			Case $idChanges, $idChangesbutton
				_ReadDoc($sLang, "Changes", $sEnhancedAccessibility)
			Case $idGithubBTN
				ShellExecute("https://github.com/rmcpantoja/")
				If @error Then MsgBox(16, translate($sLang, "Error"), translate($sLang, "Cannot run browser. It is likely that you have to add an association."))
			Case $idShareBTN
				Opt("GUIOnEventMode", 1)
				share(translate($sLang, "Hello! I share with you MCY Downloader, a software to download multimedia in high quality, videos, music, playlists, users and everything you want in a single click; rearrange your music, audio converter, radio and more!. Visit download page here, where you will find the versions for 32 and 64-bit:"), "http://mateocedillo.260mb.net/programs.html", $sLang)
				Opt("GUIOnEventMode", 0)
		EndSwitch
	WEnd
	GUIDelete()
EndFunc   ;==>Menuprogram
Func _ReadDoc($sLang, $sTipe, $sAccessibility)
	Local $hGui
	Local $sContent, $sDocumentationPath = @ScriptDir & "\documentation\" & $sLang, $sGuiName
	If $sTipe = "Changes" Then
		$sDoc = $sDocumentationPath & "\changes.txt"
		$sGuiName = Translate($sLang, "Changes")
	ElseIf $sTipe = "Manual" Then
		$sGuiName = Translate($sLang, "User manual")
		$sDoc = $sDocumentationPath & "\manual.txt"
	Else
		Return SetError(1, 0, "")
	EndIf
	$hChangesGui = GUICreate($sGuiName)
	if $sAccessibility = "yes" then
		Local $hFile = FileOpen($sDoc, $FO_READ)
		If $hFile = -1 Then
			MsgBox(16, translate($sLang, "error"), translate($sLang, "An error occurred when reading the file."))
			Return SetError(2, 0, "")
		EndIf
		$sContent = FileRead($hFile)
		$idEdit = GUICtrlCreateEdit($sContent, 5, 5, 390, 360, BitOR($WS_VSCROLL, $WS_HSCROLL, $WS_TABSTOP, $ES_READONLY))
		$idExit = GUICtrlCreateButton(translate($sLang, "&Close"), 100, 370, 150, 30)
	else
		createTtsDocument($sDoc, $sGuiName)
	EndIf
	GUISetState(@SW_SHOW)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $idExit
				if isDeclared("hFile") then FileClose($hFile)
				ExitLoop
		EndSwitch
	WEnd
	GUIDelete($hChangesGui)
EndFunc   ;==>_ReadDoc

; #FUNCTION# ====================================================================================================================
; Name ..........: run_browser
; Description ...: opens a given URL using the system's association for http entries. If not, shows the error message.
; Syntax ........: run_browser($sURL)
; Parameters ....: $sURL                - a string value containing the URL to open.
; Return values .: The handler of ShellExecute
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func run_browser($sURL)
	If Not _String_startsWith($sURL, "http") Then Return SetError(1, 0, "")
	$xRet = ShellExecute($sURL)
	If @error Then MsgBox(16, translate($sLang, "Error"), translate($sLang, "Cannot run browser. It is likely that you have to add an association."))
	Return $xRet
EndFunc   ;==>run_browser
; #FUNCTION# ====================================================================================================================
; Name ..........: ReproducirURL
; Description ...: url player
; Syntax ........: ReproducirURL()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func ReproducirURL()
	Global $ventana = GUICreate(translate($sLang, "Play URL"))
	Global $playlabel = GUICtrlCreateLabel(translate($sLang, "Enter URL, Please enter the direct multimedia link you want to play."), 0, 50, 20, 20)
	$urlinput = GUICtrlCreateInput("", 0, 70, 20, 20)
	$ok = GUICtrlCreateButton(translate($sLang, "OK"), 70, 50, 20, 20)
	$cancel = GUICtrlCreateButton(translate($sLang, "Cancel"), 130, 50, 20, 20)
	GUISetState(@SW_SHOW)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $cancel
				GUIDelete($ventana)
				Menuprogram()
			Case $ok
				Global $enlace = GUICtrlRead($urlinput)
				If $enlace = "" Then
					MsgBox(16, translate($sLang, "Error"), translate($sLang, "There is no URL!"))
					ContinueLoop
				Else
					PlayDirectAudioURL($enlace)
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>ReproducirURL
