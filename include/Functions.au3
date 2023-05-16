#include <EditConstants.au3>
#include "reorder.au3"
#include "share.au3"
#include <WindowsConstants.au3>
;This is the functions of MCY downloader.
;**please do not touch this file in case you do not have knowledge about programming or technical things.
; #FUNCTION# ====================================================================================================================
; Name ..........: _StringInArray
; Description ...: check if string is part of array
; Syntax ........: _StringInArray($a_Array, $s_String)
; Parameters ....: $a_Array             - An array of unknowns.
;                  $s_String            - A string value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _StringInArray($a_Array, $s_String)
Local $i_ArrayLen = UBound($a_Array) - 1
For $i = 0 To $i_ArrayLen
If $a_Array[$i] = $s_String Then
Return $i
EndIf
Next
SetError(1)
Return 0
EndFunc
;Function wen the program is not compiled for use.
; #FUNCTION# ====================================================================================================================
; Name ..........: NotCompiled
; Description ...: function that checks when the program is not compiled
; Syntax ........: NotCompiled()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func NotCompiled()
;If the program is not compiled, it plays the sound along with the following message:
If @Compiled Then
selector()
Else
$errorsound = $device.opensound ("sounds/error_not_comp.ogg", 0)
$errorsound.play
;Show error message.
MsgBox($MB_SYSTEMMODAL, "", "You have to compile this program first to run it. Then the program will close now.")
writeinlog("The program is not compiled... Exiting.")
exitpersonaliced()
EndIf
EndFunc
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
global $PROGRAMGUI = GUICreate("MCY Downloader " &$program_ver, 500, 500)
; We set the keyboard shortcut to view to the help document.
HotKeySet("{F1}", "playhelp")
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
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
GUISetState(@SW_Hide, $PROGRAMGUI)
Imputdownload()
Case $idSearchitem
writeinlog("Function: Search.")
GUISetState(@SW_Hide, $PROGRAMGUI)
Search()
case $idRadioitem
writeinlog("Function: Radio.")
Radio()
case $idConvitem
writeinlog("Function: mp3Converter()")
mp3Converter()
case $idURLitem
writeinlog("Function: ReproducirURL()")
ReproducirURL()
case $idorderitem
writeinlog("Function: reOrganizar()")
reOrganizar()
case $idOptionsitem 
writeinlog("Function: options")
sleep(100)
If $ReadAccs ="yes" Then
$hOptionsGui = GuiCreate("options menu (accessibility)")
GuiSetState(@sw_SHOW)
sleep(500)
menu_options()
GuiDelete($hOptionsGui)
Else
menu_options2()
EndIf
case $idChanges 
If $ReadAccs ="yes" Then
readchanges()
Else
readchanges2()
EndIf
Case $idErrorreporting
ShellExecute("https://docs.google.com/forms/d/e/1FAIpQLSdDW6LqMKGHjUdKmHkAZdAlgSDilHaWQG9VZjwLz0CJSXKqHA/viewform?usp=sf_link")
If @error then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
case $idGitHub 
ShellExecute("https://github.com/rmcpantoja/MCY-downloader/issues/new")
If @error then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
case $idCheckupdates
writeinlog("Checking components...")
GuiSetState(@sw_Hide, $PROGRAMGUI)
updcomponents()
Case $GUI_EVENT_CLOSE, $idExitbutton, $idExititem
exitpersonaliced()
Case $idHelpitema
; This is the dialog about the program in which it will be shown on the screen.
MsgBox(48, translate($lng, "About..."), $programname &", " &translate($lng, "version") &$program_ver &". " &translate($lng, "Program developed by mateo cedillo. This software is used to download multimedia from a variety of sites. 2018-2022 MT programs."))
continueLoop
case $idHelpitemb
ShellExecute("http://mateocedillo.260mb.net/")
If @error then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
case $idHelpitemc
writeinlog("function: User manual.")
playhelp()
case $idMenubtn
SEND("{alt}")
case $idmanualbutton
playhelp()
case $idchangesbutton
If $ReadAccs ="yes" Then
readchanges()
Else
readchanges2()
EndIf
case $idGitHubBTN
ShellExecute("https://github.com/rmcpantoja/")
If @error then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
case $idShareBTN
Opt("GUIOnEventMode",1)
share(translate($lng, "Hello! I share with you MCY Downloader, a software to download multimedia in high quality, videos, music, playlists, users and everything you want in a single click; rearrange your music, audio converter, radio and more!. Visit download page here, where you will find the versions for 32 and 64-bit:"), "http://mateocedillo.260mb.net/programs.html")
Opt("GUIOnEventMode",0)
EndSwitch
WEnd
GUIDelete()
EndFunc
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
func playhelp()
Opt("GUIOnEventMode",0)
Local $manualdoc = "documentation\" &$lng &"\manual.txt"
Global $DocOpen = FileOpen($manualdoc, $FO_READ)
if $accessibility = "yes" then
speaking(translate($lng, "opening..."))
else
ToolTip(translate($lng, "opening..."))
EndIf
If $DocOpen = -1 Then MsgBox($MB_SYSTEMMODAL, translate($lng, "Error"), translate($lng, "An error occurred while reading the file."))
Local $openned = FileRead($DocOpen)
if $accessibility = "no" then ToolTip("")
global $manualwindow = GUICreate(translate($lng, "User manual"))
Local $idMyedit = GUICtrlCreateEdit($openned, 5, 5, 390, 360, BitOR($WS_VSCROLL, $WS_HSCROLL, $ES_READONLY))
Local $idExitBtn2 = GUICtrlCreateButton(translate($lng, "Close"), 100, 370, 150, 30)
GUISetState(@SW_SHOW)
while 1
switch GuiGetMsg()
case $GUI_EVENT_CLOSE, $idExitBtn2
FileClose($DocOpen)
exitloop
endSwitch
wend
GUIDelete()
EndFunc
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
global $ventana = GUICreate(translate($lng, "Play URL"))
global $playlabel = GUICtrlCreateLabel(translate($lng, "Enter URL, Please enter the direct multimedia link you want to play."), 0, 50, 20, 20)
$urlinput = GUICtrlCreateInput("", 0, 70, 20, 20)
$ok = GUICtrlCreateButton(translate($lng, "OK"), 70, 50, 20, 20)
$cancel = GUICtrlCreateButton(translate($lng, "Cancel"), 130, 50, 20, 20)
GUISetState(@SW_SHOW)
While 1
Switch  GUIGetMsg()
Case $GUI_EVENT_CLOSE, $cancel
GuiDelete($ventana)
Menuprogram()
case $ok
global $enlace = GUICtrlRead($urlinput)
if $enlace = "" then
MSGBox(16, translate($lng, "Error"), translate($lng, "There is no URL!"))
continueLoop
Else
PlayDirectAudioURL($ENlace)
EndIf
EndSwitch
Wend
EndFunc
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
func menu_options()
; This option is to add the program's options menu, where you can configure everything your way.
$sLanguage = iniRead ("config\config.st", "General settings", "language", "")
$download_dir = iniRead ("config\config.st", "General settings", "Destination folder", "")
$Rpositioning = iniRead ("config\config.st", "Accessibility", "Announce position", "")
select
case $download_dir =""
$download_dir="C:\MCY\Download"
endSelect
$okmessaje="OK"
$menuPos = translate($lng, "OF")
$menuString = translate($lng, "Select audio quality.") &"|" &translate($lng, "Change download folder, Currently") &" " &$download_dir &"|" &translate($lng, "Change language, Currently") &" " &$sLanguage &"|" &translate($lng, "Enable or disable enhanced accessibility.") &"|" &translate($lng, "Select screen reader") &"|" &translate($lng, "Re-organize audios and videos now") &"|" &translate($lng, "Save log file") &"|" &translate($lng, "Always check for program and component updates (recommended)") &"|" &translate($lng, "Enable / disable:") &" " &translate($lng, "Read download progress bars") &"|" &translate($lng, "Enable / disable:") &" " &translate($lng, "Read remaining time of download") &"|" &translate($lng, "Enable / disable:") &" " &translate($lng, "Beep for progress bars") &"|" &translate($lng, "Enable / disable:") &" " &translate($lng, "Down the multimedia volume while the screen reader is speaking") &"|" &translate($lng, "Enable / disable:") &" " &translate($lng, "Announce position of items in menus and in lists") &"|" &translate($lng, "Show tips") &"|" &translate($lng, "Select quantity of search results") &"|" &translate($lng, "Clear settings") &"|" &translate($lng, "Close this menu.")
$p_options=reader_Create_Menu(translate($lng, "Options menu. Use up and down arrows to go to them, and enter to execute an action."), $menuString, $Rpositioning, $menuPos)
select
case $p_options = 1
$Bitrate=reader_Create_Menu(translate($lng, "please select:"), "128 kbps|160 kbps|192 kbps|224 kbps|256 kbps|320 kbps,|84 kbps(experimental", $Rpositioning, $menuPos)
select
case $bitrate = 1
IniWrite("config\config.st", "General settings", "Audio Quality", "128k")
case $bitrate = 2
IniWrite("config\config.st", "General settings", "Audio Quality", "160k")
case $bitrate = 3
IniWrite("config\config.st", "General settings", "Audio Quality", "192k")
case $bitrate = 4
IniWrite("config\config.st", "General settings", "Audio Quality", "224k")
case $bitrate = 5
IniWrite("config\config.st", "General settings", "Audio Quality", "256k")
case $bitrate = 6
IniWrite("config\config.st", "General settings", "Audio Quality", "320k")
case $bitrate = 7
IniWrite("config\config.st", "General settings", "Audio Quality", "384k")
endselect
case $p_options = 2
Local $d_path = FileSelectFolder(translate($lng, "Select destination folder:"), $download_dir)
speaking($d_path)
IniWrite("config\config.st", "General settings", "Destination folder", $d_path)
case $p_options = 3
$configureaccs = iniRead ("config\config.st", "accessibility", "Enable enanced accessibility", "")
$menu_lang=reader_Create_Menu("Please select your language", "Spanish|English|Back", $Rpositioning, $menuPos)
select
case $menu_lang = 1
IniDelete ( "config\config.st", "General settings", "language")
sleep(50)
IniWrite("config\config.st", "General settings", "language", "es")
case $menu_lang = 2
IniDelete ( "config\config.st", "General settings", "language")
sleep(50)
IniWrite ("config\config.st", "General settings", "language", "eng")
;case $menu_lang = 3
;$s_selected = $device.opensound ("sounds/selected.ogg", 0)
;$s_selected.play
;speaking($okmessaje)
EndSelect
MsgBox(48, translate($lng, "Information"), translate($lng, "Please restart MCY Downloader for the changes to take effect."))
case $p_options = 4
$en_a=reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") &"|" &translate($lng, "no"), $Rpositioning, $menuPos)
select
case $en_a = 1
IniWrite("config\config.st", "accessibility", "Enable enanced accessibility", "Yes")
case $en_a = 2
IniWrite("config\config.st", "accessibility", "Enable enanced accessibility", "No")
endselect
case $p_options = 5
$SpeakWh=Reader_Create_Menu(translate($lng, "What screen reader do you want to use?"), "NVDA|JAWS|sapi5", $Rpositioning, $menuPos)
select
case $speakWh = 1
IniWrite("config\config.st", "accessibility", "Speak Whit", "NVDA")
case $speakWh = 2
IniWrite("config\config.st", "accessibility", "Speak Whit", "JAWS")
case $speakWh = 3
IniWrite("config\config.st", "accessibility", "Speak Whit", "Sapi")
endselect
case $p_options = 6
reOrganizar()
case $p_options = 7
$menu_log=reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") &"|" &translate($lng, "no"), $Rpositioning, $menuPos)
select
case $menu_log = 1
IniWrite("config\config.st", "General settings", "Sabe Logs", "Yes")
case $menu_log = 2
IniWrite("config\config.st", "General settings", "Sabe Logs", "No")
endselect
case $p_options = 8
$menu_update=reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") &"|" &translate($lng, "no"), $Rpositioning, $menuPos)
select
case $menu_Update = 1
IniWrite("config\config.st", "General settings", "Check updates", "Yes")
case $menu_update = 2
IniWrite("config\config.st", "General settings", "Check updates", "No")
endselect
case $p_options = 9
$m_progress=reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") &"|" &translate($lng, "no"), $Rpositioning, $menuPos)
select
case $m_progress = 1
iniWrite ("config\config.st", "Accessibility", "Read download progress bar", "Yes")
case $m_progress = 2
iniWrite ("config\config.st", "Accessibility", "Read download progress bar", "No")
EndSelect
case $p_options = 10
$m_time=reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") &"|" &translate($lng, "no"), $Rpositioning, $menuPos)
select
case $m_time = 1
iniWrite ("config\config.st", "Accessibility", "Read download remaining time", "Yes")
case $m_time = 2
iniWrite ("config\config.st", "Accessibility", "Read download remaining time", "No")
EndSelect
case $p_options = 11
$PBeep=reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") &"|" &translate($lng, "no"), $Rpositioning, $menuPos)
select
case $PBeep = 1
iniWrite ("config\config.st", "Accessibility", "Beep for progress bars", "Yes")
case $PBeep = 2
iniWrite ("config\config.st", "Accessibility", "Beep for progress bars", "No")
EndSelect
case $p_options = 12
$audioDuck=reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") &"|" &translate($lng, "no"), $Rpositioning, $menuPos)
select
case $audioDuck = 1
iniWrite ("config\config.st", "Accessibility", "Audio ducking", "Yes")
case $AudioDuck = 2
iniWrite ("config\config.st", "Accessibility", "Audio ducking", "No")
EndSelect
case $p_options = 13
$AnouncePositions=reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") &"|" &translate($lng, "no"), $Rpositioning, $menuPos)
select
case $AnouncePositions = 1
iniWrite ("config\config.st", "Accessibility", "Announce position", "1")
case $AnouncePositions = 2
iniWrite ("config\config.st", "Accessibility", "Announce position", "0")
EndSelect
case $p_options = 14
$showtips=reader_Create_Menu(translate($lng, "please select:"), translate($lng, "yes") &"|" &translate($lng, "no"), $Rpositioning, $menuPos)
select
case $showtips = 1
iniWrite ("config\config.st", "misc", "Show tips", "1")
case $showtips = 2
iniWrite ("config\config.st", "misc", "Show tips", "0")
EndSelect
case $p_options = 15
$qsearch=reader_Create_Menu(translate($lng, "please select:"), "5|10|25|50|75|100|150|200|250|300", $Rpositioning, $menuPos)
select
case $qsearch = 1
iniWrite ("config\config.st", "search", "Number of results", "5")
case $qsearch = 2
iniWrite ("config\config.st", "search", "Number of results", "10")
case $qsearch = 3
iniWrite ("config\config.st", "search", "Number of results", "25")
case $qsearch = 4
iniWrite ("config\config.st", "search", "Number of results", "50")
case $qsearch = 5
iniWrite ("config\config.st", "search", "Number of results", "75")
case $qsearch = 6
iniWrite ("config\config.st", "search", "Number of results", "100")
case $qsearch = 7
iniWrite ("config\config.st", "search", "Number of results", "150")
case $qsearch = 8
iniWrite ("config\config.st", "search", "Number of results", "200")
case $qsearch = 9
iniWrite ("config\config.st", "search", "Number of results", "250")
case $qsearch = 10
iniWrite ("config\config.st", "search", "Number of results", "300")
EndSelect
case $p_options = 16
$confirmarborrado=reader_Create_Menu(translate($lng, "Are you sure?"), translate($lng, "yes") &"|" &translate($lng, "no"), $Rpositioning, $menuPos)
select
case $confirmarborrado ="1"
DirRemove(@ScriptDir & "\config", 1)
MsgBox(48, translate($lng, "Information"), translate($lng, "Please restart MCY Downloader for the changes to take effect."))
Exitpersonaliced()
case $confirmarborrado ="2"
Menu_options()
EndSelect
case $p_options = 17
$s_selected = $device.opensound ("sounds/selected.ogg", 0)
$s_selected.play
speaking($okmessaje)
EndSelect
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _IsChecked
; Description ...: check if a control is checked
; Syntax ........: _IsChecked($idControlID)
; Parameters ....: $idControlID         - An AutoIt controlID.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _IsChecked($idControlID)
Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc
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
$sLanguage = iniRead ("config\config.st", "General settings", "language", "")
$download_dir = iniRead ("config\config.st", "General settings", "Destination folder", "")
select
case $download_dir =""
$download_dir="C:\MCY\Download"
endSelect
Dim $aArray[0]
Dim $bArray[0]
$okmessaje="OK"
$guioptions = GuiCreate(translate($lng, "Options menu"))
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
GUICtrlSetState($idBTR7, $GUI_CHECKED)
local $BTNChooseF = GUICtrlCreateButton(translate($lng, "Change download folder, Currently") &" " &$download_dir, 50, 200, 120, 25)
$lang_Label = GUICtrlCreateLabel(translate($lng, "Change language, Currently") &" " &$sLanguage, 60, 200, 120, 25)
$idComboBox = GUICtrlCreateCombo("Spanish", 60, 200, 150, 30, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData($idComboBox, "English", "Spanish")
$accs_Label = GUICtrlCreateLabel(translate($lng, "Enable or disable enhanced accessibility."), 90, 200, 120, 25)
$idComboBox2 = GUICtrlCreateCombo("Yes", 60, 260, 150, 30, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData($idComboBox2, "No")
$search_Label = GUICtrlCreateLabel(translate($lng, "Select quantity of search results"), 115, 200, 120, 25)
$idQsearch = GUICtrlCreateCombo("5", 60, 280, 150, 30, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData($idQsearch, "10|25|50|75|100|150|200|250|300")
local $BTN_ReOrder = GUICtrlCreateButton(translate($lng, "Re-organize audios and videos now"), 120, 200, 180, 25)
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
guiDelete($guioptions)
ExitLoop
Case $idMsg = $idBTR1 And BitAND(GUICtrlRead($idBTR1), $GUI_CHECKED) = $GUI_CHECKED
IniWrite("config\config.st", "General settings", "Audio Quality", "128k")
Case $idMsg = $idBTR2 And BitAND(GUICtrlRead($idBTR2), $GUI_CHECKED) = $GUI_CHECKED
IniWrite("config\config.st", "General settings", "Audio Quality", "160k")
Case $idMsg = $idBTR3 And BitAND(GUICtrlRead($idBTR3), $GUI_CHECKED) = $GUI_CHECKED
IniWrite("config\config.st", "General settings", "Audio Quality", "192k")
Case $idMsg = $idBTR4 And BitAND(GUICtrlRead($idBTR4), $GUI_CHECKED) = $GUI_CHECKED
IniWrite("config\config.st", "General settings", "Audio Quality", "224k")
Case $idMsg = $idBTR5 And BitAND(GUICtrlRead($idBTR5), $GUI_CHECKED) = $GUI_CHECKED
IniWrite("config\config.st", "General settings", "Audio Quality", "256k")
Case $idMsg = $idBTR6 And BitAND(GUICtrlRead($idBTR6), $GUI_CHECKED) = $GUI_CHECKED
IniWrite("config\config.st", "General settings", "Audio Quality", "320k")
Case $idMsg = $idBTR7 And BitAND(GUICtrlRead($idBTR7), $GUI_CHECKED) = $GUI_CHECKED
IniWrite("config\config.st", "General settings", "Audio Quality", "384k")
case $idMsg = $BTNChooseF
Local $d_path = FileSelectFolder(translate($lng, "Select destination folder:"), $download_dir)
IniWrite("config\config.st", "General settings", "Destination folder", $d_path)
Case $idMsg = $idComboBox
$sComboRead = GUICtrlRead($idComboBox)
select
case $sComboRead = "Spanish"
IniDelete ( "config\config.st", "General settings", "language")
sleep(50)
IniWrite("config\config.st", "General settings", "language", "es")
case $sComboRead = "English"
IniDelete ( "config\config.st", "General settings", "language")
sleep(50)
IniWrite ("config\config.st", "General settings", "language", "eng")
EndSelect
MsgBox(48, translate($lng, "Information"), translate($lng, "Please restart MCY Downloader for the changes to take effect."))
Case $idMsg = $idComboBox2
$sComboRead = GUICtrlRead($idComboBox2)
IniWrite("config\config.st", "accessibility", "Enable enanced accessibility", $sComboRead)
MsgBox(48, translate($lng, "Information"), translate($lng, "Please restart MCY Downloader for the changes to take effect."))
Case $idMsg = $idQsearch
$sComboRead = GUICtrlRead($idQsearch)
IniWrite("config\config.st", "Search", "Number of results", $sComboRead)
case $idMsg = $BTN_reOrder
reOrganizar()
Case $idMsg = $idSabelogs
If _IsChecked($idSabelogs) Then
IniWrite("config\config.st", "General settings", "Sabe Logs", "Yes")
Else
IniWrite("config\config.st", "General settings", "Sabe Logs", "No")
EndIf
Case $idMsg = $idCheckupds
If _IsChecked($idCheckUpds) Then
IniWrite("config\config.st", "General settings", "Check updates", "Yes")
Else
IniWrite("config\config.st", "General settings", "Check updates", "No")
EndIf
case $idMsg = $idShowtips
If _IsChecked($idShowtips) Then
iniWrite ("config\config.st", "misc", "Show tips", "1")
Else
iniWrite ("config\config.st", "misc", "Show tips", "0")
EndIf
case $idMsg = $idBTN_Clean
$confirmarborrado = MsgBox(4, translate($lng, "Clear settings"), translate($lng, "Are you sure?"))
select
case $confirmarborrado = 6
DirRemove(@ScriptDir & "\config", 1)
MsgBox(48, translate($lng, "Information"), translate($lng, "Please restart MCY Downloader for the changes to take effect."))
Exitpersonaliced()
EndSelect
Case $idMsg = $idBTN_Close
guiDelete($guioptions)
ExitLoop
EndSelect
WEnd
endfunc
; #FUNCTION# ====================================================================================================================
; Name ..........: reOrganizar
; Description ...: function to reorganice audio and video
; Syntax ........: reOrganizar()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
func reOrganizar()
local $AudioFormats[10] = ["Aiff", "Aac", "flac", "IFF", "mp3", "m4a", "ogg", "OPUS", "wav", "wma"]
local $videoFormats[10] = ["Mp4", "FLV", "AVI", "MKV", "3gp", "WMV", "asf", "MOV", "SWF", "WEBM"]
$ReorderGui = GuiCreate("Reordering...")
$rlabel = GuiCtrlCreateLabel(translate($lng, "starting reordering... Please wait."), 10, 100, 200, 20)
GuiSetState(@SW_SHOW)
sleep(1000)
for $I = 0 to UBound($audioFormats, $UBOUND_ROWS) - 1
GuiCtrlSetData($rlabel, translate($lng, "Reordering audios with the format") &" " &$audioFormats[$I] &"...")
$reorderrresult = ReOrder("video", $audioFormats[$I], $d_folder &"\audio")
sleep(100)
if $reorderrresult = 0 then GuiCtrlSetData($rlabel, translate($lng, "There is nothing to reorder here."))
sleep(100)
Next
for $I = 0 to UBound($videoFormats, $UBOUND_ROWS) - 1
GuiCtrlSetData($rlabel, translate($lng, "Reordering videos with the format") &" " &$videoFormats[$I] &"...")
$reorderrresult = ReOrder("Audio", $videoFormats[$I], $d_folder &"\video")
sleep(100)
if $reorderrresult = 0 then GuiCtrlSetData($rlabel, translate($lng, "There is nothing to reorder here."))
sleep(100)
Next
MsgBox(48, translate($lng, "Done"), translate($lng, "The audios and videos have been reordered correctly!"))
GuiDelete($ReorderGui)
EndFunc