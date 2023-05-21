#include "options.au3"
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
	Global $PROGRAMGUI = GUICreate("MCY Downloader " & $program_ver, 500, 500)
	; We set the keyboard shortcut to view to the help document.
	HotKeySet("{F1}", "playhelp")
	$ReadAccs = IniRead("config\config.st", "Accessibility", "Enable enanced accessibility", "")
	; Now we will create the menus along with their respective options.
	; We add multi-language support.
	Local $idDownload = GUICtrlCreateMenu("&MCY")
	Local $idDownloaditem = GUICtrlCreateMenuItem(translate($lng, "Download multimedia link, playlists and more..."), $idDownload)
	Local $idSearchitem = GUICtrlCreateMenuItem(translate($lng, "Search from youtube"), $idDownload)
	Local $idRadioitem = GUICtrlCreateMenuItem(translate($lng, "Radio"), $idDownload)
	Local $idOptionsitem = GUICtrlCreateMenuItem(translate($lng, "Options..."), $idDownload)
	GUICtrlSetState(-1, $GUI_DEFBUTTON)
	Local $idTSmenu = GUICtrlCreateMenu(translate($lng, "Tools"))
	Local $idconvitem = GUICtrlCreateMenuItem(translate($lng, "Convert files..."), $idTSmenu)
	Local $idURLitem = GUICtrlCreateMenuItem(translate($lng, "Play audio URL online"), $idTSmenu)
	Local $idorderitem = GUICtrlCreateMenuItem(translate($lng, "Re-organize audios and videos now"), $idTSmenu)
	Local $idHelpmenu = GUICtrlCreateMenu(translate($lng, "Help"))
	Local $idChanges = GUICtrlCreateMenuItem(translate($lng, "Changes"), $idHelpmenu)
	Local $idHelpitemc = GUICtrlCreateMenuItem(translate($lng, "&User manual"), $idHelpmenu)
	Local $idErrorreporting = GUICtrlCreateMenuItem(translate($lng, "Errors and suggestions"), $idHelpmenu)
	Local $idGitHub = GUICtrlCreateMenuItem(translate($lng, "Errors and suggestions (gitHub)"), $idHelpmenu)
	Local $idHelpitemb = GUICtrlCreateMenuItem(translate($lng, "&Visit website"), $idHelpmenu)
	Local $idCheckupdates = GUICtrlCreateMenuItem(translate($lng, "Check for updates..."), $idHelpmenu)
	Local $idHelpitema = GUICtrlCreateMenuItem(translate($lng, "About..."), $idHelpmenu)
	Local $idExititem = GUICtrlCreateMenuItem(translate($lng, "E&xit"), $idDownload)
	GUICtrlCreateMenuItem("", $idDownload, 2)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateLabel(translate($lng, "Open the menu or explore the following options:"), 20, 50)
	GUICtrlSetState(-1, $GUI_FOCUS)
	Local $idMenubtn = GUICtrlCreateButton(translate($lng, "Open menu"), 20, 50 + (1 * 40), 100, 30)
	Local $idManualbutton = GUICtrlCreateButton(translate($lng, "&User Manual"), 20, 50 + (2 * 40), 100, 30)
	Local $idChangesbutton = GUICtrlCreateButton(translate($lng, "Changes"), 20, 50 + (3 * 40), 100, 30)
	Local $idGithubBTN = GUICtrlCreateButton("Github", 20, 50 + (4 * 40), 100, 30)
	Local $idShareBTN = GUICtrlCreateButton(translate($lng, "Share"), 20, 50 + (5 * 40), 100, 30)
	Local $idExitbutton = GUICtrlCreateButton(translate($lng, "E&xit"), 20, 50 + (6 * 40), 100, 30)
	GUISetState(@SW_SHOW)
	; Now we are going to give more meaning to each menu option, especially the one chosen by the user.
	While 1
		Switch GUIGetMsg()
			Case $idDownloaditem
				writeinlog("Function: download from link...")
				GUISetState(@SW_HIDE, $PROGRAMGUI)
				Imputdownload()
			Case $idSearchitem
				writeinlog("Function: Search.")
				GUISetState(@SW_HIDE, $PROGRAMGUI)
				Search()
			Case $idRadioitem
				writeinlog("Function: Radio.")
				Radio()
			Case $idconvitem
				writeinlog("Function: mp3Converter()")
				mp3Converter()
			Case $idURLitem
				writeinlog("Function: ReproducirURL()")
				ReproducirURL()
			Case $idorderitem
				writeinlog("Function: reOrganizar()")
				reOrganizar()
			Case $idOptionsitem
				writeinlog("Function: options")
				Sleep(100)
				If $ReadAccs = "yes" Then
					$hOptionsGui = GUICreate("options menu (accessibility)")
					GUISetState(@SW_SHOW)
					Sleep(500)
					menu_options()
					GUIDelete($hOptionsGui)
				Else
					menu_options2()
				EndIf
			Case $idChanges
				If $ReadAccs = "yes" Then
					readchanges()
				Else
					readchanges2()
				EndIf
			Case $idErrorreporting
				ShellExecute("https://docs.google.com/forms/d/e/1FAIpQLSdDW6LqMKGHjUdKmHkAZdAlgSDilHaWQG9VZjwLz0CJSXKqHA/viewform?usp=sf_link")
				If @error Then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
			Case $idGitHub
				ShellExecute("https://github.com/rmcpantoja/MCY-downloader/issues/new")
				If @error Then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
			Case $idCheckupdates
				writeinlog("Checking components...")
				GUISetState(@SW_HIDE, $PROGRAMGUI)
				updcomponents()
			Case $GUI_EVENT_CLOSE, $idExitbutton, $idExititem
				exitpersonaliced()
			Case $idHelpitema
				; This is the dialog about the program in which it will be shown on the screen.
				MsgBox(48, translate($lng, "About..."), $programname & ", " & translate($lng, "version") & $program_ver & ". " & translate($lng, "Program developed by mateo cedillo. This software is used to download multimedia from a variety of sites. 2018-2022 MT programs."))
				ContinueLoop
			Case $idHelpitemb
				ShellExecute("http://mateocedillo.260mb.net/")
				If @error Then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
			Case $idHelpitemc
				writeinlog("function: User manual.")
				playhelp()
			Case $idMenubtn
				Send("{alt}")
			Case $idManualbutton
				playhelp()
			Case $idChangesbutton
				If $ReadAccs = "yes" Then
					readchanges()
				Else
					readchanges2()
				EndIf
			Case $idGithubBTN
				ShellExecute("https://github.com/rmcpantoja/")
				If @error Then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
			Case $idShareBTN
				Opt("GUIOnEventMode", 1)
				share(translate($lng, "Hello! I share with you MCY Downloader, a software to download multimedia in high quality, videos, music, playlists, users and everything you want in a single click; rearrange your music, audio converter, radio and more!. Visit download page here, where you will find the versions for 32 and 64-bit:"), "http://mateocedillo.260mb.net/programs.html")
				Opt("GUIOnEventMode", 0)
		EndSwitch
	WEnd
	GUIDelete()
