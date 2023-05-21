; options
#include-once
; #FUNCTION# ====================================================================================================================
; Name ..........: menu_options
; Description ...: program options
; Syntax ........: menu_options()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func menu_options()
	; This option is to add the program's options menu, where you can configure everything your way.
	$sLanguage = IniRead("config\config.st", "General settings", "language", "")
	$download_dir = IniRead("config\config.st", "General settings", "Destination folder", "")
	$Rpositioning = IniRead("config\config.st", "Accessibility", "Announce position", "")
	Select
		Case $download_dir = ""
			$download_dir = "C:\MCY\Download"
	EndSelect
	$okmessaje = "OK"
	$menuPos = translate($lng, "OF")
	$menuString = translate($lng, "Select audio quality.") & "|" & _
		translate($lng, "Change download folder, Currently") & " " & $download_dir & "|" & _
		translate($lng, "Change language, Currently") & " " & $sLanguage & "|" & _
		translate($lng, "Enable or disable enhanced accessibility.") & "|" & _
		translate($lng, "Select screen reader") & "|" & _
		translate($lng, "Re-organize audios and videos now") & "|" & _
		translate($lng, "Save log file") & "|" & _
		translate($lng, "Always check for program and component updates (recommended)") & "|" & _
		translate($lng, "Enable / disable:") & " " & translate($lng, "Read download progress bars") & "|" & _
		translate($lng, "Enable / disable:") & " " & translate($lng, "Read remaining time of download") & "|" & _
		translate($lng, "Enable / disable:") & " " & translate($lng, "Beep for progress bars") & "|" & _
		translate($lng, "Enable / disable:") & " " & translate($lng, "Down the multimedia volume while the screen reader is speaking") & "|" & _
		translate($lng, "Enable / disable:") & " " & translate($lng, "Announce position of items in menus and in lists") & "|" & _
		translate($lng, "Show tips") & "|" & _
		translate($lng, "Select quantity of search results") & "|" & _
		translate($lng, "Clear settings") & "|" & _
		translate($lng, "Close this menu.")
	$p_options = reader_Create_Menu(translate($lng, "Options menu. Use up and down arrows to go to them, and enter to execute an action."), $menuString, $Rpositioning, $menuPos)
	Select
		Case $p_options = 1
			$Bitrate = reader_Create_Menu(translate($lng, "please select:"), "128 kbps|160 kbps|192 kbps|224 kbps|256 kbps|320 kbps,|84 kbps(experimental", $Rpositioning, $menuPos)
			Select
				Case $Bitrate = 1
					IniWrite("config\config.st", "General settings", "Audio Quality", "128k")
				Case $Bitrate = 2
					IniWrite("config\config.st", "General settings", "Audio Quality", "160k")
				Case $Bitrate = 3
					IniWrite("config\config.st", "General settings", "Audio Quality", "192k")
				Case $Bitrate = 4
					IniWrite("config\config.st", "General settings", "Audio Quality", "224k")
				Case $Bitrate = 5
					IniWrite("config\config.st", "General settings", "Audio Quality", "256k")
				Case $Bitrate = 6
					IniWrite("config\config.st", "General settings", "Audio Quality", "320k")
				Case $Bitrate = 7
					IniWrite("config\config.st", "General settings", "Audio Quality", "384k")
			EndSelect
		Case $p_options = 2
			Local $d_path = FileSelectFolder(translate($lng, "Select destination folder:"), $download_dir)
			speaking($d_path)
			IniWrite("config\config.st", "General settings", "Destination folder", $d_path)
		Case $p_options = 3
			$configureaccs = IniRead("config\config.st", "accessibility", "Enable enanced accessibility", "")
			$menu_lang = reader_Create_Menu("Please select your language", "Spanish|English|Back", $Rpositioning, $menuPos)
			Select
				Case $menu_lang = 1
					IniDelete("config\config.st", "General settings", "language")
					Sleep(50)
					IniWrite("config\config.st", "General settings", "language", "es")
				Case $menu_lang = 2
					IniDelete("config\config.st", "General settings", "language")
					Sleep(50)
					IniWrite("config\config.st", "General settings", "language", "eng")
					;case $menu_lang = 3
					;$s_selected = $device.opensound ("sounds/selected.ogg", 0)
					;$s_selected.play
					;speaking($okmessaje)
			EndSelect
			MsgBox(48, translate($lng, "Information"), translate($lng, "Please restart MCY Downloader for the changes to take effect."))
		Case $p_options = 4
			$en_a = reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") & "|" & translate($lng, "no"), $Rpositioning, $menuPos)
			Select
				Case $en_a = 1
					IniWrite("config\config.st", "accessibility", "Enable enanced accessibility", "Yes")
				Case $en_a = 2
					IniWrite("config\config.st", "accessibility", "Enable enanced accessibility", "No")
			EndSelect
		Case $p_options = 5
			$SpeakWh = Reader_Create_Menu(translate($lng, "What screen reader do you want to use?"), "NVDA|JAWS|sapi5", $Rpositioning, $menuPos)
			Select
				Case $SpeakWh = 1
					IniWrite("config\config.st", "accessibility", "Speak Whit", "NVDA")
				Case $SpeakWh = 2
					IniWrite("config\config.st", "accessibility", "Speak Whit", "JAWS")
				Case $SpeakWh = 3
					IniWrite("config\config.st", "accessibility", "Speak Whit", "Sapi")
			EndSelect
		Case $p_options = 6
			reOrganizar()
		Case $p_options = 7
			$menu_log = reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") & "|" & translate($lng, "no"), $Rpositioning, $menuPos)
			Select
				Case $menu_log = 1
					IniWrite("config\config.st", "General settings", "Sabe Logs", "Yes")
				Case $menu_log = 2
					IniWrite("config\config.st", "General settings", "Sabe Logs", "No")
			EndSelect
		Case $p_options = 8
			$menu_update = reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") & "|" & translate($lng, "no"), $Rpositioning, $menuPos)
			Select
				Case $menu_update = 1
					IniWrite("config\config.st", "General settings", "Check updates", "Yes")
				Case $menu_update = 2
					IniWrite("config\config.st", "General settings", "Check updates", "No")
			EndSelect
		Case $p_options = 9
			$m_progress = reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") & "|" & translate($lng, "no"), $Rpositioning, $menuPos)
			Select
				Case $m_progress = 1
					IniWrite("config\config.st", "Accessibility", "Read download progress bar", "Yes")
				Case $m_progress = 2
					IniWrite("config\config.st", "Accessibility", "Read download progress bar", "No")
			EndSelect
		Case $p_options = 10
			$m_time = reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") & "|" & translate($lng, "no"), $Rpositioning, $menuPos)
			Select
				Case $m_time = 1
					IniWrite("config\config.st", "Accessibility", "Read download remaining time", "Yes")
				Case $m_time = 2
					IniWrite("config\config.st", "Accessibility", "Read download remaining time", "No")
			EndSelect
		Case $p_options = 11
			$PBeep = reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") & "|" & translate($lng, "no"), $Rpositioning, $menuPos)
			Select
				Case $PBeep = 1
					IniWrite("config\config.st", "Accessibility", "Beep for progress bars", "Yes")
				Case $PBeep = 2
					IniWrite("config\config.st", "Accessibility", "Beep for progress bars", "No")
			EndSelect
		Case $p_options = 12
			$audioDuck = reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") & "|" & translate($lng, "no"), $Rpositioning, $menuPos)
			Select
				Case $audioDuck = 1
					IniWrite("config\config.st", "Accessibility", "Audio ducking", "Yes")
				Case $audioDuck = 2
					IniWrite("config\config.st", "Accessibility", "Audio ducking", "No")
			EndSelect
		Case $p_options = 13
			$AnouncePositions = reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") & "|" & translate($lng, "no"), $Rpositioning, $menuPos)
			Select
				Case $AnouncePositions = 1
					IniWrite("config\config.st", "Accessibility", "Announce position", "1")
				Case $AnouncePositions = 2
					IniWrite("config\config.st", "Accessibility", "Announce position", "0")
			EndSelect
		Case $p_options = 14
			$showtips = reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") & "|" & translate($lng, "no"), $Rpositioning, $menuPos)
			Select
				Case $showtips = 1
					IniWrite("config\config.st", "misc", "Show tips", "1")
				Case $showtips = 2
					IniWrite("config\config.st", "misc", "Show tips", "0")
			EndSelect
		Case $p_options = 15
			$qsearch = reader_Create_Menu(translate($lng, "please select:"), "5|10|25|50|75|100|150|200|250|300", $Rpositioning, $menuPos)
			Select
				Case $qsearch = 1
					IniWrite("config\config.st", "search", "Number of results", "5")
				Case $qsearch = 2
					IniWrite("config\config.st", "search", "Number of results", "10")
				Case $qsearch = 3
					IniWrite("config\config.st", "search", "Number of results", "25")
				Case $qsearch = 4
					IniWrite("config\config.st", "search", "Number of results", "50")
				Case $qsearch = 5
					IniWrite("config\config.st", "search", "Number of results", "75")
				Case $qsearch = 6
					IniWrite("config\config.st", "search", "Number of results", "100")
				Case $qsearch = 7
					IniWrite("config\config.st", "search", "Number of results", "150")
				Case $qsearch = 8
					IniWrite("config\config.st", "search", "Number of results", "200")
				Case $qsearch = 9
					IniWrite("config\config.st", "search", "Number of results", "250")
				Case $qsearch = 10
					IniWrite("config\config.st", "search", "Number of results", "300")
			EndSelect
		Case $p_options = 16
			$confirmarborrado = reader_Create_Menu(translate($lng, "Are you sure?"), translate($lng, "yes") & "|" & translate($lng, "no"), $Rpositioning, $menuPos)
			Select
				Case $confirmarborrado = "1"
					DirRemove(@ScriptDir & "\config", 1)
					MsgBox(48, translate($lng, "Information"), translate($lng, "Please restart MCY Downloader for the changes to take effect."))
					Exitpersonaliced()
				Case $confirmarborrado = "2"
					menu_options()
			EndSelect
		Case $p_options = 17
			$s_selected = $device.opensound("sounds/selected.ogg", 0)
			$s_selected.play
			speaking($okmessaje)
	EndSelect
