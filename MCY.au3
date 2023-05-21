#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=N
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Change2CUI=N
#AutoIt3Wrapper_Res_Description=Music YouTube Downloader
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
;#AutoIt3Wrapper_Res_Fileversion_First_Increment=y
#AutoIt3Wrapper_Res_ProductName=Music YouTube Downloader
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.0
#AutoIt3Wrapper_Res_CompanyName=MT Programs
#AutoIt3Wrapper_Res_LegalCopyright=© 2018-2022 MT Programs, All rights reserved
;#AutoIt3Wrapper_Res_Language=12298
;#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7 -v1 -v2 -v3
;#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;Begining off script.
; Defining the version number, and program info.
;AutoIt3Wrapper
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#Autoit3Wrapper_Testing=n
#AutoIt3Wrapper_ShowProgress=y
#AutoIt3Wrapper_ShowGui=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;pragma:
; #pragma compile(Icon, C:\Program Files\AutoIt3\Icons\au3.ico)
#pragma compile(UPX, False)
;#pragma compile(Compression, 2)
#pragma compile(inputboxres, false)
#pragma compile(FileDescription, Music YouTube Downloader)
#pragma compile(ProductName, Music YouTube Downloader)
#pragma compile(ProductVersion, 1.0.0.0)
#pragma compile(Fileversion, 1.0.0.19)
#pragma compile(InternalName, "mateocedillo.MCY")
#pragma compile(LegalCopyright, © 2018-2022 MT Programs, All rights reserved)
#pragma compile(CompanyName, 'MT Programs')
Global $programname = "MCY Downloader"
Global $arquitectura = "x64"
Global $program_ver = "1.0B1"
Global $ifitisupdate = IniRead(@ScriptDir & "\Config\config.st", "General settings", "Check updates", "")
If $ifitisupdate = "" Then
	IniWrite(@ScriptDir & "\Config\config.st", "General settings", "Check updates", "Yes")
	$ifitisupdate = "yes"
Else
EndIf
Global $lng = IniRead("config\config.st", "General settings", "language", "")
;Including program scripts:
;#include <Array.au3>;para un futuro
#include "Include\audio.au3"
#include "include\MCY\busqueda.au3"
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <fileConstants.au3>
#include "Include\MCY\functions.au3"
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <GuiComboBox.au3>
#include <InetConstants.au3> ;
;#include "Include\mergefiles_utf16le_v2.au3"
#include "Include\MCY\Mp3_converter.au3"
#include "Include\kbc.au3"
#include "Include\log.au3"
#include "Include\menu_nvda.au3"
#include <MsgBoxConstants.au3>
#include "Include\NVDAControllerClient.au3"
#include "Include\MCY\player.au3"
#include "include\progress.au3"
#include <ProgressConstants.au3>
#include "Include\MCY\radio.au3"
#include "Include\reader.au3"
#include "Include\sapi.au3"
#include "Include\say_UDF.au3"
;#include <String.au3>;for a future
#include "include\translator.au3"
#include <TrayConstants.au3>
#include "include\MCY\UI.au3"
#include "updater.au3"
#include <WindowsConstants.au3>
;New command line options! Incredible as it may seem, it is.
If _StringInArray($cmdline, '/radio') Then
	radio()
	exitpersonaliced()
ElseIf _StringInArray($cmdline, '/help') Then
	MsgBox(0, "command line instructions", "/radio: open MCY Radio" & @CRLF & "/help: query this help.")
	exitpersonaliced()
EndIf
;Creates a window wenn the program is loading:
$l1 = GUICreate(translate($lng, "Loading..."))
GUISetState(@SW_SHOW)
writeinlog("Initialicing...")
If @OSArch = "x64" Then
	Global $sYouTube_DL = IniRead("config\config.st", 'General Settings', 'Youtube-DL', 'engines64\yt-dlp.exe')
ElseIf @OSArch = "x86" Then
	Global $sYouTube_DL = IniRead("config\config.st", 'General Settings', 'Youtube-DL', 'engines\yt-dlp_x86.exe')
EndIf
comprovarArc()
; #FUNCTION# ====================================================================================================================
; Name ..........: comprovarArc
; Description ...: check architecture
; Syntax ........: comprovarArc()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func comprovarArc()
	$developermode = "1"
	If Not FileExists("config") Then
		$configfolder = DirCreate("config")
		If $configfolder = "0" Then
			MsgBox(16, Translate($lng, "Error"), Translate($lng, "Config folder could not be created. If so, please run the program as administrator."))
			exitpersonaliced()
		EndIf
	EndIf
	writeinlog("Checking architecture")
	GUIDelete($l1)
	If @OSArch = "x64" And $arquitectura = "x64" Then
		writeinlog("Windows 64 bit")
	EndIf
	If @OSArch = "x86" And $arquitectura = "x86" Then
		writeinlog("Windows 32 bit")
	EndIf
	If @OSArch = "x64" And $arquitectura = "x86" Then
		MsgBox(48, Translate($lng, "Warning"), Translate($lng, "You run a 64-bit pc with the 32-bit version of the program. For better performance in the program, we recommend that you download the 64-bit version at http://mateocedillo.260mb.net/programs.html"))
		exitpersonaliced()
	EndIf
	If @OSArch = "x86" And $arquitectura = "x64" Then
		MsgBox(48, Translate($lng, "Warning"), Translate($lng, "You run a 32-bit pc with the 64-bit version of the program. For better performance in the program, we recommend that you download the 32-bit version at http://mateocedillo.260mb.net/programs.html"))
		exitpersonaliced()
	EndIf
	Select
		Case $developermode = 1
			writeinlog("Checking program copy...")
			checkcopy()
		Case $developermode = 0
			writeinlog("The program is not compiled. Exiting...")
			NotCompiled()
	EndSelect
