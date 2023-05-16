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
global $programname="MCY Downloader"
global $arquitectura = "x64"
global $program_ver = "1.0B1"
global $ifitisupdate = IniRead(@scriptDir &"\Config\config.st", "General settings", "Check updates", "")
If $ifitisupdate = "" then
IniWrite(@ScriptDir &"\Config\config.st", "General settings", "Check updates", "Yes")
$ifitisupdate = "yes"
else
EndIF
global $lng = iniRead ("config\config.st", "General settings", "language", "")
;Including program scripts:
;#include <Array.au3>;para un futuro
#include "Include\audio.au3"
#include "include\busqueda.au3"
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#Include<fileConstants.au3>
#include "Include\functions.au3"
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <GuiComboBox.au3>
#include "include\GUICtrlSetTip_accessible.au3"
#include <InetConstants.au3>;
;#include "Include\mergefiles_utf16le_v2.au3"
#include "Include\Mp3_converter.au3"
#include "Include\kbc.au3"
#include "Include\log.au3"
#include "Include\menu_nvda.au3"
#include <MsgBoxConstants.au3>
#include "Include\NVDAControllerClient.au3"
#include "Include\player.au3"
#include "include\progress.au3"
#include <ProgressConstants.au3>
#include "Include\radio.au3"
#include "Include\reader.au3"
#Include "Include\sapi.au3"
#include "Include\say_UDF.au3"
;#include <String.au3>;for a future
#include "include\translator.au3"
#include <TrayConstants.au3>
#include "updater.au3"
#include <WindowsConstants.au3>
;New command line options! Incredible as it may seem, it is.
If _StringInArray($CmdLine, '/radio') Then
radio()
exitpersonaliced()
ElseIf _StringInArray($CmdLine, '/help') Then
MsgBox(0, "command line instructions", "/radio: open MCY Radio" &@crlf &"/help: query this help.")
exitpersonaliced()
EndIf
;Creates a window wenn the program is loading:
$l1 = GUICreate(translate($lng, "Loading..."))
GUISetState(@SW_SHOW)
writeinlog("Initialicing...")
if @OSArch = "x64" then
Global $sYouTube_DL = IniRead("config\config.st", 'General Settings', 'Youtube-DL', 'engines64\yt-dlp.exe')
elseif @OSArch = "x86" then
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
func comprovarArc()
$developermode= "1"
if not fileExists ("config") then
$configfolder = DirCreate("config")
if $configfolder = "0" then
MSGBox(16, Translate($lng, "Error"), Translate($lng, "Config folder could not be created. If so, please run the program as administrator."))
exitpersonaliced()
EndIf
EndIf
writeinlog("Checking architecture")
GUIDelete($l1)
if @OSArch = "x64" and $arquitectura = "x64" then
writeinlog("Windows 64 bit")
endif
if @OSArch = "x86" and $arquitectura = "x86" then
writeinlog("Windows 32 bit")
endif
if @OSArch = "x64" and $arquitectura = "x86" then
msgBox(48, Translate($lng, "Warning"), Translate($lng, "You run a 64-bit pc with the 32-bit version of the program. For better performance in the program, we recommend that you download the 64-bit version at http://mateocedillo.260mb.net/programs.html"))
exitpersonaliced()
endif
if @OSArch = "x86" and $arquitectura = "x64" then
msgBox(48, Translate($lng, "Warning"), Translate($lng, "You run a 32-bit pc with the 64-bit version of the program. For better performance in the program, we recommend that you download the 32-bit version at http://mateocedillo.260mb.net/programs.html"))
exitpersonaliced()
endif
select
case $developermode = 1
writeinlog("Checking program copy...")
checkcopy()
case $developermode = 0
writeinlog("The program is not compiled. Exiting...")
NotCompiled()
EndSelect
EndFunc
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
func checkcopy()
if @scriptDir ="C:\MCY" then
IniWrite("config\config.st", "General settings", "Program Type", "Installable")
writeinlog("Copy: Installable.")
else
IniWrite("config\config.st", "General settings", "Program Type", "Portable")
writeinlog("Copy: Portable.")
endif
firstlaunch()
endfunc
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
func firstlaunch()
global $accessibility = iniRead ("config\config.st", "accessibility", "Enable enanced accessibility", "")
select
case $accessibility =""
configure()
Case Else
checkselector()
endselect
endfunc
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
func exitpersonaliced()
_nvdaControllerClient_free()
writeinlog("exiting...")
global $soundclose = $device.opensound ("sounds/close.ogg", 0)
$soundclose.play
sleep(500)
FileDelete(@tempDir &"\MCYWeb.dat")
FileDelete(@scriptdir &"\tmp_motd_es.ogg")
exit
endfunc
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
func configure()
writeinlog("Launching at first time.")
$Warning=MsgBox(4, translate($lng, "Enable enhanced accessibility?"), translate($lng, "This new Enhanced Accessibility functionality is designed for the visually impaired, in which most of the program interface can be used by voice and keyboard shortcuts. Activate?"))
if $warning = 6 then
IniWrite("config\config.st", "accessibility", "Enable enanced accessibility", "Yes")
writeinlog("Enanced accesibility: Yes.")
else
IniWrite("config\config.st", "accessibility", "Enable enanced accessibility", "No")
writeinlog("Enanced accesibility: No.")
endif
global $accessibility = iniRead ("config\config.st", "accessibility", "Enable enanced accessibility", "")
checkselector()
endfunc
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
func checkselector()
global $lng = iniRead ("config\config.st", "General settings", "language", "")
select
case $lng =""
selector()
Case Else
checkupd()
endselect
endfunc
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
Opt("GUIOnEventMode",1)
local $widthCell,$msg,$iOldOpt
global $langGUI= GUICreate("Language Selection")
global $seleccionado="0"
$widthCell=70
$iOldOpt=Opt("GUICoordMode",$iOldOpt)
$beep = "0"
$busqueda = "0"
dim $langcodes[50]
GUICtrlCreateLabel("Select language:", -1,0)
GUISetBkColor(0x00E0FFFF)
$recolectalosidiomasporfavor = FileFindFirstFile(@scriptDir &"\lng\*.lang")
If $recolectalosidiomasporfavor = -1 Then MsgBox(16, "Fatal error", "We cannot find the language files. Please download the program again...")
Local $Recoleccion = "", $obteniendo = ""
While 1
$beep = $Beep +1
$busqueda = $busqueda +1
$Recoleccion = FileFindNextFile($recolectalosidiomasporfavor)
If @error Then
;MsgBox(16, "Error", "We cannot find the language files or they are corrupted.")
CreateAudioProgress("100")
ExitLoop
EndIf
$splitCode = StringLeft($Recoleccion, 2)
$obteniendo &= GetLanguageName($splitCode) &", " &GetLanguageCode($splitCode) &"|"
$langcodes[$busqueda] = GetLanguageCode($splitcode)
CreateAudioProgress($beep)
Sleep(100)
WEnd
GUISetState(@SW_SHOW)
$langcount = StringSplit($obteniendo, "|")
$fix_audiomenu=StringTrimRight($obteniendo, 1)
$configureaccs = iniRead ("config\config.st", "accessibility", "Enable enanced accessibility", "")
if $configureaccs ="yes" then
$menu=Reader_create_menu("Please select a language with the up and down arrows and press enter to continue", $fix_audiomenu)
endif
if $configureaccs ="no" then
global $Choose = GUICtrlCreateCombo("", 100, 50, 200, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GuiCtrlSetOnEvent(-1, "seleccionar")
GUICtrlSetData($Choose, $obteniendo)
global $idBtn_OK = GUICtrlCreateButton("OK", 155, 50, 70, 30)
GuiCtrlSetOnEvent(-1, "save")
global $idBtn_Close = GUICtrlCreateButton("Close", 180, 50, 70, 30)
GuiCtrlSetOnEvent(-1, "exitpersonaliced")
Global $LEER = ""
while 1
if $seleccionado="1" then
Opt("GUIOnEventMode",0)
;msgbox(0, "Correct", "We should close this.")
exitloop
EndIf
Wend
GUIDelete($langGui)
checkupd()
endif
if $configureaccs ="yes" then
IniWrite("config\config.st", "General settings", "language", $langcodes[$menu])
if @error then
MSGBox (0, "Error", "Configuration data could not be written.")
Exitpersonaliced()
EndIf
GUIDelete($langGUI)
checkupd()
endif
Opt("GUIOnEventMode",0)
EndFunc
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
func seleccionar()
global $leer = GUICtrlRead($choose)
global $queidiomaes = StringSplit($leer, ",")
;speaking("Has seleccionado " &StringStripWS($queidiomaes[2], $STR_STRIPLEADING))
EndFunc
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
func save()
IniWrite("config\config.st", "General settings", "language", StringStripWS($queidiomaes[2], $STR_STRIPLEADING))
$seleccionado="1"
EndFunc
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
func checkupd()
global $main_u = GUICreate(translate($lng, "Checking version..."))
$mlb = GUICtrlCreateLabel(translate($lng, "Please wait."), 0, 10, 100, 20)
GUISetState(@SW_SHOW)
toolTip(translate($lng, "checking version..."))
if $ifitisupdate = "Yes" then
checkmcyversion()
GUIDelete($main_u)
else
writeinlog("the user does not want updates")
GUIDelete($main_u)
Principal()
EndIF
Sleep(250)
GUIDelete($main_u)
endfunc
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
func checKmcyversion()
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
writeinlog("Checking for updates...")
Local $yourexeversion = $program_Ver
$fileinfo = InetGet("https://www.dropbox.com/s/hcx20lgvjem0wz1/MCYWeb.dat?dl=1", @tempDir &"\MCYWeb.dat")
$latestver = iniRead (@TempDir & "\MCYWeb.dat", "updater", "LatestVersion", "")
if $ReadAccs ="Yes" then
select
Case $latestVer <> $yourexeversion
writeinlog("Warning! Update available. Your version:" &$yourexeversion & ". New version:" & $latestver)
CreateTTSDialog(translate($lng, "Update available!"), translate($lng, "You have the version") &" " &$yourexeversion &" " &translate($lng, "and is available the") &" " &$latestver, translate($lng, " press enter to continue, space to repeat information."))
GUIDelete($main_u)
if $arquitectura = "x64" then
_Updater_update("MCY.exe", "https://www.dropbox.com/s/d49pf4blsv61aoz/extract.exe?dl=1")
Else
_Updater_update("MCY.exe", "https://www.dropbox.com/s/ccp9mjaw35gzn9s/extract_x86.exe?dl=1")
EndIf
Case else
GUIDelete($main_u)
checkmotd()
endselect
endif
if $ReadAccs ="No" then
select
Case $latestVer <> $yourexeversion
writeinlog(translate($lng, "You have the version") &" " &$program_ver &" " &translate($lng, "and is available the") &" " &$latestver)
msgbox(0, translate($lng, "Update available!"), translate($lng, "You have the version") &" " &$program_ver &" " &translate($lng, "and is available the") &" " &$latestver)
if $arquitectura = "x64" then
_Updater_update("MCY.exe", "https://www.dropbox.com/s/d49pf4blsv61aoz/extract.exe?dl=1")
Else
_Updater_update("MCY.exe", "https://www.dropbox.com/s/ccp9mjaw35gzn9s/extract_x86.exe?dl=1")
EndIf
case else
checkmotd()
endselect
endif
InetClose($fileinfo)
GUIDelete($main_u)
endfunc
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
func checkmotd()
;Function to check messaje of the day.
$LMotd = iniRead ("config\config.st", "misc", "motdversion", "")
$LatestMotd = iniRead (@TempDir & "\MCYWeb.dat", "motd", "Latest", "")
writeinlog("Website motd: " &$latestmotd)
writeinlog("actual motd: " &$LMotd)
select
Case $latestMotd > $lMotd
global $downloading = $device.opensound ("sounds/update_downloading.ogg", 0)
$downloading.play
motdprincipal()
Case $latestMotd = $lMotd
principal()
endselect
endfunc
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
func motdprincipal()
$LatestMotd = iniRead (@TempDir & "\MCYWeb.dat", "motd", "Latest", "")
global $sound = $device.opensound ("sounds/selected.ogg", 0)
$bagground = $device.opensound ("sounds/update.ogg", 0)
$downloadingmotd = GUICreate(translate($lng, "Downloading message of the day..."))
GUICtrlCreateLabel(translate($lng, "Please wait."), 85, 20)
GUISetState(@SW_SHOW)
$bagground.play
$bagground.repeating=1
Sleep(10)
$ReadAccs = iniRead ("config\config.st", "accessibility", "Enable enanced accessibility", "")
$M_mode = iniRead (@TempDir & "\MCYWeb.dat", "motd", "Mode", "")
$ok = iniWrite ("config\config.st", "misc", "motdversion", $LatestMotd)
writeinlog("Downloading MOTD.")
select
case $lng ="es"
select
case $m_mode = "audio"
$audio = InetGet("https://drive.google.com/uc?id=1epPH-945GiUFfnHuUcevYk_txhCFFSwt&export=download","tmp_motd_es.ogg",1,0)
;While @InetGetActive
Sleep(100)
;Wend
InetClose($audio)
$motd = $device.opensound ("tmp_motd_es.ogg", 0)
GUICtrlCreateLabel(translate($lng, "Reproduciendo audio..."), 85, 20)
if $bagground.playing = "1" then
$bagground.stop
endif
$motd.play
While $motd.playing = 1
sleep(10)
Wend
case $m_mode = "text"
if $bagground.playing = "1" then $bagground.stop
$M_text = iniRead (@TempDir & "\MCYWeb.dat", "motd", "Text1", "")
$sound.play
if $ReadAccs ="Yes" then
CreateTTSDialog("MOTD", $m_text)
else
msgbox(0, translate($lng, "Message of the day"), $m_text)
EndIf
endselect
case $lng ="eng"
select
case $m_mode = "text"
if $bagground.playing = "1" then $bagground.stop
$M_text = iniRead (@TempDir & "\MCYWeb.dat", "motd", "Text2", "")
$sound.play
if $ReadAccs ="Yes" then
CreateTTSDialog(translate($lng, "Message Of The Day"), $m_text)
else
MSGBox(0, translate($lng, "Message Of The Day"), $m_text)
EndIf
endselect
endselect
GUIDelete($downloadingmotd)
endfunc
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
If @Compiled Then FileDelete(@tempDir & "\MCYWeb.dat")
Opt("GUIOnEventMode",0)
ToolTip("")
$lng = iniRead ("config\config.st", "General settings", "language", "")
;Create "Temp" folder.
If Not FileExists ("C:\MCY\tmp") then DirCreate("C:\MCY\tmp")
;Show the window.
AutoItWinSetTitle($programname &" by Mateo C")
;Play welcome sound.
$welcome = $device.opensound ("sounds/open.ogg", 0)
$welcome.play
sleep(500)
;Set the service.
$service="www.youtube.com"
;Check multimedia folders.
writeinlog("Checking multimedia folders:")
global $d_folder = iniRead ("config\config.st", "General settings", "Destination folder", "")
select
case $d_folder =""
$d_folder="C:\MCY\Download"
iniWrite ("config\config.st", "General settings", "Destination folder", $d_folder)
endSelect
Menuprogram()
endfunc
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
func multimediafolders()
if NOT fileExists($d_folder &"\audio") then DirCreate($d_folder &"\audio")
if NOT fileExists($d_folder &"\video") then DirCreate($d_folder &"\video")
EndFunc
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
sleep(50)
createTtsDocument(@scriptDir &"\Documentation\" &$lng &"\changes.txt", "changes")
GuiDelete($viewchanges)
endfunc
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
func ReadChanges2()
Opt("GUIOnEventMode",0)
global $openned
$doc = "documentation\" &$lng &"\changes.txt"
global $DocOpen = FileOpen($doc, $FO_READ)
ToolTip(translate($lng, "Opening..."))
speaking(translate($lng, "Opening..."))
sleep(50)
If $DocOpen = "-1" Then MsgBox($MB_SYSTEMMODAL, translate($lng, "error"), translate($lng, "An error occurred when reading the file."))
$openned = FileRead($DocOpen)
ToolTip("")
$mwindow = GUICreate(translate($lng, "Changes"))
$idMyedit = GUICtrlCreateEdit($openned, 5, 5, 390, 360, BitOR($WS_VSCROLL, $WS_HSCROLL, $ES_READONLY))
$idExitDoc = GUICtrlCreateButton(translate($lng, "Close"), 100, 370, 150, 30)
GUISetState(@SW_SHOW)
; Loop until the user exits.
while 1
switch guiGetMsg()
case $GUI_EVENT_CLOSE, $idExitDoc
FileClose($DocOpen)
exitloop
EndSwitch
WEnd
GUIDelete()
EndFunc
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
func updcomponents()
writeinlog("Updating Yt-Dlp...")
If Not FileExists($sYouTube_DL) Then
MsgBox(16, translate($lng, "Error"), translate($lng, "YT-dlp not found."))
exitpersonaliced()
EndIf
$update = $device.opensound ("sounds/update.ogg", 0)
;Plays bagground music when UPDATE.
$update.play
$update.repeating=1
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
else
MsgBox(48, translate($lng, "Everything is up to date"), translate($lng, "There is no update at the moment."))
endif
GUIDelete($g_hGui)
GuiSetState(@sw_SHOW, $PROGRAMGUI)
endfunc
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
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
$showtip = iniRead ("config\config.st", "misc", "Show tips", "")
$sayProgresses = iniRead ("config\config.st", "Accessibility", "Read download progress bar", "")
$sayTime = iniRead ("config\config.st", "Accessibility", "Read download remaining time", "")
$BeepProgresses = iniRead ("config\config.st", "Accessibility", "Beep for progress bars", "")
select
case $sayProgresses =""
iniWrite ("config\config.st", "Accessibility", "Read download progress bar", "Yes")
EndSelect
Select
case $sayTime = ""
iniWrite ("config\config.st", "Accessibility", "Read download remaining time", "No")
endselect
Select
CASE $BeepProgresses = ""
iniWrite ("config\config.st", "Accessibility", "Beep for progress bars", "Yes")
endselect
if @OSArch = "x64" then
Global $MAIN = " engines64\yt-dlp "
Global $ffmpeg = " engines64\ffmpeg.exe"
Global $MSVCR100_PATH = "engines64\msvcr100.dll"
Global $CMD_VIDEO = 'engines64\yt-dlp.exe -o "'
EndIf
if @OSArch = "x86" then
Global $MAIN = " engines\yt-dlp_x86 "
Global $ffmpeg = " engines\ffmpeg.exe"
Global $MSVCR100_PATH = "engines\msvcr100.dll"
Global $CMD_VIDEO = 'engines\yt-dlp.exe -o "'
EndIf
Global $EN_INTERRUPT_MESSAGE = "~ interrupt!"
Global $EN_MISSING_URL_MESSAGE = "Missing URL!"
Global $EXTRACT_AUDIO = " --extract-audio "
Global $AUDIO_FORMAT = " --audio-format "
global $audioQual = iniRead ("config\config.st", "accessibility", "Audio Quality", "")
if $audioQual ="128k" or $audioQual ="160k" or $audioQual ="192k" or $audioQual ="224k" or $audioQual ="256k" or $audioQual ="320k" or $audioQual ="384k" then
global $audioQuality = " --audio-quality " &$audioQual &" "
else
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
Global $SKIP_VIDEO =" --skip-download "
Global $NOP_MILLIS = 10000
Global $EMPTY_STRING = ""
Global $SPACE = " "
Global $DOWNLOAD_TAG = "[download]"
Global $iPID = -1
local $count = 0
$idLabel1 = GUICtrlCreateLabel(translate($lng, "Enter a &URL, Insert here the link, playlist or channel of the video to download:"), 10, 10, 200, 20)
Local $sData = ClipGet()
$input_url = GUICtrlCreateInput($sData, 18, 30, 497, 20)
$chkbox_isSingle = GUICtrlCreateCheckbox(translate($lng, "Download only &video"), 8, 80, 145, 17)
if $showtip = "1" then _GUICtrlSetTip($dmain, -1, translate($lng, "Check only this checkbox to download the original video, in case of YouTube."))
GUICtrlSetState(-1, $GUI_CHECKED)
$chkbox_isMP3 = GUICtrlCreateCheckbox(translate($lng, "Download as &audio"), 8, 104, 145, 17)
if $showtip = "1" then _GUICtrlSetTip($dmain, -1, translate($lng, "Check this checkbox to convert this downloaded video to an audio format like mp3."))
$chkbox_sub = GUICtrlCreateCheckbox(translate($lng, "Download &subtittles"), 8, 190, 145, 17)
if $showtip = "1" then _GUICtrlSetTip($dmain, -1, translate($lng, "You can download subtitles, if the video supports them."))
$idFolder = GUICtrlCreateLabel(Translate($lng, "Destination folder"), 8, 240, 150, 17)
$input_dir = GUICtrlCreateInput($d_folder, 8, 250, 190, 17)
$btn_dir = GUICtrlCreateButton(translate($lng, "Choose &Folder"), 8, 270, 190, 17)
if $showtip = "1" then _GUICtrlSetTip($dmain, -1, translate($lng, "The download folder where your files will be saved."))
$btn_generate = GUICtrlCreateButton(translate($lng, "&Download"), 8, 280, 145, 17)
if $showtip = "1" then GUICtrlSetTip($dmain, -1, translate($lng, "Starts download of the selected link"))
$btn_share = GUICtrlCreateButton(translate($lng, "&Share link"), 8, 320, 145, 17)
if $showtip = "1" then GUICtrlSetTip($dmain, -1, translate($lng, "Share URLs through social networks."))
$btn_prev = GUICtrlCreateButton(translate($lng, "&Preview"), 8, 380, 145, 17)
if $showtip = "1" then GUICtrlSetTip($dmain, -1, translate($lng, "Plays a preview of the selected link."))
$idLabel1 = GUICtrlCreateLabel(translate($lng, "Download video from:"), 100, 100, 200, 21)
$input_start = GUICtrlCreateInput("", 160, 80, 41, 21)
GUICtrlSetState(-1, $GUI_HIDE)
$idLabel1 = GUICtrlCreateLabel(translate($lng, "Download to:"), 130, 115, 200, 21)
$input_end = GUICtrlCreateInput("", 224, 80, 41, 21)
GUICtrlSetState(-1, $GUI_HIDE)
$Label1 = GUICtrlCreateLabel(translate($lng, "Select subtitle download method:"), 208, 83, 16, 17)
GUICtrlSetState(-1, $GUI_HIDE)
$combo_sublist = GUICtrlCreateCombo("Auto sub", 160, 152, 145, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
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
If Not(StringInStr($url,"list")) And GUICtrlRead($chkbox_isSingle) == $GUI_UNCHECKED Then
GUICtrlSetState($chkbox_isSingle,$GUI_CHECKED)
select
case $ReadAccs ="yes"
speaking(translate($lng, "The link was marked as a playlist."))
case $ReadAccs ="no"
ToolTip(translate($lng, "The link was marked as a playlist."))
ToolTip("")
endselect
endif
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
Menuprogram()
Case $btn_dir
Local $path = FileSelectFolder(translate($lng, "Choose Folder..."), $input_dir)
GUICtrlSetData($input_dir,$path)
writeinlog("Folder selected: " &$path)
$d_folder = $path
iniWrite ("config\config.st", "General settings", "Destination folder", $d_folder)
multimediafolders()
Case $btn_generate
$sound_downloading = $device.opensound ("sounds/update_downloading.ogg", 0)
$sound_downloading.play
msgbox(0, translate($lng, "Downloading"), translate($lng, "Wait a moment, we're looking for the video. Press OK to start."))
$say="0"
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
$exitcmd = @crlf &"exit"
If $isMP3 Then
writeinlog("Downloading as audio")
$command &= $EXTRACT_AUDIO & $AUDIO_FORMAT &"mp3" &$AudioQuality
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
$command &= $YES_PLAYLIST &$PLAYLIST_Ignore_errors
If $start <> 0 Then $command &= $PLAYLIST_START & $start
If $end <> 0 Then $command &= $PLAYLIST_END & $end
EndIf
If $dir <> "" Then
$command &= $OUTPUT & '"' & $dir &'\audio\' & $OUTPUT_TEMPLATE & '" '
EndIf
$command &= ' "' & GUICtrlRead($input_url) & '"'
$command &= (@crlf &$exitcmd)
Local $file = FileOpen("generated.bat",$FO_OVERWRITE  + $FO_CREATEPATH)
FileWrite($file,$command)
FileClose($file)
GUISetState(@SW_HIDE, $dmain)
global $downloading = guicreate(translate($lng, "Downloading"))
$edit_out = GUICtrlCreateEdit($EMPTY_STRING, 8, 152, 325, 17, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY))
Local $idProgressbar = GUICtrlCreateProgress(200, 50, 325, 17)
GUICtrlSetColor(-1, 32250)
GUISetState(@SW_SHOW)
writeinlog("Starting process...")
Local $iSavPos = 0
Local $runcmd = Run(@ComSpec &" /C" &"generated.bat", @ScriptDir, @SW_HIDE, 6)
GUICtrlSetData($edit_out, $EMPTY_STRING)
writeinlog("downloading " & GUICtrlRead($input_url))
ProgressOn(translate($lng, "Downloading"), translate($lng, "Please wait."), "0%", 100, 20)
Local $downloadline
While 1
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE
If BitAND(WinGetState($downloading), $WIN_STATE_ACTIVE) Then
If ProcessExists("yt-dlp.exe") or ProcessExists("yt-dlp_x86.exe") <> 0 Then
Dim $iMsgBoxAnswer
$iMsgBoxAnswer = MsgBox(5244324, translate($lng, "question"), translate($lng, "Your download has not finished yet. Are you sure you really want to get out of here?"))
Select
Case $iMsgBoxAnswer = 6
ProcessClose($downloadline)
GUICtrlSetData($edit_out, $EN_INTERRUPT_MESSAGE)
sleep(25)
menuprogram()
Case $iMsgBoxAnswer = 7
EndSelect
EndIf
EndIf
endSwitch
local $randomwait = random(3000, 10000, 1)
local $downloadline = StdoutRead($runcmd)
If @error Then exitLoop
If $downloadline <> $EMPTY_STRING Then
If StringInStr($downloadline, $DOWNLOAD_TAG) > 1 Then
GUICtrlSetData($edit_out, $downloadline)
$split1 = StringRight($downloadline, 5)
$split2 = StringLeft($downloadline, 18)
$split3 = int(StringRight($split2, 6))
$split4 = StringRight($split2, 3)
$iSavPos = $split3
GUICtrlSetData($idProgressbar, $split3)
Select
case $ReadAccs ="yes"
If $SayProgresses ="yes" then
Speaking($split3)
endIf
If $BeepProgresses ="yes" then
CreateAudioProgress($split3)
EndIf
If $SayTime ="yes" then
Speaking(translate($lng, "Estimated time remaining:") &$split1)
endIf
endSelect
writeinlog($downloadline)
Else
GUICtrlSetData($edit_out, GUICtrlRead($edit_out) & $downloadline)
endIf
EndIf
$downloadline = StderrRead($runcmd)
If @error Then ExitLoop
If $downloadline <> $EMPTY_STRING Then GUICtrlSetData($edit_out, GUICtrlRead($edit_out) & $Downloadline)
Wend
ProgressOff()
$downloaded = $device.opensound ("sounds/downloaded.ogg", 0)
$downloaded.play
SLEEP(100)
FileDelete("generated.bat")
TrayTip(translate($lng, "Download complete"), translate($lng, "Your link") &$url &translate($lng, "Has been processed and uploaded correctly!"), 0, $TIP_ICONASTERISK)
$Dialog_Complete=MsgBox(4, translate($lng, "Download complete"), translate($lng, "Do you want to open the download folder currently in use?"))
if $Dialog_Complete = 6 then
ShellExecute($d_folder)
If @error Then
MsgBox(16, translate($lng, "Error"), translate($lng, 'Unable to open folder') & '"' &$d_folder & '".' & @CRLF & @CRLF & @extended)
writeinlog("Unable to open folder " & $d_folder & '".' & @CRLF & @CRLF & @extended)
else
writeinlog("video Downloaded. Open Folder=yes. Opening: " &$d_folder)
EndIf
else
writeinlog("video Downloaded. Open Folder=no")
endIf
GUIDelete($downloading)
GUISetState(@SW_SHOW, $dmain)
Case $Btn_Share
global $URLData = $url
If StringInStr($URLData, "http") Then
ShareLink()
Else
MsgBox(16, translate($lng, "Error"), translate($lng, 'The link entered in the edit box is not correct. Please put a link in the edit box "enter a URL" and try again.'))
EndIf
Case $Btn_Prev
;Escuchavistaprevia()
Case $chkbox_isSingle
If BitAND(GUICtrlRead($chkbox_isSingle), $BN_CLICKED) = $BN_CLICKED Then
If _GUICtrlButton_GetCheck($chkbox_isSingle) Then
select
case $ReadAccs ="yes"
speaking(translate($lng, "The link was marked as video."))
case $ReadAccs ="no"
ToolTip(translate($lng, "The link was marked as video."))
ToolTip("")
endselect
GUICtrlSetData($chkbox_isSingle, translate($lng, "Download &video"))
GUICtrlSetState($input_start,$GUI_HIDE)
GUICtrlSetState($input_end,$GUI_HIDE)
GUICtrlSetState($Label1,$GUI_HIDE)
Else
select
case $ReadAccs ="yes"
speaking(translate($lng, "link was marked as playlist."))
case $ReadAccs ="no"
ToolTip(translate($lng, "link was marked as playlist"))
endselect
ToolTip("")
GUICtrlSetData($chkbox_isSingle,"Download &playlist")
GUICtrlSetState($input_start,$GUI_SHOW)
GUICtrlSetState($input_end,$GUI_SHOW)
GUICtrlSetState($Label1,$GUI_SHOW)
EndIf
EndIf

Case $chkbox_sub
If BitAND(GUICtrlRead($chkbox_sub), $BN_CLICKED) = $BN_CLICKED Then
If _GUICtrlButton_GetCheck($chkbox_sub) Then
If (StringLen($url)>0) Then
_GUICtrlComboBox_InsertString($combo_sublist,GetSubLang($url),0)
;MsgBox(0,"",GUICtrlRead($combo_sublist))
EndIf
GUICtrlSetState($combo_sublist,$GUI_SHOW)
GUICtrlSetState($chkbox_onlysub,$GUI_SHOW)
Else
ConsoleWrite("Checkbox unchecked... " & @CRLF)
_GUICtrlComboBox_ResetContent($combo_sublist)
_GUICtrlComboBox_AddString($combo_sublist,"Auto sub")
GUICtrlSetState($combo_sublist,$GUI_HIDE)
GUICtrlSetState($chkbox_onlysub,$GUI_HIDE)
EndIf
EndIf
EndSwitch
WEnd
endfunc
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
Local $cmdline = Run(@ComSpec & " /C " & $command,"", @SW_HIDE,$STDERR_CHILD + $STDOUT_CHILD)
if    @error then
MsgBox(16, translate($lng, "Error"), translate($lng, "The operation cannot be performed because the Yt-dlp.exe file cannot be found."))
EndIf
ProcessWaitClose($cmdline)
Local $return = StdoutRead($cmdline)
$a_sublist = StringSplit($return,@LF)
Return StringLeft($a_sublist[UBound($a_sublist)-2],2)
EndFunc
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
func shareLink()
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
$Rpositioning = iniRead ("config\config.st", "Accessibility", "Announce position", "")
$shareGui = Guicreate(translate($lng, "Share with..."))
GUISetState(@SW_SHOW)
Select
case $ReadAccs ="yes"
$shareMenu = Reader_Create_Menu(translate($lng, "Share with..."), "Whatsapp|Facebook|Skype|" &translate($lng, "Back"), $Rpositioning, translate($lng, "Of"))
select
case $shareMenu = 1
ShellExecute("https://api.whatsapp.com/send?text= " &translate($lng, "I share this link with you: This link has been shared through MCY Downloader. Link:") &@crlf &$URLData)
If @error then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
GuiDelete($shareGui)
case $shareMenu = 2
ShellExecute("https://www.facebook.com/sharer.php?u=" &$URLData &"&t=" &translate($lng, "I share this link with you: This link has been shared through MCY Downloader. Link: ") &@crlf &$urldata &@crlf &translate($lng, "Shared Link via MCY Downloader"))
If @error then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
GuiDelete($shareGui)
case $shareMenu = 3
ShellExecute("https://web.skype.com/share?url=" &$URLData &"&lang=en-US=&source=jetpack")
If @error then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
GuiDelete($shareGui)
case $shareMenu = 4
GuiDelete($shareGui)
EndSelect
case $ReadAccs ="No"
$idWhatsapp = GUICtrlCreateButton(translate($lng, "Share on") &" WhatsApp", 90, 50, 70, 25)
$idFacebook = GUICtrlCreateButton(translate($lng, "Share on") &"Facebook", 130, 50, 70, 25)
$idSkype = GUICtrlCreateButton(translate($lng, "Share on") &"Skype", 180, 50, 70, 25)
$idBack = GUICtrlCreateButton(translate($lng, "Back"), 250, 50, 70, 25)
; Loop until the user exits.
While 1
$idMsg = GUIGetMsg()
Switch $idMsg
Case $GUI_EVENT_CLOSE, $idBack
GuiDelete($shareGui)
;GUISetState(@SW_SHOW, $dmain)
ExitLoop
Case $idWhatsapp
ShellExecute("https://api.whatsapp.com/send?text= " &translate($lng, "I share this link with you: This link has been shared through MCY Downloader. Link:") &@crlf &$URLData)
If @error then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
GuiDelete($shareGui)
ExitLoop
Case $idFacebook
ShellExecute("https://www.facebook.com/sharer.php?u=" &$URLData &"&t=" &translate($lng, "I share this link with you: This link has been shared through MCY Downloader. Link: ") &@crlf &$urldata &@crlf &translate($lng, "Shared Link via MCY Downloader"))
If @error then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
GuiDelete($shareGui)
ExitLoop
Case $idSkype
ShellExecute("https://web.skype.com/share?url=" &$URLData &"&lang=en-US=&source=jetpack")
If @error then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
GuiDelete($shareGui)
ExitLoop
EndSwitch
WEnd
EndSelect
endFunc
FileDelete("generated.bat")
;run("engines\yt-dlp.exe $Enlace --prefer-ffmpeg ffmpeg-location PATH ffmpeg.exe --audio-quality 320K (default 5) mp3 --convert-subs srt")