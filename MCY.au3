;Begining off script. Comienzo del script.
; Defining the version number, and program info. definiendo el número de versión del programa e información del mismo.
; #pragma compile(Icon, C:\Program Files\AutoIt3\Icons\au3.ico)
#pragma compile(Compression, 2)
#pragma compile(UPX, False)
#pragma compile(FileDescription, Music YouTube Downloader)
#pragma compile(ProductName, Music YouTube Downloader)
#pragma compile(ProductVersion, 0.8.0.0)
#pragma compile(FileVersion, 0.8.0.0, 0.8.0.0)
#pragma compile(LegalCopyright, © 2018-2021 MT Programs, All rights reserved)
#pragma compile(CompanyName, 'MT Programs')
;Including program scripts: Incluyendo scripts para el programa:
#include <Array.au3>;
#include <AutoItConstants.au3>;
#include <new\audio.au3>
;#include <new\Base64.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#Include<file.au3>
#include <new\functions.au3>
#include <GUIConstantsEx.au3>
;#include <GuiTreeView.au3>;exclude
#include <GuiButton.au3>
#include <GuiComboBox.au3>
#include <InetConstants.au3>;
#include <new\mergefiles_utf16le_v2.au3>
#include <new\kbc.au3>
#include "new\log.au3"
#include <new\menu.au3>
#include <new\menu_nvda.au3>
#include <MsgBoxConstants.au3>
#include <new\NVDAControllerClient.au3>
#include <new\reader.au3>
#Include <new\sapi.au3>
#include <new\say_UDF.au3>
#include <SendMessage.au3>;
#include <StaticConstants.au3>
#include <String.au3>
#include <TrayConstants.au3>
;#include <WinAPIDiag.au3>;exclude
;#include <WinAPIDlg.au3>;exclude
;#include <WinAPIFiles.au3>;exclude
;#include <WinAPISys.au3>;exclude
;#include <WinAPIShellEx.au3>
#include <WindowsConstants.au3>
#include <new\zip.au3>
;Install files: Instalar archivos:
;FileInstall("extractor.exe", @ScriptDir & "/extractor.exe")
;FileInstall("MailSend.exe", @ScriptDir & "/MailSend.exe")
;Extracting package of sounds: Extrayendo paquete de sonidos:
;Creates a window wenn the program is loading: Crea una ventana mientras el programa se está cargando:
$l1 = GUICreate("Loading...")
GUISetState(@SW_SHOW)
sleep(100)
writeinlog("Initialicing...")
sleep(100)
If not FileExists("MCY.au3") Then
writeinlog("Extracting sounds.")
sleep(100)
Extractor()
else
writeinlog("Comprovando arquitectura: ")
sleep(100)
comprovarArc()
endif
Func Extractor()
GUICtrlCreateLabel("Extracting sounds... Extrayendo sonidos...", 40, 20)
Local $zip_carpeta = @ScriptDir & '\soundsdata.dat.zip'
If FileExists("sounds\*.ogg") then
if @compiled then
msgbox (4096, "error", "Damn thief, stop stealing the sounds!")
exit
EndIf
comprovarArc()
endif
If FileExists($zip_carpeta) Then
_Zip_UnzipAll($zip_Carpeta, @ScriptDir, 0)
sleep(100)
GUIDelete($l1)
comprovarArc()
else
writeinlog("Warning! Error Copying the sounds.")
MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR, "Fatal error", "Could not extract sounds.")
exit
endIf
GUIDelete($l1)
EndFunc
func comprovarArc()
$developermode= "1"
if @ProcessorArch = "x64" then
DirCreate("config")
IniWrite("config\config.st", "General settings", "Architecture", "acceptable")
;IniWrite("config\config.st", "misc", "motdversion", "0")
writeinlog("Checking architecture: Architecture is 64 bit.")
GUIDelete($l1)
endif
if @ProcessorArch = "x86" then
writeinlog("Warning! The architecture is not acceptable.")
MsgBox(0, "Error!", "tu arquitectura es de 32 bits y por lo tanto no está soportada en este programa. Ten en cuenta que el soporte para 32 bits terminó el 27 de mayo de 2020.")
exitpersonaliced()
endif
select
case $developermode = 1
writeinlog("Checkingprogram copy...")
checkcopy()
case $developermode = 0
writeinlog("The program is not compiled. Exiting...")
NotCompiled()
EndSelect
EndFunc
func checkcopy()
;Para saber de dónde se está ejecutando la copia:
if @scriptDir ="C:\Program Files (x86)\MCY" then
IniWrite("config\config.st", "General settings", "Program Type", "Installable")
writeinlog("Copy: Installable.")
else
IniWrite("config\config.st", "General settings", "Program Type", "Portable")
writeinlog("Copy: Portable.")
endif
firstlaunch()
endfunc
func firstlaunch()
$accessibility = iniRead ("config\config.st", "accessibility", "Enable enanced accessibility", "")
select
case $accessibility ="Yes"
checkselector()
case $accessibility ="No"
checkselector()
Case Else
configure()
endselect
endfunc
func exitpersonaliced()
$delfiles = "1"
;This custom exit function is used to delete some files when exiting the program. 0 for disabled, 1 enabled (by default it is disabled for all general users). Esta función personalizada de salir, sirve para eliminar algunos archivos cuando se sale del programa. 0 para deshavilitado, 1 havilitado (por defecto está havilitado para todos los usuarios en general)
select
case $delfiles = 1
writeinlog("exiting...")
$soundclose = $device.opensound ("sounds\soundsdata.dat\close.ogg", 0)
$soundclose.play
sleep(2000)
FileDelete("extractor.exe")
;FileDelete("MailSend.exe")
FileDelete("MCYWeb.dat")
;FileDelete("tmp_motd_es.ogg")
writeinlog("removing files...")
DirRemove(@ScriptDir & "/sounds", 1)
sleep(1000)
exit
case $delfiles = 0
writeinlog("exiting...")
$soundclose = $device.opensound ("sounds\soundsdata.dat\close.ogg", 0)
$soundclose.play
sleep(1500)
exit
endselect
endfunc
;La siguiente pregunta es para activar la accesibilidad mejorada, hecha exclusiba y únicamente para las personas con discapacidad. The next question is to activate the improved accessibility, made exclusively and only for people with disability.
func configure()
writeinlog("Launching at first time.")
$s_selected = $device.opensound ("sounds\soundsdata.dat\selected.ogg", 0)
select
case @OSLang = "0c0a" or @OSLang = "040a" or @OSLang = "080a" or @OSLang = "100a" or @OSLang = "140a" or @OSLang = "180a" or @OSLang = "1c0a" or @OSLang = "200a" or @OSLang = "240a" or @OSLang = "280a"
$Warning=MsgBox(4, "Activar accesibilidad mejorada?", "La accesibilidad mejorada está diseñada para las personas con discapacidad visual, en lo cual la mayoría de la interfaz del programa se podrá usar mediante voz y atajos de teclas. ¿Activar?")
case @OSLang = "2c0a"
$Warning=MsgBox(4, "Activar accesibilidad mejorada?", "esta nueva funcionalidad de La accesibilidad mejorada está diseñada para las personas con discapacidad visual, en lo cual la mayoría de la interfaz del programa se podrá usar mediante voz y atajos de teclas. ¿Activar?")
case @OSLang = "300a"
$Warning=MsgBox(4, "Querés activar la accesibilidad mejorada?", "esta nueva función está diseñada para las personas con discapacidad visual, en lo cual la mayoría de la interfaz del programa se podrá usar mediante voz y atajos de teclado. ¿Continuar?")
case @OSLang = "340a" or @OSLang = "380a" or @OSLang = "3c0a" or @OSLang = "400a" or @OSLang = "440a" or @OSLang = "480a" or @OSLang = "4c0a" or @OSLang = "500a"
$Warning=MsgBox(4, "Activar accesibilidad mejorada?", "esta nueva funcionalidad de La accesibilidad mejorada está diseñada para las personas con discapacidad visual, en lo cual la mayoría de la interfaz del programa se podrá usar mediante voz y atajos de teclas. ¿Activar?")
;English languages: Idiomas para inglés:
case @OSLang = "0809" or @OSLang = "0c09" or @OSLang = "1009" or @OSLang = "1409" or @OSLang = "1809" or @OSLang = "1c09" or @OSLang = "2009" or @OSLang = "2409" or @OSLang = "2809" or @OSLang = "2c09" or @OSLang = "3009" or @OSLang = "3409" or @OSLang = "0425"
$Warning=MsgBox(4, "Enable enanced accessibility?", "This new Enhanced Accessibility functionality is designed for the visually impaired, in which most of the program interface can be used by voice and keyboard shortcuts. Activate?")
case else
$Warning=MsgBox(4, "Enable enanced accessibility?", "This new Enhanced Accessibility functionality is designed for the visually impaired, in which most of the program interface can be used by voice and keyboard shortcuts. Activate?")
endselect
;end
 if $warning == 6 then