EndFunc   ;==>comprovarArc
; #FUNCTION# ====================================================================================================================
; Name ..........: checkcopy
; Description ...: To find out where the copy is running from
; Syntax ........: checkcopy()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func checkcopy()
	If @ScriptDir = "C:\MCY" Then
		IniWrite("config\config.st", "General settings", "Program Type", "Installable")
		writeinlog("Copy: Installable.")
	Else
		IniWrite("config\config.st", "General settings", "Program Type", "Portable")
		writeinlog("Copy: Portable.")
	EndIf
	firstlaunch()
EndFunc   ;==>checkcopy
; #FUNCTION# ====================================================================================================================
; Name ..........: firstlaunch
; Description ...: First launch
; Syntax ........: firstlaunch()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func firstlaunch()
	Global $accessibility = IniRead("config\config.st", "accessibility", "Enable enanced accessibility", "")
	Select
		Case $accessibility = ""
			configure()
		Case Else
			checkselector()
	EndSelect
EndFunc   ;==>firstlaunch
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
	writeinlog("exiting...")
	Global $soundclose = $device.opensound("sounds/close.ogg", 0)
	$soundclose.play
	Sleep(500)
	FileDelete(@TempDir & "\MCYWeb.dat")
	FileDelete(@ScriptDir & "\tmp_motd_es.ogg")
	Exit
EndFunc   ;==>exitpersonaliced
; The next question is to activate the enhanced accessibility, made exclusively and only for people with disabilities.
; #FUNCTION# ====================================================================================================================
; Name ..........: configure
; Description ...: Enhable enhanced accessibility
; Syntax ........: configure()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func configure()
	writeinlog("Launching at first time.")
	$Warning = MsgBox(4, translate($lng, "Enable enhanced accessibility?"), translate($lng, "This new Enhanced Accessibility functionality is designed for the visually impaired, in which most of the program interface can be used by voice and keyboard shortcuts. Activate?"))
	If $Warning = 6 Then
		IniWrite("config\config.st", "accessibility", "Enable enanced accessibility", "Yes")
		writeinlog("Enanced accesibility: Yes.")
	Else
		IniWrite("config\config.st", "accessibility", "Enable enanced accessibility", "No")
		writeinlog("Enanced accesibility: No.")
	EndIf
	Global $accessibility = IniRead("config\config.st", "accessibility", "Enable enanced accessibility", "")
	checkselector()
EndFunc   ;==>configure
; #FUNCTION# ====================================================================================================================
; Name ..........: checkselector
; Description ...: Check language
; Syntax ........: checkselector()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func checkselector()
	Global $lng = IniRead("config\config.st", "General settings", "language", "")
	Select
		Case $lng = ""
			Selector()
		Case Else
			checkupd()
	EndSelect