EndFunc   ;==>menu_options
; #FUNCTION# ====================================================================================================================
; Name ..........: Menu_Options2
; Description ...: program options in GUI
; Syntax ........: Menu_Options2()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Menu_Options2()
	$sLanguage = IniRead("config\config.st", "General settings", "language", "")
	$download_dir = IniRead("config\config.st", "General settings", "Destination folder", "")
	Select
		Case $download_dir = ""
			$download_dir = "C:\MCY\Download"
	EndSelect
	Dim $aArray[0]
	Dim $bArray[0]
	$okmessaje = "OK"
	$guioptions = GUICreate(translate($lng, "Options menu"))
	$iRadio_Count = 7
	GUICtrlCreateGroup(translate($lng, "Select audio quality."), 20, 10, 100, 60)
	Local $idBtr1 = GUICtrlCreateRadio("128KBPS", 30, 30, 120, 30)
	Local $idBtr2 = GUICtrlCreateRadio("160KBPS", 30, 50, 120, 30)
	Local $idBtr3 = GUICtrlCreateRadio("192KBPS", 30, 70, 120, 30)
	Local $idBtr4 = GUICtrlCreateRadio("224KBPS", 30, 90, 120, 30)
	Local $idBtr5 = GUICtrlCreateRadio("256KBPS", 30, 130, 120, 30)
	Local $idBtr6 = GUICtrlCreateRadio("320KBPS", 30, 150, 120, 30)
	Local $idBtr7 = GUICtrlCreateRadio("384KBPS", 30, 170, 120, 30)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetState($idBtr7, $GUI_CHECKED)
	Local $BTNChooseF = GUICtrlCreateButton(translate($lng, "Change download folder, Currently") & " " & $download_dir, 50, 200, 120, 25)
	$lang_Label = GUICtrlCreateLabel(translate($lng, "Change language, Currently") & " " & $sLanguage, 60, 200, 120, 25)
	$idComboBox = GUICtrlCreateCombo("Spanish", 60, 200, 150, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($idComboBox, "English", "Spanish")
	$accs_Label = GUICtrlCreateLabel(translate($lng, "Enable or disable enhanced accessibility."), 90, 200, 120, 25)
	$idComboBox2 = GUICtrlCreateCombo("Yes", 60, 260, 150, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($idComboBox2, "No")
	$search_Label = GUICtrlCreateLabel(translate($lng, "Select quantity of search results"), 115, 200, 120, 25)
	$idQsearch = GUICtrlCreateCombo("5", 60, 280, 150, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($idQsearch, "10|25|50|75|100|150|200|250|300")
	Local $BTN_ReOrder = GUICtrlCreateButton(translate($lng, "Re-organize audios and videos now"), 120, 200, 180, 25)
	Local $idSabeLogs = GUICtrlCreateCheckbox(translate($lng, "Save log file"), 150, 200, 185, 25)
	Local $idCheckupds = GUICtrlCreateCheckbox(translate($lng, "Always check for program and component updates (recommended)"), 250, 200, 185, 25)
	Local $idShowtips = GUICtrlCreateCheckbox(translate($lng, "Show tips"), 285, 200, 185, 25)
	Local $idBTN_Clean = GUICtrlCreateButton(translate($lng, "Clear settings"), 325, 200, 185, 25)
	Local $idBTN_Close = GUICtrlCreateButton(translate($lng, "Close this menu."), 400, 200, 185, 25)
	GUISetState(@SW_SHOW)
	Local $idMsg
	Local $sComboRead = ""
	While 1
		$idMsg = GUIGetMsg()
		Select
			Case $idMsg = $GUI_EVENT_CLOSE
				GUIDelete($guioptions)
				ExitLoop
			Case $idMsg = $idBtr1 And BitAND(GUICtrlRead($idBtr1), $GUI_CHECKED) = $GUI_CHECKED
				IniWrite("config\config.st", "General settings", "Audio Quality", "128k")
			Case $idMsg = $idBtr2 And BitAND(GUICtrlRead($idBtr2), $GUI_CHECKED) = $GUI_CHECKED
				IniWrite("config\config.st", "General settings", "Audio Quality", "160k")
			Case $idMsg = $idBtr3 And BitAND(GUICtrlRead($idBtr3), $GUI_CHECKED) = $GUI_CHECKED
				IniWrite("config\config.st", "General settings", "Audio Quality", "192k")
			Case $idMsg = $idBtr4 And BitAND(GUICtrlRead($idBtr4), $GUI_CHECKED) = $GUI_CHECKED
				IniWrite("config\config.st", "General settings", "Audio Quality", "224k")
			Case $idMsg = $idBtr5 And BitAND(GUICtrlRead($idBtr5), $GUI_CHECKED) = $GUI_CHECKED
				IniWrite("config\config.st", "General settings", "Audio Quality", "256k")
			Case $idMsg = $idBtr6 And BitAND(GUICtrlRead($idBtr6), $GUI_CHECKED) = $GUI_CHECKED
				IniWrite("config\config.st", "General settings", "Audio Quality", "320k")
			Case $idMsg = $idBtr7 And BitAND(GUICtrlRead($idBtr7), $GUI_CHECKED) = $GUI_CHECKED
				IniWrite("config\config.st", "General settings", "Audio Quality", "384k")
			Case $idMsg = $BTNChooseF
				Local $d_path = FileSelectFolder(translate($lng, "Select destination folder:"), $download_dir)
				IniWrite("config\config.st", "General settings", "Destination folder", $d_path)
			Case $idMsg = $idComboBox
				$sComboRead = GUICtrlRead($idComboBox)
				Select
					Case $sComboRead = "Spanish"
						IniDelete("config\config.st", "General settings", "language")
						Sleep(50)
						IniWrite("config\config.st", "General settings", "language", "es")
					Case $sComboRead = "English"
						IniDelete("config\config.st", "General settings", "language")
						Sleep(50)
						IniWrite("config\config.st", "General settings", "language", "eng")
				EndSelect
				MsgBox(48, translate($lng, "Information"), translate($lng, "Please restart MCY Downloader for the changes to take effect."))
			Case $idMsg = $idComboBox2
				$sComboRead = GUICtrlRead($idComboBox2)
				IniWrite("config\config.st", "accessibility", "Enable enanced accessibility", $sComboRead)
				MsgBox(48, translate($lng, "Information"), translate($lng, "Please restart MCY Downloader for the changes to take effect."))
			Case $idMsg = $idQsearch
				$sComboRead = GUICtrlRead($idQsearch)
				IniWrite("config\config.st", "Search", "Number of results", $sComboRead)
			Case $idMsg = $BTN_ReOrder
				reOrganizar()
			Case $idMsg = $idSabeLogs
				If _IsChecked($idSabeLogs) Then
					IniWrite("config\config.st", "General settings", "Sabe Logs", "Yes")
				Else
					IniWrite("config\config.st", "General settings", "Sabe Logs", "No")
				EndIf
			Case $idMsg = $idCheckupds
				If _IsChecked($idCheckupds) Then
					IniWrite("config\config.st", "General settings", "Check updates", "Yes")
				Else
					IniWrite("config\config.st", "General settings", "Check updates", "No")
				EndIf
			Case $idMsg = $idShowtips
				If _IsChecked($idShowtips) Then
					IniWrite("config\config.st", "misc", "Show tips", "1")
				Else
					IniWrite("config\config.st", "misc", "Show tips", "0")
				EndIf
			Case $idMsg = $idBTN_Clean
				$confirmarborrado = MsgBox(4, translate($lng, "Clear settings"), translate($lng, "Are you sure?"))
				Select
					Case $confirmarborrado = 6
						DirRemove(@ScriptDir & "\config", 1)
						MsgBox(48, translate($lng, "Information"), translate($lng, "Please restart MCY Downloader for the changes to take effect."))
						Exitpersonaliced()
				EndSelect
			Case $idMsg = $idBTN_Close
				GUIDelete($guioptions)
				ExitLoop
		EndSelect
	WEnd
EndFunc   ;==>Menu_Options2