IniWrite("config\config.st", "accessibility", "Enable enanced accessibility", "Yes")
writeinlog("Enanced accesibility: Yes.")
$s_selected.play
sleep(100)
checkselector()
else
IniWrite("config\config.st", "accessibility", "Enable enanced accessibility", "No")
writeinlog("Enanced accesibility: No.")
$s_selected.play
sleep(100)
checkselector()
endif
endfunc
func checkselector()
$sLanguage = iniRead ("config\config.st", "General settings", "language", "")
select
case $sLanguage ="es"
checkupd()
case $sLanguage ="eng"
checkupd()
Case Else
selector()
endselect
endfunc
func sistemlang()
Switch StringRight(@OSLang, 2)
Case "09"
Return "English"
IniWrite("config\config.st", "General settings", "WindowsLanguage","English")
Case "0a"
IniWrite("config\config.st", "General settings", "WindowsLanguage","Spanish")
Return "Spanish"
Case Else
IniWrite("config\config.st", "General settings", "WindowsLanguage","unknown")
Return "unknown"
EndSwitch
endfunc
sistemlang()
;This is the function off language selector menu, the first alternative using the main menu speech. Esta es la función de menú de selección de idioma, la primera alternativa que utiliza el menú principal de voz.
Func Selector()
$sl_selected = $device.opensound ("sounds\soundsdata.dat\selected.ogg", 0)
$mainmenu = $device.opensound ("sounds\soundsdata.dat\menumusic.ogg", 0)
$mainmenu.volume=0.50
$mainmenu.play
$mainmenu.repeating=1
local $widthCell,$msg,$iOldOpt
$langGUI= GUICreate("Please select a language... Por favor, selecciona un idioma.")
$widthCell=70
$iOldOpt=Opt("GUICoordMode",$iOldOpt)
GUICtrlCreateLabel("Select a language with up and down arrows. Too you can also touch the context menu to do so.", 30, 50,$widthCell)
GUICtrlCreateLabel("Selecciona un idioma con las flechas arriba y abajo, o, si eres una persona con visión, también puedes tocar el menú contextual para hacerlo.",-1,0)
GUISetBkColor(0x00E0FFFF)
GUISetState(@SW_SHOW)
$configureaccs = iniRead ("config\config.st", "accessibility", "Enable enanced accessibility", "")
if $configureaccs ="yes" then
$windowslanguage= @OSLang
;Spanish languages: Idiomas en español:
select
case $windowslanguage = "0c0a" or $windowslanguage = "040a" or $windowslanguage = "080a" or $windowslanguage = "100a" or $windowslanguage = "140a" or $windowslanguage = "180a" or $windowslanguage = "1c0a" or $windowslanguage = "200a" or $windowslanguage = "240a" or $windowslanguage = "280a" or $windowslanguage = "2c0a" or $windowslanguage = "300a" or $windowslanguage = "340a" or $windowslanguage = "380a" or $windowslanguage = "3c0a" or $windowslanguage = "400a" or $windowslanguage = "440a" or $windowslanguage = "480a" or $windowslanguage = "4c0a" or $windowslanguage = "500a"
$menu=Create_Audio_Menu("sounds/soundsdata.dat/langselect.ogg", "sounds/soundsdata.dat/es.ogg,sounds/soundsdata.dat/eng.ogg,sounds/soundsdata.dat/exit1.ogg")
;English languages: Idiomas para inglés:
case $windowslanguage = "0809" or $windowslanguage = "0c09" or $windowslanguage = "1009" or $windowslanguage = "1409" or $windowslanguage = "1809" or $windowslanguage = "1c09" or $windowslanguage = "2009" or $windowslanguage = "2409" or $windowslanguage = "2809" or $windowslanguage = "2c09" or $windowslanguage = "3009" or $windowslanguage = "3409" or $windowslanguage = "0425" or 
$menu=Create_Audio_Menu("sounds/soundsdata.dat/langselect2.ogg", "sounds/soundsdata.dat/es2.ogg,sounds/soundsdata.dat/eng2.ogg,sounds/soundsdata.dat/exit2.ogg")
;end selection off languages. Fin de selección/detección de idiomas.
case else
$menu=Create_Audio_Menu("sounds/soundsdata.dat/langselect2.ogg", "sounds/soundsdata.dat/es2.ogg,sounds/soundsdata.dat/eng2.ogg,sounds/soundsdata.dat/exit2.ogg")
endselect
endif
if $configureaccs ="no" then
Local $idSpanish = GUICtrlCreateButton("Spanish", 90, 50, 70, 25)
Local $idEnglish = GUICtrlCreateButton("English", 120, 50, 70, 25)
Local $idBtn_Close = GUICtrlCreateButton("Close", 180, 50, 70, 30)
endif
if $configureaccs ="yes" then
select
case $menu = 1
$sl_selected.play
IniWrite("config\config.st", "General settings", "language", "es")
$language="1"
sleep(100)
$mainmenu.stop
GUIDelete($langGUI)
checkupd()
case $menu = 2
$sl_selected.play
IniWrite ("config\config.st", "General settings", "language", "eng")
$language="2"
sleep(100)
$mainmenu.stop
GUIDelete($langGUI)
checkupd()
case $menu = 3
$sl_selected.play
sleep(100)
$mainmenu.stop
exitpersonaliced()
EndSelect
endif
if $configureaccs ="no" then
; Loop until the user exits.
While 1
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE, $idBtn_Close
exitpersonaliced()
Case $idSpanish
$sl_selected.play
IniWrite("config\config.st", "General settings", "language", "es")
$language="1"
sleep(100)
$mainmenu.stop
GUIDelete($langGui)
checkupd()
exitloop
Case $idEnglish
$sl_selected.play
IniWrite("config\config.st", "General settings", "language", "es")
$language="1"
sleep(100)
$mainmenu.stop
GUIDelete($langGui)
checkuppd()
exitloop
EndSwitch
WEnd
endif
EndFunc
func checkupd()
$main_u = GUICreate("MCY Downloader. Checking version...")
GUISetState(@SW_SHOW)
sleep(100)
checkmcyversion()
checksoundsversion()
GUIDelete($main_u)
endfunc
func checKmcyversion()
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
$sLanguage = iniRead ("config\config.st", "General settings", "language", "")
writeinlog("Checking for updates...")
Local $yourexeversion = FileGetVersion("MCY.exe")
Local $updaterexe = FileGetVersion("updater.exe")
select
case $sLanguage ="es"
$newversion=" Tienes la "
$newversion2=", y está disponible la "
case $sLanguage ="eng"
$newversion=" You have the version "
$newversion2=", And is available the "
endselect
$fileinfo = InetGet("https://www.dropbox.com/s/hcx20lgvjem0wz1/MCYWeb.dat?dl=1", "MCYWeb.dat")
;$file_down = FileOpen("MCYWeb.dat")
FileCopy("MCYWeb.dat", @TempDir & "\MCYWeb.dat")
$latestver = iniRead (@TempDir & "\MCYWeb.dat", "updater", "LatestVersion", "")
$latestUpd = iniRead (@TempDir & "\MCYWeb.dat", "updater", "Updater.exe", "")
select
Case $latestUpd > $updaterexe
writeinlog("Warning! Update engine available. Your version:" &$updaterexe & ". New version:" & $latestUpd)
sleep(100)
$downloadupdater = InetGet("https://www.dropbox.com/s/qb50lme5hvvy3kl/updater.exe?dl=1","updater.exe",1,0)
Case else
writeinlog("checking program updates...")
endselect
if $sLanguage ="Es" then
if $ReadAccs ="Yes" then
select
Case $latestVer > $yourexeversion
writeinlog("Warning! Update available. Your version:" &$yourexeversion & ". New version:" & $latestver)
TTSDialog("actualización disponible! " &$newversion &$yourexeversion &$newversion2 &$latestver& ". Presiona enter para descargar.")
sleep(250)
RunUpdater()
Case else
checkmotd()
endselect
endif
endif
if $sLanguage ="Eng" then
select
Case $latestVer > $yourexeversion
writeinlog("Warning! Update available. Your version:" &$yourexeversion & ". New version:" & latestver)
TTSDialog("update available! " &$newversion &$yourexeversion &$newversion2 &$latestver& ". Press enter to download.")
RunUpdater
case else
checkmotd()
endselect
endif
if $ReadAccs ="No" then
if $sLanguage ="Es" then
select
Case $latestVer > $yourexeversion
$result= ($newversion &$yourexeversion &$newversion2 &$latestver)
writeinlog($result)
msgbox(0, "actualización disponible!", $result)
runUpdater()
case else
checkmotd()
endselect
endif
endif
if $sLanguage ="Eng" then
select
Case $latestVer > $yourexeversion
$result= ($newversion &$yourexeversion &$newversion2 &$latestver)
writeinlog($result)
msgbox(0, "update available!", $result)
RunUpdater()
case else
checkmotd()
endselect
endif
InetClose($fileinfo)
endfunc
Func RunUpdater()
$access = iniRead ("config\config.st", "accessibility", "Enable enanced accessibility", "")
$Lang = iniRead ("config\config.st", "General settings", "language", "")
if not IsAdmin() Then
writeinlog("Warning! To install update, require admin.")
MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR, "Error", "To install this update, you must run the program as an administrator.")
exitpersonaliced()
endif
if FileExists("updater.exe") then
Local $iReturn = RunWait("updater.exe /download_update")
Else
writeinlog("Warning! Ops... Updater.exe not found.")
select
case $access ="yes"
$error = $device.opensound ("sounds\soundsdata.dat\error2.ogg", 0)
$error.play
sleep(100)
select
case $Lang ="Es"
speaking("Updater.exe no encontrado")
case $Lang ="Eng"
speaking("Updater.exe not found")
endselect
case $access ="no"
select
case $Lang ="Es"
msgbox(0, "Error", "Updater.exe no se ha encontrado.")
case $Lang ="Es"
msgbox(0, "Error", "Updater.exe was not found.")
endselect
endselect
endif
endfunc
func checksoundsversion()
$yoursoundsversion = iniRead ("sounds\soundsdata.dat\version.ini", "version", "actual", "")
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
$sLanguage = iniRead ("config\config.st", "General settings", "language", "")
select
case $sLanguage ="es"
$newversion=" Tienes la "
$newversion2=", y está disponible la "
case $sLanguage ="eng"
$newversion=" You have the version "
$newversion2=", And is available the "
endselect
$latestsounds = iniRead (@TempDir & "\MCYWeb.dat", "updater", "soundsversion", "")
if $sLanguage ="Es" then
if $ReadAccs ="Yes" then
select
Case $latestsounds > $yoursoundsversion
writeinlog("Sounds update available. Your Version: " & $yoursoundsversion & ". Acctual: " & $latestsounds)
speaking("actualización de sonidos disponible." & $newversion & $yoursoundsversion & $newversion2 & $latestsounds & ". Un momento, por favor.")
SUpdate()
endselect
endif
endif
if $sLanguage ="Eng" then
select
Case $latestsounds > $yoursoundsversion
writeinlog("Sounds update available. Your Version: " & $yoursoundsversion & ". Acctual: " & $latestsounds)
speaking("Sounds update available." & $newversion & $yoursoundsversion & $newversion2 & $latestsounds & ". Downloading...")
SUpdate()
endselect
endif
if $ReadAccs ="No" then
if $sLanguage ="Es" then
select
Case $latestsounds > $yoursoundsversion
;$result= ($newversion &$yoursoundsversion &$newversion2 &$latestsounds)
writeinlog($result)
msgbox(0, "actualización de sonidos disponible!", $result)
SUpdate()
endselect
endif
endif
if $sLanguage ="Eng" then
select
Case $latestsounds > $yoursoundsversion
;$result= ($newversion &$yoursoundsversion &$newversion2 &$latestsounds)
writeinlog($result)
msgbox(0, "Sounds update available!", $result)
SUpdate()
endselect
endif
If @Compiled Then
FileDelete("MCYWeb.dat")
endif
endfunc
Func SUpdate()
run("updater.exe download_sounds")
sleep(100)
endfunc
func checkmotd()
;Function to check messaje of the day.
$LMotd = iniRead ("config\config.st", "misc", "motdversion", "")
;GUIDelete($main_u)
$fileinfo = InetGet("https://www.dropbox.com/s/hcx20lgvjem0wz1/MCYWeb.dat?dl=1", "MCYWeb.dat")
FileCopy("MCYWeb.dat", @TempDir & "\MCYWeb.dat")
$LatestMotd = iniRead (@TempDir & "\MCYWeb.dat", "motd", "Latest", "")
writeinlog("Website motd: " &$latestmotd)
writeinlog("actual motd: " &$LMotd)
select
Case $latestMotd > $lMotd
$downloading = $device.opensound ("sounds\soundsdata.dat\update_downloading1.ogg", 0)
$downloading.play
motdprincipal()
Case $latestMotd = $lMotd
principal()
Case else
principal()
endselect
InetClose($fileinfo)
endfunc
func motdprincipal()
$LatestMotd = iniRead (@TempDir & "\MCYWeb.dat", "motd", "Latest", "")
$bagground = $device.opensound ("sounds\soundsdata.dat\update.ogg", 0)
$downloadingmotd = GUICreate("Descargando mensaje del día...")
GUICtrlCreateLabel("Espera, por favor.", 85, 20)
GUISetState(@SW_SHOW)
$bagground.play
$bagground.repeating=1
Sleep(150)
$grlanguage = iniRead ("config\config.st", "General settings", "language", "")
$M_mode = iniRead (@TempDir & "\MCYWeb.dat", "motd", "Mode", "")
$ok = iniWrite ("config\config.st", "misc", "motdversion", $LatestMotd)
writeinlog("Downloading MOTD.")
select
case $grlanguage ="es"
select
case $m_mode = "audio"
$audio = InetGet("https://drive.google.com/uc?id=1epPH-945GiUFfnHuUcevYk_txhCFFSwt&export=download","tmp_motd_es.ogg",1,0)
While @InetGetActive
TrayTip("Descargando mensaje del día...","Bytes = "& @InetGetBytesRead,10,16)
Sleep(100)
Wend
InetClose($audio)
$motd = $device.opensound ("tmp_motd_es.ogg", 0)
GUICtrlCreateLabel("Reproduciendo audio...", 85, 20)
if $bagground.playing == "1" then
$bagground.stop
endif
$motd.play
;GUIDelete($downloadingmotd)
principal()
case $m_mode = "text"
if $bagground.playing == "1" then
$bagground.stop
endif
$M_text = iniRead (@TempDir & "\MCYWeb.dat", "motd", "Text1", "")
$sound = $device.opensound ("sounds\soundsdata.dat\selected.ogg", 0)
$sound.play
TTSDialog($m_text)
endselect
case $grlanguage ="eng"
select
case $m_mode = "text"
if $bagground.playing == "1" then
$bagground.stop
endif
$M_text = iniRead (@TempDir & "\MCYWeb.dat", "motd", "Text2", "")
$sound = $device.opensound ("sounds\soundsdata.dat\selected.ogg", 0)
$sound.play
TTSDialog($m_text)
endselect
endselect
GUIDelete($downloadingmotd)
endfunc
Func Principal()
;Create "Temp" folder. Creando carpeta "temp"
DirCreate("C:\Program Files (x86)\MCY\tmp")
;Show the window. Mostrar la ventana.
AutoItWinSetTitle("Descargador de músicas de YouTube, por Mateo Cedillo")
;Play welcome sound. Reproducir sonido de bienvenida.
$welcome = $device.opensound ("sounds\soundsdata.dat\open.ogg", 0)
$welcome.play
sleep(800)
endfunc
$grlanguage = iniRead ("config\config.st", "General settings", "language", "")
;Set version number. Estableciendo el número de versión.
select
case $grlanguage ="es"
$version="versión 0.8.0 beta"
case $grlanguage ="eng"
$version="version 0.8.0 beta"
endselect
;Set the service. Estableciendo el servicio.
$service="www.youtube.com"
;greetings. Saludo/bienvenida.
select
case $grlanguage ="es"
$greeting="Saludos "
$yourname= @username &", "
$welcomemessage="Y Bienvenido a MCY downloader, "
case $grlanguage ="eng"
$greeting="Greetings "
$yourname= @username &", "
$welcomemessage="And welcome to MCY downloader, "
endSelect
Func Variables()
$result= ($greeting &$yourname &$welcomemessage &$version)
writeinlog("Welcome! " & $result)
select
case $grlanguage ="es"
MsgBox(0, "te damos la bienvenida", $result)
case $grlanguage ="eng"
MsgBox(0, "Welcome", $result)
endselect
endfunc
;Show dialog. Mostrar el diálogo.
$confirmation="2"
select
case $confirmation = 1
Saludo()
case $confirmation = 2
Variables()
endselect
Func Saludo()
select
case $grlanguage ="es"
$messagea="buenas madrugadas, te damos la bienvenida"
$messageb="buenos días, te damos la bienvenida"
$messagec="buenas tardes, te damos la bienvenida"
$messaged="buenas noches, te damos la bienvenida"
$Messagee="buenas tardísimas, te damos la bienvenida"
case $grlanguage ="eng"
$messagea="good morning, we welcome you."
$messageb="good morning, we welcome you."
$messagec="good afternoon, we welcome you."
$messaged="good night, we welcome you"
$Messagee="good afternoon, we welcome you"
endselect
$buenas=@hour
Switch @HOUR
Case 0 To 5
msgbox(0, "MCY downloader...", $messagea &$result)
Case 6 To 11
msgbox(0, "Good morning", $messageb &$result)
Case 12 To 14
msgbox(0, "MCY downloader", $messagec &$result)
Case 18 To 21
msgbox(0, "Good night", $messaged &$result)
Case 22 To 23
msgbox(0, "Welcome", $messagee &$result)
Case Else
msgbox(0, "MCY Downloader", "welcome to MCY downloader")
EndSwitch
endfunc
;orijinal 
;Creating multimedia folders. Creando carpetas multimedia.
writeinlog("Creating multimedia folders:")
DirCreate("C:\MCY\download\audio")
DirCreate("C:\MCY\download\video")
Menuprogram()
Func Readchanges()
$leercambios = InetGet("https://drive.google.com/uc?id=1cqgiKqYr_z2Ho5Rye3SBbDbT2Y_vkAhK&export=download","changes1.txt",1,1)
While @InetGetActive
TrayTip("Descargando cambios...","Bytes = "& @InetGetBytesRead,10,16)
Sleep(200)
Wend
Local $hForm = GUICreate('Changes ' & StringReplace(@ScriptName, '.au3', '()'), 200, 200, 10, 20, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX), $WS_EX_TOPMOST)
Global $g_idEdit = GUICtrlCreateEdit('', 50, 50, 100, 100, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY))
GUIRegisterMsg($file, 'line')
GUISetState(@SW_SHOW)
_SendMessage($file, $line)
endfunc
func updcomponents()
$update = $device.opensound ("sounds\soundsdata.dat\update.ogg", 0)
;Plays the music wen downloading YouTubeDl updatte. Reproduce la música mientras se descarga la actualización de YouTubeDl.
$update.play
$update.repeating=1
Global $g_hGui, $g_aGuiPos
select
case $grlanguage ="es"
$g_hGui = GUICreate("Buscando actualización de YouTubeDl, esto puede tardar un momento", 250, 120)
case $grlanguage ="eng"
$g_hGui = GUICreate("Looking for YouTubeDl update, this may take a moment", 250, 120)
endselect
$g_hPic = GUICreate("", 80, 50, 25, 30, $WS_POPUp, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $g_hGui)
GUICtrlCreatePic("..\logo.gif", 0, 0, 0, 0)
GUISetState(@SW_SHOW, $g_hGui)
$g_aGuiPos = WinGetPos($g_hGui)
writeinlog("Updating Youtube Dl...")
select
case $grlanguage ="es"
$updatelabel = GUICtrlCreateLabel("Buscando actualizaciones...", 25, 16)
GUICtrlSetTip(-1, "Por favor espera...")
ToolTip("Buscando actualizaciones para la librería YouTubeDl, esto puede llevar un tiempo. Por favor esperar...")
TrayTip("Por favor espera", "Espera mientras se está buscando la actualización de la librería de YouTube", 0, $TIP_ICONASTERISK)
case $grlanguage ="eng"
$updatelabel = GUICtrlCreateLabel("Looking for updates...", 25, 16)
GUICtrlSetTip(-1, "Please wait...")
ToolTip("Looking for updates to the YouTubeDl library, this may take a while. Please wait...")
TrayTip("Please wait", "Please wait while the YouTube library update is being searched.", 0, $TIP_ICONASTERISK)
endselect
sleep(100)
$iReturn = RunWait("engines\youtube-dl-.exe -U")
If ProcessExists("youtube-dl-.exe") Then
$updatelabel = GUICtrlCreateLabel("¡Updated!", 40, 20)
Else
$update.stop
GUIDelete($g_hGui)
MENUPROGRAM()
endif
endfunc
Func Imputdownload()
say()
select
case $grlanguage ="es"
$dmain = GUICreate("Descargar en MP3...")
$connectingmsg="conectando con internet..."
$errormsg="No tienes conexión a internet!"
case $grlanguage ="eng"
$dmain = GUICreate("Download in MP3...")
$connectingmsg="connecting to internet..."
$errormsg="¡You don't have an internet connection!"
endselect
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
Global Const $MAIN = " engines\youtube-dl- "
Global Const $ffmpeg = " engines\ffmpeg.exe"
Global Const $MSVCR100_PATH = "engines\msvcr100.dll"
Global Const $CMD_VIDEO = 'engines\youtube-dl-.exe -o "'
Global Const $EN_INTERRUPT_MESSAGE = "~ interrupt!"
Global Const $EN_MISSING_URL_MESSAGE = "Missing URL!"
;Global Const $GUI_ON_EVENT_MODE = "GUIOnEventMode"
Global Const $EXTRACT_AUDIO = " --extract-audio "
Global Const $AUDIO_FORMAT = " --audio-format "
$audioQual = iniRead ("config\config.st", "accessibility", "Audio Quality", "")
if $audioQual ="128k" or $audioQual ="160k" or $audioQual ="192k" or $audioQual ="224k" or $audioQual ="256k" or $audioQual ="320k" or $audioQual ="384k" then
Global Const $audioQuality = " --audio-quality " &$audio_qual &" "
else
Global Const $audioQuality = " --audio-quality 320k "
EndIf
Global Const $OUTPUT = " --output "
Global Const $OUTPUT_TEMPLATE = "%%(title)s.%%(ext)s"
Global Const $YES_PLAYLIST = " --yes-playlist "
Global Const $NO_PLAYLIST = " --no-playlist "
Global Const $PLAYLIST_START = " --playlist-start "
Global Const $PLAYLIST_END = " --playlist-end "
Global Const $PLAYLIST_Ignore_errors = ""
Global Const $WRITE_SUB = " --write-sub "
Global Const $WRITE_AUTO_SUB = " --write-auto-sub "
Global Const $SUB_FORMAT = " --sub-format "
Global Const $SUB_LANG = " --sub-lang "
Global Const $SKIP_VIDEO =" --skip-download "
Global Const $NOP_MILLIS = 10000
Global Const $EMPTY_STRING = ""
Global Const $SPACE = " "
Global Const $DOWNLOAD_TAG = "[download]"
Global $iPID = -1
global $d_folder = iniRead ("config\config.st", "General settings", "Destination folder", "")
select
case $d_folder =""
$d_folder="C:\MCY\Download\Audio"
endSelect
#Region ### START Koda GUI section ### Form=new\mainform.kxf
#Region INPUT URL
select
case $grlanguage ="es"
$idLabel1 = GUICtrlCreateLabel("Introduzca una &URL: Inserte aquí el enlace del vídeo a descargar:", 10, 10, 200, 20)
Local $sData = ClipGet()
$input_url = GUICtrlCreateInput($sData, 18, 30, 497, 20)
;~ GUICtrlSetTip($idInput1, '#Region INPUT')
case $grlanguage ="eng"
$idLabel1 = GUICtrlCreateLabel("Enter a &URL, Insert here the link of the video to download:", 10, 10, 200, 20)
Local $sData = ClipGet()
$input_url = GUICtrlCreateInput($sData, 18, 30, 497, 20)
;~ GUICtrlSetTip($idInput1, '#Region INPUT')
endselect
#EndRegion INPUT URL
select
case $grlanguage ="es"
$chkbox_isSingle = GUICtrlCreateCheckbox("Descargar solamente en &vídeo" & @LF & "Deja marcada solamente esta casilla para descargar el vídeo original, en el caso de YouTube.", 8, 80, 145, 17)
case $grlanguage ="eng"
$chkbox_isSingle = GUICtrlCreateCheckbox("Download only this &video" & @lf & "Check only this checkbox to download the original video, in case of YouTube.", 8, 80, 145, 17)
endselect
GUICtrlSetState(-1, $GUI_CHECKED)
select
case $grlanguage ="es"
$chkbox_isMP3 = GUICtrlCreateCheckbox("Descargar como &MP3 (calidad alta)" &@lf & "Marca esta casilla para convertir este vídeo descargado a mp3.", 8, 104, 145, 17)
$chkbox_sub = GUICtrlCreateCheckbox("Descargar &subtítulos" & @lf & "Puedes descargar subtítulos, si el vídeo los soporta.", 8, 190, 145, 17)
$input_dir = GUICtrlCreateInput($d_folder, 8, 240, 150, 17)
$idFolder = GUICtrlCreateLabel("Carpeta de destino", 8, 250, 280, 17)
$btn_dir = GUICtrlCreateButton("Seleccionar &carpeta de destino..."& @lf & "La carpeta de descarga donde se guardarán tus archivos.", 520, 40, 83, 25)
$btn_generate = GUICtrlCreateButton("&Descargar" & @lf & "Comienza la descarga del enlace seleccionado", 8, 280, 145, 17)
case $grlanguage ="eng"
$chkbox_isMP3 = GUICtrlCreateCheckbox("Download as &MP3 (high quality)" & @lf & "Check this box to convert this downloaded video to mp3.", 8, 104, 145, 17)
$chkbox_sub = GUICtrlCreateCheckbox("Download &subtittles" & @lf & "You can download subtitles, if the video supports them.", 8, 190, 145, 17)
$input_dir = GUICtrlCreateInput($d_folder, 8, 240, 150, 17)
$idFolder = GUICtrlCreateLabel("Destination folder", 8, 240, 280, 17)
$btn_dir = GUICtrlCreateButton("Choose &Folder" & @lf & "The download folder where your files will be saved.", 520, 40, 83, 25)
$btn_generate = GUICtrlCreateButton("&Download" & @lf & "Starts download of the selected link", 8, 280, 145, 17)
endselect
select
case $grlanguage ="es"
$idLabel1 = GUICtrlCreateLabel("Descargar desde el video número", 100, 100, 200, 21)
case $grlanguage ="eng"
$idLabel1 = GUICtrlCreateLabel("Download video from: ", 100, 100, 200, 21)
endselect
$input_start = GUICtrlCreateInput("", 160, 80, 41, 21)
GUICtrlSetState(-1, $GUI_HIDE)
select
case $grlanguage ="es"
$idLabel1 = GUICtrlCreateLabel("Descargar hasta el video número", 130, 115, 200, 21)
case $grlanguage ="es"
$idLabel1 = GUICtrlCreateLabel("Download to: ", 130, 115, 200, 21)
endselect
$input_end = GUICtrlCreateInput("", 224, 80, 41, 21)
GUICtrlSetState(-1, $GUI_HIDE)
select
case $grlanguage ="es"
$Label1 = GUICtrlCreateLabel("Seleccione método de descarga de subtítulos:", 208, 83, 16, 17)
case $grlanguage ="eng"
$Label1 = GUICtrlCreateLabel("Select subtitle download method:", 208, 83, 16, 17)
endselect
GUICtrlSetState(-1, $GUI_HIDE)
$combo_sublist = GUICtrlCreateCombo("Auto sub", 160, 152, 145, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetState(-1, $GUI_HIDE)
;Global Const $edit_out = GUICtrlCreateEdit($EMPTY_STRING, 508, 152, 525, 209, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $WS_HSCROLL, $WS_VSCROLL, $WS_CLIPSIBLINGS));
select
case $grlanguage ="es"
$chkbox_onlysub = GUICtrlCreateCheckbox("Solo subtítulos", 312, 152, 97, 17)
case $grlanguage ="eng"
$chkbox_onlysub = GUICtrlCreateCheckbox("Only down sub", 312, 152, 97, 17)
endselect
GUICtrlSetState(-1, $GUI_HIDE)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
Global $isSingle = False
Global $url
Global $dir
Global $sublang
Local $sOutput = $EMPTY_STRING
While 1
$url = GUICtrlRead($input_url)
$sublang = GUICtrlRead($combo_sublist)