EndFunc   ;==>checkselector
;This is the function off language selector menu, the first alternative using the main menu speech.
; #FUNCTION# ====================================================================================================================
; Name ..........: Selector
; Description ...: Language selector, new version! yay!
; Syntax ........: Selector()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Selector()
	Opt("GUIOnEventMode", 1)
	Local $widthCell, $msg, $iOldOpt
	Global $langGUI = GUICreate("Language Selection")
	Global $seleccionado = "0"
	$widthCell = 70
	$iOldOpt = Opt("GUICoordMode", $iOldOpt)
	$beep = "0"
	$busqueda = "0"
	Dim $langcodes[50]
	GUICtrlCreateLabel("Select language:", -1, 0)
	GUISetBkColor(0x00E0FFFF)
	$recolectalosidiomasporfavor = FileFindFirstFile(@ScriptDir & "\lng\*.lang")
	If $recolectalosidiomasporfavor = -1 Then MsgBox(16, "Fatal error", "We cannot find the language files. Please download the program again...")
	Local $Recoleccion = "", $obteniendo = ""
	While 1
		$beep = $beep + 1
		$busqueda = $busqueda + 1
		$Recoleccion = FileFindNextFile($recolectalosidiomasporfavor)
		If @error Then
			;MsgBox(16, "Error", "We cannot find the language files or they are corrupted.")
			CreateAudioProgress("100")
			ExitLoop
		EndIf
		$splitCode = StringLeft($Recoleccion, 2)
		$obteniendo &= GetLanguageName($splitCode) & ", " & GetLanguageCode($splitCode) & "|"
		$langcodes[$busqueda] = GetLanguageCode($splitCode)
		CreateAudioProgress($beep)
		Sleep(100)
	WEnd
	GUISetState(@SW_SHOW)
	$langcount = StringSplit($obteniendo, "|")
	$fix_audiomenu = StringTrimRight($obteniendo, 1)
	$configureaccs = IniRead("config\config.st", "accessibility", "Enable enanced accessibility", "")
	If $configureaccs = "yes" Then
		$menu = Reader_create_menu("Please select a language with the up and down arrows and press enter to continue", $fix_audiomenu)
	EndIf
	If $configureaccs = "no" Then
		Global $Choose = GUICtrlCreateCombo("", 100, 50, 200, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetOnEvent(-1, "seleccionar")
		GUICtrlSetData($Choose, $obteniendo)
		Global $idBtn_OK = GUICtrlCreateButton("OK", 155, 50, 70, 30)
		GUICtrlSetOnEvent(-1, "save")
		Global $idBtn_Close = GUICtrlCreateButton("Close", 180, 50, 70, 30)
		GUICtrlSetOnEvent(-1, "exitpersonaliced")
		Global $LEER = ""
		While 1
			If $seleccionado = "1" Then
				Opt("GUIOnEventMode", 0)
				;msgbox(0, "Correct", "We should close this.")
				ExitLoop
			EndIf
		WEnd
		GUIDelete($langGUI)
		checkupd()
	EndIf
	If $configureaccs = "yes" Then
		IniWrite("config\config.st", "General settings", "language", $langcodes[$menu])
		If @error Then
			MsgBox(0, "Error", "Configuration data could not be written.")
			exitpersonaliced()
		EndIf
		GUIDelete($langGUI)
		checkupd()
	EndIf
	Opt("GUIOnEventMode", 0)
EndFunc   ;==>Selector
; #FUNCTION# ====================================================================================================================
; Name ..........: seleccionar
; Description ...: Select language
; Syntax ........: seleccionar()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func seleccionar()
	Global $LEER = GUICtrlRead($Choose)
	Global $queidiomaes = StringSplit($LEER, ",")
	;speaking("Has seleccionado " &StringStripWS($queidiomaes[2], $STR_STRIPLEADING))
EndFunc   ;==>seleccionar
; #FUNCTION# ====================================================================================================================
; Name ..........: save
; Description ...: Save language settings
; Syntax ........: save()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func save()
	IniWrite("config\config.st", "General settings", "language", StringStripWS($queidiomaes[2], $STR_STRIPLEADING))
	$seleccionado = "1"
EndFunc   ;==>save
; #FUNCTION# ====================================================================================================================
; Name ..........: checkupd
; Description ...: Function to check for updates
; Syntax ........: checkupd()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func checkupd()
	Global $main_u = GUICreate(translate($lng, "Checking version..."))
	$mlb = GUICtrlCreateLabel(translate($lng, "Please wait."), 0, 10, 100, 20)
	GUISetState(@SW_SHOW)
	ToolTip(translate($lng, "checking version..."))
	If $ifitisupdate = "Yes" Then
		checKmcyversion()
		GUIDelete($main_u)
	Else
		writeinlog("the user does not want updates")
		GUIDelete($main_u)
		Principal()
	EndIf
	Sleep(250)
	GUIDelete($main_u)
EndFunc   ;==>checkupd
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
	$ReadAccs = IniRead("config\config.st", "Accessibility", "Enable enanced accessibility", "")
	writeinlog("Checking for updates...")
	Local $yourexeversion = $program_ver
	$fileinfo = InetGet("https://www.dropbox.com/s/hcx20lgvjem0wz1/MCYWeb.dat?dl=1", @TempDir & "\MCYWeb.dat")
	$latestver = IniRead(@TempDir & "\MCYWeb.dat", "updater", "LatestVersion", "")
	If $ReadAccs = "Yes" Then
		Select
			Case $latestver <> $yourexeversion
				writeinlog("Warning! Update available. Your version:" & $yourexeversion & ". New version:" & $latestver)
				CreateTTSDialog(translate($lng, "Update available!"), translate($lng, "You have the version") & " " & $yourexeversion & " " & translate($lng, "and is available the") & " " & $latestver, translate($lng, " press enter to continue, space to repeat information."))
				GUIDelete($main_u)
				If $arquitectura = "x64" Then
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
				writeinlog(translate($lng, "You have the version") & " " & $program_ver & " " & translate($lng, "and is available the") & " " & $latestver)
				MsgBox(0, translate($lng, "Update available!"), translate($lng, "You have the version") & " " & $program_ver & " " & translate($lng, "and is available the") & " " & $latestver)
				If $arquitectura = "x64" Then
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
; Name ..........: checkmotd
; Description ...: Check MOTD
; Syntax ........: checkmotd()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func checkmotd()
	;Function to check messaje of the day.
	$LMotd = IniRead("config\config.st", "misc", "motdversion", "")
	$LatestMotd = IniRead(@TempDir & "\MCYWeb.dat", "motd", "Latest", "")
	writeinlog("Website motd: " & $LatestMotd)
	writeinlog("actual motd: " & $LMotd)
	Select
		Case $LatestMotd > $LMotd
			Global $downloading = $device.opensound("sounds/update_downloading.ogg", 0)
			$downloading.play
			motdprincipal()
		Case $LatestMotd = $LMotd
			Principal()
	EndSelect
EndFunc   ;==>checkmotd
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
Func motdprincipal()
	$LatestMotd = IniRead(@TempDir & "\MCYWeb.dat", "motd", "Latest", "")
	Global $sound = $device.opensound("sounds/selected.ogg", 0)
	$bagground = $device.opensound("sounds/update.ogg", 0)
	$downloadingmotd = GUICreate(translate($lng, "Downloading message of the day..."))
	GUICtrlCreateLabel(translate($lng, "Please wait."), 85, 20)
	GUISetState(@SW_SHOW)
	$bagground.play
	$bagground.repeating = 1
	Sleep(10)
	$ReadAccs = IniRead("config\config.st", "accessibility", "Enable enanced accessibility", "")
	$M_mode = IniRead(@TempDir & "\MCYWeb.dat", "motd", "Mode", "")
	$ok = IniWrite("config\config.st", "misc", "motdversion", $LatestMotd)
	writeinlog("Downloading MOTD.")
	Select
		Case $lng = "es"
			Select
				Case $M_mode = "audio"
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
					$M_text = IniRead(@TempDir & "\MCYWeb.dat", "motd", "Text1", "")
					$sound.play
					If $ReadAccs = "Yes" Then
						CreateTTSDialog("MOTD", $M_text)
					Else
						MsgBox(0, translate($lng, "Message of the day"), $M_text)
					EndIf
			EndSelect
		Case $lng = "eng"
			Select
				Case $M_mode = "text"
					If $bagground.playing = "1" Then $bagground.stop
					$M_text = IniRead(@TempDir & "\MCYWeb.dat", "motd", "Text2", "")
					$sound.play
					If $ReadAccs = "Yes" Then
						CreateTTSDialog(translate($lng, "Message Of The Day"), $M_text)
					Else
						MsgBox(0, translate($lng, "Message Of The Day"), $M_text)
					EndIf
			EndSelect
	EndSelect
	GUIDelete($downloadingmotd)
EndFunc   ;==>motdprincipal
; #FUNCTION# ====================================================================================================================
; Name ..........: Principal
; Description ...: this is... the main core of the program.
; Syntax ........: Principal()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Principal()
	If @Compiled Then FileDelete(@TempDir & "\MCYWeb.dat")
	Opt("GUIOnEventMode", 0)
	ToolTip("")
	$lng = IniRead("config\config.st", "General settings", "language", "")
	;Create "Temp" folder.
	If Not FileExists("C:\MCY\tmp") Then DirCreate("C:\MCY\tmp")
	;Show the window.
	AutoItWinSetTitle($programname & " by Mateo C")
	;Play welcome sound.
	$welcome = $device.opensound("sounds/open.ogg", 0)
	$welcome.play
	Sleep(500)
	;Set the service.
	$service = "www.youtube.com"
	;Check multimedia folders.
	writeinlog("Checking multimedia folders:")
	Global $d_folder = IniRead("config\config.st", "General settings", "Destination folder", "")
	Select
		Case $d_folder = ""
			$d_folder = "C:\MCY\Download"
			IniWrite("config\config.st", "General settings", "Destination folder", $d_folder)
	EndSelect
	Menuprogram()
EndFunc   ;==>Principal
; #FUNCTION# ====================================================================================================================
; Name ..........: multimediafolders
; Description ...: Create multimedia folders.
; Syntax ........: multimediafolders()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func multimediafolders()
	If Not FileExists($d_folder & "\audio") Then DirCreate($d_folder & "\audio")
	If Not FileExists($d_folder & "\video") Then DirCreate($d_folder & "\video")
EndFunc   ;==>multimediafolders
; #FUNCTION# ====================================================================================================================
; Name ..........: Readchanges
; Description ...: Read changes document
; Syntax ........: Readchanges()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Readchanges()
	$viewchanges = GUICreate(translate($lng, "Changes:"))
	GUISetState(@SW_SHOW)
	Sleep(50)
	createTtsDocument(@ScriptDir & "\Documentation\" & $lng & "\changes.txt", "changes")
	GUIDelete($viewchanges)
EndFunc   ;==>Readchanges
; #FUNCTION# ====================================================================================================================
; Name ..........: ReadChanges2
; Description ...: Read changes #2
; Syntax ........: ReadChanges2()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func ReadChanges2()
	Opt("GUIOnEventMode", 0)
	Global $openned
	$doc = "documentation\" & $lng & "\changes.txt"
	Global $DocOpen = FileOpen($doc, $FO_READ)
	ToolTip(translate($lng, "Opening..."))
	speaking(translate($lng, "Opening..."))
	Sleep(50)
	If $DocOpen = "-1" Then MsgBox($MB_SYSTEMMODAL, translate($lng, "error"), translate($lng, "An error occurred when reading the file."))
	$openned = FileRead($DocOpen)
	ToolTip("")
	$mwindow = GUICreate(translate($lng, "Changes"))
	$idMyedit = GUICtrlCreateEdit($openned, 5, 5, 390, 360, BitOR($WS_VSCROLL, $WS_HSCROLL, $ES_READONLY))
	$idExitDoc = GUICtrlCreateButton(translate($lng, "Close"), 100, 370, 150, 30)
	GUISetState(@SW_SHOW)
	; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $idExitDoc
				FileClose($DocOpen)
				ExitLoop
		EndSwitch
	WEnd
	GUIDelete()
EndFunc   ;==>ReadChanges2
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
; #FUNCTION# ====================================================================================================================
; Name ..........: Imputdownload
; Description ...: the main function of the program
; Syntax ........: Imputdownload()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Imputdownload()
	$dmain = GUICreate(translate($lng, "MCY Downloader: Download multimedia"), 500, 500)
	$ReadAccs = IniRead("config\config.st", "Accessibility", "Enable enanced accessibility", "")
	$showtip = IniRead("config\config.st", "misc", "Show tips", "")
	$sayProgresses = IniRead("config\config.st", "Accessibility", "Read download progress bar", "")
	$sayTime = IniRead("config\config.st", "Accessibility", "Read download remaining time", "")
	$BeepProgresses = IniRead("config\config.st", "Accessibility", "Beep for progress bars", "")
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
	If @OSArch = "x64" Then
		Global $MAIN = " engines64\yt-dlp "
		Global $ffmpeg = " engines64\ffmpeg.exe"
		Global $MSVCR100_PATH = "engines64\msvcr100.dll"
		Global $CMD_VIDEO = 'engines64\yt-dlp.exe -o "'
	EndIf
	If @OSArch = "x86" Then
		Global $MAIN = " engines\yt-dlp_x86 "
		Global $ffmpeg = " engines\ffmpeg.exe"
		Global $MSVCR100_PATH = "engines\msvcr100.dll"
		Global $CMD_VIDEO = 'engines\yt-dlp.exe -o "'
	EndIf
	Global $EN_INTERRUPT_MESSAGE = "~ interrupt!"
	Global $EN_MISSING_URL_MESSAGE = "Missing URL!"
	Global $EXTRACT_AUDIO = " --extract-audio "
	Global $AUDIO_FORMAT = " --audio-format "
	Global $audioQual = IniRead("config\config.st", "accessibility", "Audio Quality", "")
	If $audioQual = "128k" Or $audioQual = "160k" Or $audioQual = "192k" Or $audioQual = "224k" Or $audioQual = "256k" Or $audioQual = "320k" Or $audioQual = "384k" Then
		Global $audioQuality = " --audio-quality " & $audioQual & " "
	Else
		Global $audioQuality = " --audio-quality 320k "
	EndIf
	Global $OUTPUT = " --output "
	Global $OUTPUT_TEMPLATE = "%%(title)s.%%(ext)s"
	Global $YES_PLAYLIST = " --yes-playlist "
	Global $NO_PLAYLIST = " --no-playlist "
	Global $PLAYLIST_START = " --playlist-start "
	Global $PLAYLIST_END = " --playlist-end "
	Global $PLAYLIST_Ignore_errors = ""
	Global $WRITE_SUB = " --write-sub "
	Global $WRITE_AUTO_SUB = " --write-auto-sub "
	Global $SUB_FORMAT = " --sub-format "
	Global $SUB_LANG = " --sub-lang "
	Global $SKIP_VIDEO = " --skip-download "
	Global $NOP_MILLIS = 10000
	Global $EMPTY_STRING = ""
	Global $SPACE = " "
	Global $DOWNLOAD_TAG = "[download]"
	Global $iPID = -1
	Local $count = 0
	$idLabel1 = GUICtrlCreateLabel(translate($lng, "Enter a &URL, Insert here the link, playlist or channel of the video to download:"), 10, 10, 200, 20)
	Local $sData = ClipGet()
	$input_url = GUICtrlCreateInput($sData, 18, 30, 497, 20)
	$chkbox_isSingle = GUICtrlCreateCheckbox(translate($lng, "Download only &video"), 8, 80, 145, 17)
	If $showtip = "1" Then GUICtrlSetTip(-1, translate($lng, "Check only this checkbox to download the original video, in case of YouTube."))
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkbox_isMP3 = GUICtrlCreateCheckbox(translate($lng, "Download as &audio"), 8, 104, 145, 17)
	If $showtip = "1" Then GUICtrlSetTip(-1, translate($lng, "Check this checkbox to convert this downloaded video to an audio format like mp3."))
	$chkbox_sub = GUICtrlCreateCheckbox(translate($lng, "Download &subtittles"), 8, 190, 145, 17)
	If $showtip = "1" Then GUICtrlSetTip(-1, translate($lng, "You can download subtitles, if the video supports them."))
	$idFolder = GUICtrlCreateLabel(Translate($lng, "Destination folder"), 8, 240, 150, 17)
	$input_dir = GUICtrlCreateInput($d_folder, 8, 250, 190, 17)
	$btn_dir = GUICtrlCreateButton(translate($lng, "Choose &Folder"), 8, 270, 190, 17)
	If $showtip = "1" Then GUICtrlSetTip(-1, translate($lng, "The download folder where your files will be saved."))
	$btn_generate = GUICtrlCreateButton(translate($lng, "&Download"), 8, 280, 145, 17)
	If $showtip = "1" Then GUICtrlSetTip(-1, translate($lng, "Starts download of the selected link"))
	$btn_share = GUICtrlCreateButton(translate($lng, "&Share link"), 8, 320, 145, 17)
	If $showtip = "1" Then GUICtrlSetTip(-1, translate($lng, "Share URLs through social networks."))
	$btn_prev = GUICtrlCreateButton(translate($lng, "&Preview"), 8, 380, 145, 17)
	If $showtip = "1" Then GUICtrlSetTip(-1, translate($lng, "Plays a preview of the selected link."))
	$idLabel1 = GUICtrlCreateLabel(translate($lng, "Download video from:"), 100, 100, 200, 21)
	$input_start = GUICtrlCreateInput("", 160, 80, 41, 21)
	GUICtrlSetState(-1, $GUI_HIDE)
	$idLabel1 = GUICtrlCreateLabel(translate($lng, "Download to:"), 130, 115, 200, 21)
	$input_end = GUICtrlCreateInput("", 224, 80, 41, 21)
	GUICtrlSetState(-1, $GUI_HIDE)
	$Label1 = GUICtrlCreateLabel(translate($lng, "Select subtitle download method:"), 208, 83, 16, 17)
	GUICtrlSetState(-1, $GUI_HIDE)
	$combo_sublist = GUICtrlCreateCombo("Auto sub", 160, 152, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetState(-1, $GUI_HIDE)
	$chkbox_onlysub = GUICtrlCreateCheckbox(translate($lng, "Only down sub"), 312, 152, 97, 17)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUISetState(@SW_SHOW)
	Global $isSingle = False
	Global $url
	Global $dir
	Global $sublang
	Local $DOWNLOADLINE = $EMPTY_STRING
	While 1
		$url = GUICtrlRead($input_url)
		$sublang = GUICtrlRead($combo_sublist)
		;check if the input url is a playlist url
		If Not (StringInStr($url, "list")) And GUICtrlRead($chkbox_isSingle) == $GUI_UNCHECKED Then
			GUICtrlSetState($chkbox_isSingle, $GUI_CHECKED)
			Select
				Case $ReadAccs = "yes"
					speaking(translate($lng, "The link was marked as a playlist."))
				Case $ReadAccs = "no"
					ToolTip(translate($lng, "The link was marked as a playlist."))
					ToolTip("")
			EndSelect
		EndIf
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Menuprogram()
			Case $btn_dir
				Local $path = FileSelectFolder(translate($lng, "Choose Folder..."), $input_dir)
				GUICtrlSetData($input_dir, $path)
				writeinlog("Folder selected: " & $path)
				$d_folder = $path
				IniWrite("config\config.st", "General settings", "Destination folder", $d_folder)
				multimediafolders()
			Case $btn_generate
				$sound_downloading = $device.opensound("sounds/update_downloading.ogg", 0)
				$sound_downloading.play
				MsgBox(0, translate($lng, "Downloading"), translate($lng, "Wait a moment, we're looking for the video. Press OK to start."))
				$say = "0"
				writeinlog("Downloading Multimedia.")
				Local $command = $MAIN
				Local $isSingle = GUICtrlRead($chkbox_isSingle) == $GUI_CHECKED
				Local $start = Number(GUICtrlRead($input_start))
				Local $end = Number(GUICtrlRead($input_end))
				Local $isMP3 = GUICtrlRead($chkbox_isMP3) == $GUI_CHECKED
				Local $isSub = GUICtrlRead($chkbox_sub) == $GUI_CHECKED
				Local $isOnlySub = GUICtrlRead($chkbox_onlysub) == $GUI_CHECKED
				Local $dir = GUICtrlRead($input_dir)
				;Local $isExec = GUICtrlRead($chkbox_exec) == $GUI_CHECKED
				$exitcmd = @CRLF & "exit"
				If $isMP3 Then
					writeinlog("Downloading as audio")
					$command &= $EXTRACT_AUDIO & $AUDIO_FORMAT & "mp3" & $audioQuality
				EndIf
				If $isSub Then
					If $sublang <> "Auto sub" Then
						writeinlog("Downloading subtitles ...")
						$command &= $WRITE_SUB & $SUB_LANG & $sublang
					Else
						writeinlog("Autosub")
						$command &= $WRITE_AUTO_SUB
					EndIf
					If $isOnlySub Then
						$command &= $SKIP_VIDEO
					EndIf
				EndIf
				If $isSingle Then
					$command &= $NO_PLAYLIST
				Else
					$command &= $YES_PLAYLIST & $PLAYLIST_Ignore_errors
					If $start <> 0 Then $command &= $PLAYLIST_START & $start
					If $end <> 0 Then $command &= $PLAYLIST_END & $end
				EndIf
				If $dir <> "" Then
					$command &= $OUTPUT & '"' & $dir & '\audio\' & $OUTPUT_TEMPLATE & '" '
				EndIf
				$command &= ' "' & GUICtrlRead($input_url) & '"'
				$command &= (@CRLF & $exitcmd)
				Local $file = FileOpen("generated.bat", $FO_OVERWRITE + $FO_CREATEPATH)
				FileWrite($file, $command)
				FileClose($file)
				GUISetState(@SW_HIDE, $dmain)
				Global $downloading = GUICreate(translate($lng, "Downloading"))
				$edit_out = GUICtrlCreateEdit($EMPTY_STRING, 8, 152, 325, 17, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY))
				Local $idProgressbar = GUICtrlCreateProgress(200, 50, 325, 17)
				GUICtrlSetColor(-1, 32250)
				GUISetState(@SW_SHOW)
				writeinlog("Starting process...")
				Local $iSavPos = 0
				Local $runcmd = Run(@ComSpec & " /C" & "generated.bat", @ScriptDir, @SW_HIDE, 6)
				GUICtrlSetData($edit_out, $EMPTY_STRING)
				writeinlog("downloading " & GUICtrlRead($input_url))
				ProgressOn(translate($lng, "Downloading"), translate($lng, "Please wait."), "0%", 100, 20)
				Local $DOWNLOADLINE
				While 1
					Switch GUIGetMsg()
						Case $GUI_EVENT_CLOSE
							If BitAND(WinGetState($downloading), $WIN_STATE_ACTIVE) Then
								If ProcessExists("yt-dlp.exe") Or ProcessExists("yt-dlp_x86.exe") <> 0 Then
									Dim $iMsgBoxAnswer
									$iMsgBoxAnswer = MsgBox(5244324, translate($lng, "question"), translate($lng, "Your download has not finished yet. Are you sure you really want to get out of here?"))
									Select
										Case $iMsgBoxAnswer = 6
											ProcessClose($DOWNLOADLINE)
											GUICtrlSetData($edit_out, $EN_INTERRUPT_MESSAGE)
											Sleep(25)
											menuprogram()
										Case $iMsgBoxAnswer = 7
									EndSelect
								EndIf
							EndIf
					EndSwitch
					Local $randomwait = Random(3000, 10000, 1)
					Local $DOWNLOADLINE = StdoutRead($runcmd)
					If @error Then ExitLoop
					If $DOWNLOADLINE <> $EMPTY_STRING Then
						If StringInStr($DOWNLOADLINE, $DOWNLOAD_TAG) > 1 Then
							GUICtrlSetData($edit_out, $DOWNLOADLINE)
							$split1 = StringRight($DOWNLOADLINE, 5)
							$split2 = StringLeft($DOWNLOADLINE, 18)
							$split3 = Int(StringRight($split2, 6))
							$split4 = StringRight($split2, 3)
							$iSavPos = $split3
							GUICtrlSetData($idProgressbar, $split3)
							Select
								Case $ReadAccs = "yes"
									If $sayProgresses = "yes" Then
										Speaking($split3)
									EndIf
									If $BeepProgresses = "yes" Then
										CreateAudioProgress($split3)
									EndIf
									If $sayTime = "yes" Then
										Speaking(translate($lng, "Estimated time remaining:") & $split1)
									EndIf
							EndSelect
							writeinlog($DOWNLOADLINE)
						Else
							GUICtrlSetData($edit_out, GUICtrlRead($edit_out) & $DOWNLOADLINE)
						EndIf
					EndIf
					$DOWNLOADLINE = StderrRead($runcmd)
					If @error Then ExitLoop
					If $DOWNLOADLINE <> $EMPTY_STRING Then GUICtrlSetData($edit_out, GUICtrlRead($edit_out) & $DOWNLOADLINE)
				WEnd
				ProgressOff()
				$downloaded = $device.opensound("sounds/downloaded.ogg", 0)
				$downloaded.play
				Sleep(100)
				FileDelete("generated.bat")
				TrayTip(translate($lng, "Download complete"), translate($lng, "Your link") & $url & translate($lng, "Has been processed and uploaded correctly!"), 0, $TIP_ICONASTERISK)
				$Dialog_Complete = MsgBox(4, translate($lng, "Download complete"), translate($lng, "Do you want to open the download folder currently in use?"))
				If $Dialog_Complete = 6 Then
					ShellExecute($d_folder)
					If @error Then
						MsgBox(16, translate($lng, "Error"), translate($lng, 'Unable to open folder') & '"' & $d_folder & '".' & @CRLF & @CRLF & @extended)
						writeinlog("Unable to open folder " & $d_folder & '".' & @CRLF & @CRLF & @extended)
					Else
						writeinlog("video Downloaded. Open Folder=yes. Opening: " & $d_folder)
					EndIf
				Else
					writeinlog("video Downloaded. Open Folder=no")
				EndIf
				GUIDelete($downloading)
				GUISetState(@SW_SHOW, $dmain)
			Case $btn_share
				Global $URLData = $url
				If StringInStr($URLData, "http") Then
					shareLink()
				Else
					MsgBox(16, translate($lng, "Error"), translate($lng, 'The link entered in the edit box is not correct. Please put a link in the edit box "enter a URL" and try again.'))
				EndIf
			Case $btn_prev
				;Escuchavistaprevia()
			Case $chkbox_isSingle
				If BitAND(GUICtrlRead($chkbox_isSingle), $BN_CLICKED) = $BN_CLICKED Then
					If _GUICtrlButton_GetCheck($chkbox_isSingle) Then
						Select
							Case $ReadAccs = "yes"
								speaking(translate($lng, "The link was marked as video."))
							Case $ReadAccs = "no"
								ToolTip(translate($lng, "The link was marked as video."))
								ToolTip("")
						EndSelect
						GUICtrlSetData($chkbox_isSingle, translate($lng, "Download &video"))
						GUICtrlSetState($input_start, $GUI_HIDE)
						GUICtrlSetState($input_end, $GUI_HIDE)
						GUICtrlSetState($Label1, $GUI_HIDE)
					Else
						Select
							Case $ReadAccs = "yes"
								speaking(translate($lng, "link was marked as playlist."))
							Case $ReadAccs = "no"
								ToolTip(translate($lng, "link was marked as playlist"))
						EndSelect
						ToolTip("")
						GUICtrlSetData($chkbox_isSingle, "Download &playlist")
						GUICtrlSetState($input_start, $GUI_SHOW)
						GUICtrlSetState($input_end, $GUI_SHOW)
						GUICtrlSetState($Label1, $GUI_SHOW)
					EndIf
				EndIf

			Case $chkbox_sub
				If BitAND(GUICtrlRead($chkbox_sub), $BN_CLICKED) = $BN_CLICKED Then
					If _GUICtrlButton_GetCheck($chkbox_sub) Then
						If (StringLen($url) > 0) Then
							_GUICtrlComboBox_InsertString($combo_sublist, GetSubLang($url), 0)
							;MsgBox(0,"",GUICtrlRead($combo_sublist))
						EndIf
						GUICtrlSetState($combo_sublist, $GUI_SHOW)
						GUICtrlSetState($chkbox_onlysub, $GUI_SHOW)
					Else
						ConsoleWrite("Checkbox unchecked... " & @CRLF)
						_GUICtrlComboBox_ResetContent($combo_sublist)
						_GUICtrlComboBox_AddString($combo_sublist, "Auto sub")
						GUICtrlSetState($combo_sublist, $GUI_HIDE)
						GUICtrlSetState($chkbox_onlysub, $GUI_HIDE)
					EndIf
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>Imputdownload
; #FUNCTION# ====================================================================================================================
; Name ..........: GetSubLang
; Description ...: Get subtitles of the URL
; Syntax ........: GetSubLang($url)
; Parameters ....: $url                 - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func GetSubLang($url)
	Local $a_sublist
	Local $command = $MAIN & " --list-subs " & $url
	Local $cmdline = Run(@ComSpec & " /C " & $command, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	If @error Then
		MsgBox(16, translate($lng, "Error"), translate($lng, "The operation cannot be performed because the Yt-dlp.exe file cannot be found."))
	EndIf
	ProcessWaitClose($cmdline)
	Local $return = StdoutRead($cmdline)
	$a_sublist = StringSplit($return, @LF)
	Return StringLeft($a_sublist[UBound($a_sublist) - 2], 2)
EndFunc   ;==>GetSubLang
; #FUNCTION# ====================================================================================================================
; Name ..........: shareLink
; Description ...: Share multimedia link
; Syntax ........: shareLink()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func shareLink()
	$ReadAccs = IniRead("config\config.st", "Accessibility", "Enable enanced accessibility", "")
	$Rpositioning = IniRead("config\config.st", "Accessibility", "Announce position", "")
	$shareGui = GUICreate(translate($lng, "Share with..."))
	GUISetState(@SW_SHOW)
	Select
		Case $ReadAccs = "yes"
			$shareMenu = Reader_Create_Menu(translate($lng, "Share with..."), "Whatsapp|Facebook|Skype|" & translate($lng, "Back"), $Rpositioning, translate($lng, "Of"))
			Select
				Case $shareMenu = 1
					ShellExecute("https://api.whatsapp.com/send?text= " & translate($lng, "I share this link with you: This link has been shared through MCY Downloader. Link:") & @CRLF & $URLData)
					If @error Then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
					GUIDelete($shareGui)
				Case $shareMenu = 2
					ShellExecute("https://www.facebook.com/sharer.php?u=" & $URLData & "&t=" & translate($lng, "I share this link with you: This link has been shared through MCY Downloader. Link: ") & @CRLF & $URLData & @CRLF & translate($lng, "Shared Link via MCY Downloader"))
					If @error Then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
					GUIDelete($shareGui)
				Case $shareMenu = 3
					ShellExecute("https://web.skype.com/share?url=" & $URLData & "&lang=en-US=&source=jetpack")
					If @error Then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
					GUIDelete($shareGui)
				Case $shareMenu = 4
					GUIDelete($shareGui)
			EndSelect
		Case $ReadAccs = "No"
			$idWhatsapp = GUICtrlCreateButton(translate($lng, "Share on") & " WhatsApp", 90, 50, 70, 25)
			$idFacebook = GUICtrlCreateButton(translate($lng, "Share on") & "Facebook", 130, 50, 70, 25)
			$idSkype = GUICtrlCreateButton(translate($lng, "Share on") & "Skype", 180, 50, 70, 25)
			$idBack = GUICtrlCreateButton(translate($lng, "Back"), 250, 50, 70, 25)
			; Loop until the user exits.
			While 1
				$idMsg = GUIGetMsg()
				Switch $idMsg
					Case $GUI_EVENT_CLOSE, $idBack
						GUIDelete($shareGui)
						;GUISetState(@SW_SHOW, $dmain)
						ExitLoop
					Case $idWhatsapp
						ShellExecute("https://api.whatsapp.com/send?text= " & translate($lng, "I share this link with you: This link has been shared through MCY Downloader. Link:") & @CRLF & $URLData)
						If @error Then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
						GUIDelete($shareGui)
						ExitLoop
					Case $idFacebook
						ShellExecute("https://www.facebook.com/sharer.php?u=" & $URLData & "&t=" & translate($lng, "I share this link with you: This link has been shared through MCY Downloader. Link: ") & @CRLF & $URLData & @CRLF & translate($lng, "Shared Link via MCY Downloader"))
						If @error Then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
						GUIDelete($shareGui)
						ExitLoop
					Case $idSkype
						ShellExecute("https://web.skype.com/share?url=" & $URLData & "&lang=en-US=&source=jetpack")
						If @error Then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
						GUIDelete($shareGui)
						ExitLoop
				EndSwitch
			WEnd
	EndSelect
EndFunc   ;==>shareLink
FileDelete("generated.bat")
;run("engines\yt-dlp.exe $Enlace --prefer-ffmpeg ffmpeg-location PATH ffmpeg.exe --audio-quality 320K (default 5) mp3 --convert-subs srt")