EndFunc   ;==>Menuprogram
; #FUNCTION# ====================================================================================================================
; Name ..........: playhelp
; Description ...: User manual
; Syntax ........: playhelp()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func playhelp()
	Opt("GUIOnEventMode", 0)
	Local $manualdoc = "documentation\" & $lng & "\manual.txt"
	Global $DocOpen = FileOpen($manualdoc, $FO_READ)
	If $accessibility = "yes" Then
		speaking(translate($lng, "opening..."))
	Else
		ToolTip(translate($lng, "opening..."))
	EndIf
	If $DocOpen = -1 Then MsgBox($MB_SYSTEMMODAL, translate($lng, "Error"), translate($lng, "An error occurred while reading the file."))
	Local $openned = FileRead($DocOpen)
	If $accessibility = "no" Then ToolTip("")
	Global $manualwindow = GUICreate(translate($lng, "User manual"))
	Local $idMyedit = GUICtrlCreateEdit($openned, 5, 5, 390, 360, BitOR($WS_VSCROLL, $WS_HSCROLL, $ES_READONLY))
	Local $idExitBtn2 = GUICtrlCreateButton(translate($lng, "Close"), 100, 370, 150, 30)
	GUISetState(@SW_SHOW)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $idExitBtn2
				FileClose($DocOpen)
				ExitLoop
		EndSwitch
	WEnd
	GUIDelete()
EndFunc   ;==>playhelp
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
	Global $ventana = GUICreate(translate($lng, "Play URL"))
	Global $playlabel = GUICtrlCreateLabel(translate($lng, "Enter URL, Please enter the direct multimedia link you want to play."), 0, 50, 20, 20)
	$urlinput = GUICtrlCreateInput("", 0, 70, 20, 20)
	$ok = GUICtrlCreateButton(translate($lng, "OK"), 70, 50, 20, 20)
	$cancel = GUICtrlCreateButton(translate($lng, "Cancel"), 130, 50, 20, 20)
	GUISetState(@SW_SHOW)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $cancel
				GUIDelete($ventana)
				Menuprogram()
			Case $ok
				Global $enlace = GUICtrlRead($urlinput)
				If $enlace = "" Then
					MsgBox(16, translate($lng, "Error"), translate($lng, "There is no URL!"))
					ContinueLoop
				Else
					PlayDirectAudioURL($enlace)
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>ReproducirURL