;check if the input url is a playlist url
If Not(StringInStr($url,"list")) And GUICtrlRead($chkbox_isSingle) == $GUI_UNCHECKED Then
GUICtrlSetState($chkbox_isSingle,$GUI_CHECKED)
select
case $ReadAccs ="yes"
speaking("se marcó el enlace como lista de reproducción.")
case $ReadAccs ="no"
ToolTip("Se marcó este enlace como lista de reproducción.")
endselect
endif
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
Menuprogram()
Case $btn_dir
select
case $grlanguage ="es"
Local $path = FileSelectFolder("Selecciona una carpeta...",$input_dir)
GUICtrlSetData($input_dir,$path)
case $grlanguage ="eng"
Local $path = FileSelectFolder("Choose Folder...",$input_dir)
GUICtrlSetData($input_dir,$path)
endselect
writeinlog("Folder selected: " &$path)
Case $btn_generate
select
case $grlanguage ="es"
$sound_update_es = $device.opensound ("sounds\soundsdata.dat\update_downloading1.ogg", 0)
$sound_update_es.play
msgbox(0, "Descargando", "Espera un momento, estamos buscando el vídeo. Presiona aceptar para comenzar.")
case $grlanguage ="eng"
$sound_update_en = $device.opensound ("sounds\soundsdata.dat\update_downloading2.ogg", 1)
$sound_update_en.play
msgbox(0, "Downloading", "Wait a moment, we're looking for the video. Press OK to start.")
$say="0"
endselect
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
$exitcmd= &@crlf "exit"
If $isMP3 Then
writeinlog("Downloading as Mp3")
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
$command &= $OUTPUT & '"' & $dir &'\' & $OUTPUT_TEMPLATE & '" '
EndIf
$command &= ' "' & GUICtrlRead($input_url) & '"'
$command &= (@crlf &$exitcmd)
Local $file = FileOpen("generated.bat",$FO_OVERWRITE  + $FO_CREATEPATH)
FileWrite($file,$command)
FileClose($file)
;If $isExec Then
;GUIDelete($dmain)
;Run(@ComSpec & " /K " & $command &$exitcmd)
writeinlog("Starting process...")
$runcmd = Run("generated.bat")
writeinlog("downloading " & GUICtrlRead($input_url))
ProcessWaitClose($runcmd)
;Local $aregexp = StringRegExp($runcmd, '"[^"]*"', 13)
;sleep(2000)
;If IsArray($aregexp) AND UBound($aregexp) > 1 Then
;$aregexp = $aregexp[1]
;Else
;$aregexp = ""
;EndIf
;ProgressOn("Downloading", "Please wait", "0%", 100, 20)
;Local $line
;While 1
;$line = StdoutRead($runcmd)
;If @error Then Writeinlog("Error creating progress... Downloading in the console.")
;$aregexp = StringRegExp($line, "([0-9.]+)\h*%", 13)
;If IsArray($aregexp) Then ProgressSet($aregexp[UBound($aregexp) - 1])
;NVDAController_SpeakText($aregexp)
;WEnd
;NVDAController_SpeakText($aregexp)
;Sleep(1200)
;NVDAController_SpeakText($aregexp)
;ProgressOff()
$downloaded = $device.opensound ("sounds\soundsdata.dat\downloaded.ogg", 0)
$downloaded.play
SLEEP(250)
FileDelete("generated.bat")
select
case $grlanguage="es"
$Dialog_Complete=MsgBox(4, "Descarga completa", "¿Quieres abrir la carpeta de descargas actualmente en uso?")
case $grlanguage="eng"
$Dialog_Complete=MsgBox(4, "Download complete", "¿Do you want to open the download folder currently in use?")
endselect
if $Dialog_Complete == 6 then
	_WinAPI_ShellExecute($d_folder, '', '', 'open')
	If @error Then
		MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), 'Error', 'Unable to open folder "' & $d_folder & '".' & @CRLF & @CRLF & @extended)
writeinlog("Unable to open folder " & $d_folder & '".' & @CRLF & @CRLF & @extended)
else
writeinlog("video Downloaded. Open Folder=yes. Opening: " &$d_folder)
	EndIf
else
writeinlog("video Downloaded. Open Folder=no")
endIf
;GUIDelete($dmain)
;menuprogram()
Case $chkbox_isSingle
If BitAND(GUICtrlRead($chkbox_isSingle), $BN_CLICKED) = $BN_CLICKED Then
If _GUICtrlButton_GetCheck($chkbox_isSingle) Then
select
case $ReadAccs ="yes"
speaking("se marcó el enlace como vídeo.")
case $ReadAccs ="no"
ToolTip("Se marcó este enlace como lista de reproducción.")
endselect
select
case $grlanguage="es"
GUICtrlSetData($chkbox_isSingle,"Descargar &vídeo")
case $grlanguage="eng"
GUICtrlSetData($chkbox_isSingle,"Download &video")
endselect
GUICtrlSetState($input_start,$GUI_HIDE)
GUICtrlSetState($input_end,$GUI_HIDE)
GUICtrlSetState($Label1,$GUI_HIDE)
                Else
select
case $ReadAccs ="yes"
speaking("se marcó el enlace como lista de reproducción.")
case $ReadAccs ="no"
ToolTip("Se marcó este enlace como vídeo.")
endselect
select
case $grlanguage ="es"
GUICtrlSetData($chkbox_isSingle,"Descargar &lista de reproducción")
case $grlanguage ="eng"
GUICtrlSetData($chkbox_isSingle,"Download &playlist")
endselect
GUICtrlSetState($input_start,$GUI_SHOW)
GUICtrlSetState($input_end,$GUI_SHOW)
GUICtrlSetState($Label1,$GUI_SHOW)
EndIf
EndIf

Case $chkbox_sub
If BitAND(GUICtrlRead($chkbox_sub), $BN_CLICKED) = $BN_CLICKED Then
If _GUICtrlButton_GetCheck($chkbox_sub) Then
If (StringLen($url)>0) Then
_GUICtrlComboBox_InsertString($combo_sublist,GetSubLang(),0)
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
Func GetSubLang()
Local $a_sublist
Local $command = $MAIN & " --list-subs " & $url
Local $cmdline = Run(@ComSpec & " /C " & $command,"", @SW_HIDE,$STDERR_CHILD + $STDOUT_CHILD)
ProcessWaitClose($cmdline)
Local $return = StdoutRead($cmdline)
$a_sublist = StringSplit($return,@LF)
Return StringLeft($a_sublist[UBound($a_sublist)-2],2)
EndFunc
FileDelete("generated.bat")
;run("engines\youtube-dl-.exe $Enlace --prefer-ffmpeg ffmpeg-location PATH ffmpeg.exe --audio-quality 320K (default 5) mp3 --convert-subs srt")
; al pulsar el botón cambios en el menú llama a la función Readchanges()
