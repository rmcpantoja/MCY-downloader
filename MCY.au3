;Begining off script. Comienzo del script.
global $arquitectura = "x64"
; Defining the version number, and program info. definiendo el número de versión del programa e información del mismo.
; #pragma compile(Icon, C:\Program Files\AutoIt3\Icons\au3.ico)
#pragma compile(Compression, 2)
#pragma compile(UPX, False)
#pragma compile(FileDescription, Music YouTube Downloader)
#pragma compile(ProductName, Music YouTube Downloader)
#pragma compile(ProductVersion, 0.9.0.0)
#pragma compile(FileVersion, 0.9.0.0, 0.9.0.0)
#pragma compile(LegalCopyright, © 2018-2021 MT Programs, All rights reserved)
#pragma compile(CompanyName, 'MT Programs')
;Including program scripts: Incluyendo scripts para el programa:
;#include <Array.au3>;
#include "Include\audio.au3"
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#Include<fileConstants.au3>
#include "Include\functions.au3"
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <GuiComboBox.au3>
#include <InetConstants.au3>;
#include "Include\mergefiles_utf16le_v2.au3"
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
#include "include\RunUDF.au3"
#Include "Include\sapi.au3"
#include "Include\say_UDF.au3"
#include <StaticConstants.au3>
#include <String.au3>
#include <TrayConstants.au3>
#include "updater.au3"
#include <WindowsConstants.au3>
;#include "Include\zip.au3"
;Extracting package of sounds: Extrayendo paquete de sonidos:
;Creates a window wenn the program is loading: Crea una ventana mientras el programa se está cargando:
$l1 = GUICreate("Loading...")
GUISetState(@SW_SHOW)
FileChangeDir(@ScriptDir)
Register_Run("MCY")
sleep(100)
writeinlog("Initialicing...")
sleep(100)
if @ProcessorArch = "x64" then
Global $sYouTube_DL = IniRead("config\config.st", 'General Settings', 'Youtube-DL', 'engines64\youtube-dl-.exe')
EndIf
if @ProcessorArch = "x86" then
Global $sYouTube_DL = IniRead("config\config.st", 'General Settings', 'Youtube-DL', 'engines\youtube-dl-.exe')
EndIf
If not FileExists("MCY.au3") Then
Extractor()
else
Extractor()
endif
Func Extractor()
GUICtrlCreateLabel("Extracting sounds...", 40, 20)
If FileExists("sounds\soundsdata.dat\*.ogg") then
if @compiled then
msgbox (4096, "error", "Damn thief, stop stealing the sounds!")
exit
EndIf
endif
comprovarArc()
GUIDelete($l1)
EndFunc
func comprovarArc()
$developermode= "1"
if not fileExists ("config") then
DirCreate("config")
if @error then
MSGBox(0, "Error", "Config folder could not be created.")
exitpersonaliced()
EndIf
EndIf
writeinlog("Checking architecture")
GUIDelete($l1)
if @ProcessorArch = "x64" and $arquitectura = "x64" then
writeinlog("Windows 64 bit")
endif
if @ProcessorArch = "x86" and $arquitectura = "x86" then
writeinlog("Windows 32 bit")
endif

if @ProcessorArch = "x64" and $arquitectura = "x86" then
msgBox(48, "Warning", "You run a 64-bit pc with the 32-bit version of the program. "&@crlf &"For better performance in the program, we recommend that you download the 64-bit version at http://mateocedillo.260mb.net/programs.html")
exitpersonaliced()
endif
if @ProcessorArch = "x86" and $arquitectura = "x64" then
msgBox(48, "Warning", "You run a 32-bit pc with the 64-bit version of the program." &@crlf &"For better performance in the program, we recommend that you download the 32-bit version at http://mateocedillo.260mb.net/programs.html")
exitpersonaliced()
endif
;"Ejecutas un pc de 32 bits con la versión del programa de 64 bits."
;"Para mayor rendimiento en el programa, te recomendamos que descargues la versión de 32 bits en http://mateocedillo.260mb.net/programs.html")
select
case $developermode = 1
writeinlog("Checking program copy...")
checkcopy()
case $developermode = 0
writeinlog("The program is not compiled. Exiting...")
NotCompiled()
EndSelect
EndFunc
func checkcopy()
;Para saber de dónde se está ejecutando la copia:
if @scriptDir ="C:\MCY" then
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
_nvdaControllerClient_free()
$delfiles = "0"
;This custom exit function is used to delete some files when exiting the program. 0 for disabled, 1 enabled (by default it is disabled for all general users). Esta función personalizada de salir, sirve para eliminar algunos archivos cuando se sale del programa. 0 para deshavilitado, 1 havilitado (por defecto está havilitado para todos los usuarios en general)
select
case $delfiles = 1
writeinlog("exiting...")
$soundclose = $device.opensound ("sounds/soundsdata.dat/close.ogg", true)
$soundclose.play
sleep(1000)
$soundclose.stop
writeinlog("removing files...")
FileDelete("MCYWeb.dat")
FileDelete(@tempDir &"\MCYWeb.dat")
;FileDelete("tmp_motd_es.ogg")
DirRemove(@ScriptDir & "/sounds", 1)
sleep(500)
exit
case $delfiles = 0
writeinlog("exiting...")
$soundclose = $device.opensound ("sounds/soundsdata.dat/close.ogg", true)
$soundclose.play
sleep(1200)
exit
endselect
endfunc
;La siguiente pregunta es para activar la accesibilidad mejorada, hecha exclusiba y únicamente para las personas con discapacidad. The next question is to activate the improved accessibility, made exclusively and only for people with disability.
func configure()
writeinlog("Launching at first time.")
$s_selected = $device.opensound ("sounds/soundsdata.dat/selected.ogg", true)
select
case @OSLang = "0c0a" or @OSLang = "040a" or @OSLang = "080a" or @OSLang = "100a" or @OSLang = "140a" or @OSLang = "180a" or @OSLang = "1c0a" or @OSLang = "200a" or @OSLang = "240a" or @OSLang = "280a" or @OSLang = "2c0a" OR @OSLang = "300a" or @OSLang = "340a" or @OSLang = "380a" or @OSLang = "3c0a" or @OSLang = "400a" or @OSLang = "440a" or @OSLang = "480a" or @OSLang = "4c0a" or @OSLang = "500a"
$quest1="Activar accesibilidad mejorada?"
$quest2="La accesibilidad mejorada está diseñada para las personas con discapacidad visual, en lo cual la mayoría de la interfaz del programa se podrá usar mediante voz y atajos de teclas. ¿Activar?"
;English languages: Idiomas para inglés:
case @OSLang = "0809" or @OSLang = "0c09" or @OSLang = "1009" or @OSLang = "1409" or @OSLang = "1809" or @OSLang = "1c09" or @OSLang = "2009" or @OSLang = "2409" or @OSLang = "2809" or @OSLang = "2c09" or @OSLang = "3009" or @OSLang = "3409" or @OSLang = "0425"
$quest1="Enable enanced accessibility?"
$quest2="This new Enhanced Accessibility functionality is designed for the visually impaired, in which most of the program interface can be used by voice and keyboard shortcuts. Activate?"
case else
$quest1="Enable enanced accessibility?"
$quest2="This new Enhanced Accessibility functionality is designed for the visually impaired, in which most of the program interface can be used by voice and keyboard shortcuts. Activate?"
endselect
$Warning=MsgBox(4, $quest1, $quest2)
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
local $widthCell,$msg,$iOldOpt
$langGUI= GUICreate("Language selector")
$widthCell=70
$iOldOpt=Opt("GUICoordMode",$iOldOpt)
GUICtrlCreateLabel("Select language ere:",-1,0)
GUISetBkColor(0x00E0FFFF)
GUISetState(@SW_SHOW)
$configureaccs = iniRead ("config\config.st", "accessibility", "Enable enanced accessibility", "")
if $configureaccs ="yes" then
$windowslanguage= @OSLang
;Spanish languages: Idiomas en español:
select
case $windowslanguage = "0c0a" or $windowslanguage = "040a" or $windowslanguage = "080a" or $windowslanguage = "100a" or $windowslanguage = "140a" or $windowslanguage = "180a" or $windowslanguage = "1c0a" or $windowslanguage = "200a" or $windowslanguage = "240a" or $windowslanguage = "280a" or $windowslanguage = "2c0a" or $windowslanguage = "300a" or $windowslanguage = "340a" or $windowslanguage = "380a" or $windowslanguage = "3c0a" or $windowslanguage = "400a" or $windowslanguage = "440a" or $windowslanguage = "480a" or $windowslanguage = "4c0a" or $windowslanguage = "500a"
$menu=reader_Create_Menu("Por favor, selecciona tu idioma con las flechas arriva y abajo", "Español,Inglés,Salir", "1", $menuPos)
;English languages: Idiomas para inglés:
case $windowslanguage = "0809" or $windowslanguage = "0c09" or $windowslanguage = "1009" or $windowslanguage = "1409" or $windowslanguage = "1809" or $windowslanguage = "1c09" or $windowslanguage = "2009" or $windowslanguage = "2409" or $windowslanguage = "2809" or $windowslanguage = "2c09" or $windowslanguage = "3009" or $windowslanguage = "3409" or $windowslanguage = "0425" or 
$menu=reader_Create_Menu("Please select a language with the up y down arrows", "Spanish,ENglish,Exit", "1", $menuPos)
;end selection off languages. Fin de selección/detección de idiomas.
case else
$menu=reader_Create_Menu("Please select a language with the up y down arrows", "Spanish,ENglish,Exit", "1", $menuPos)
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
IniWrite("config\config.st", "General settings", "language", "es")
if @error then
MSGBox (0, "Error", "Configuration data could not be written.")
Exitpersonaliced()
EndIf
$language="1"
sleep(100)
GUIDelete($langGUI)
checkupd()
case $menu = 2
IniWrite ("config\config.st", "General settings", "language", "eng")
if @error then
MSGBox (0, "Error", "Configuration data could not be written.")
Exitpersonaliced()
EndIf
$language="2"
sleep(100)
GUIDelete($langGUI)
checkupd()
case $menu = 3
sleep(100)
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
IniWrite("config\config.st", "General settings", "language", "es")
if @error then
MSGBox (0, "Error", "Configuration data could not be written.")
Exitpersonaliced()
EndIf
$language="1"
sleep(100)
GUIDelete($langGui)
checkupd()
exitloop
Case $idEnglish
IniWrite("config\config.st", "General settings", "language", "es")
if @error then
MSGBox (0, "Error", "Configuration data could not be written.")
Exitpersonaliced()
EndIf
$language="1"
sleep(100)
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
GUIDelete($main_u)
endfunc
func checKmcyversion()
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
$sLanguage = iniRead ("config\config.st", "General settings", "language", "")
writeinlog("Checking for updates...")
Local $yourexeversion = FileGetVersion("MCY.exe")
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
if $sLanguage ="Es" then
if $ReadAccs ="Yes" then
select
Case $latestVer > $yourexeversion
writeinlog("Warning! Update available. Your version:" &$yourexeversion & ". New version:" & $latestver)
$ttsString = " Pulsa enter para continuar, espacio para repetir la información."
TTSDialog("actualización disponible! " &$newversion &$yourexeversion &$newversion2 &$latestver& ". Presiona enter para descargar.")
sleep(150)
if $arquitectura = x64 then
_Updater_update("MCY.exe", "https://www.dropbox.com/s/l19ywvrocy7vsoc/MCY_setup.exe?dl=1", "https://www.dropbox.com/s/d49pf4blsv61aoz/extract.exe?dl=1")
Else
_Updater_update("MCY.exe", "https://www.dropbox.com/s/guo5n4uzro43v6e/MCY_setup_x86.exe?dl=1", "https://www.dropbox.com/s/ccp9mjaw35gzn9s/extract_x86.exe?dl=1")
EndIf
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
if $arquitectura = x64 then
_Updater_update("MCY.exe", "https://www.dropbox.com/s/l19ywvrocy7vsoc/MCY_setup.exe?dl=1", "https://www.dropbox.com/s/d49pf4blsv61aoz/extract.exe?dl=1")
Else
_Updater_update("MCY.exe", "https://www.dropbox.com/s/guo5n4uzro43v6e/MCY_setup_x86.exe?dl=1", "https://www.dropbox.com/s/ccp9mjaw35gzn9s/extract_x86.exe?dl=1")
EndIf
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
if $arquitectura = x64 then
_Updater_update("MCY.exe", "https://www.dropbox.com/s/l19ywvrocy7vsoc/MCY_setup.exe?dl=1", "https://www.dropbox.com/s/d49pf4blsv61aoz/extract.exe?dl=1")
Else
_Updater_update("MCY.exe", "https://www.dropbox.com/s/guo5n4uzro43v6e/MCY_setup_x86.exe?dl=1", "https://www.dropbox.com/s/ccp9mjaw35gzn9s/extract_x86.exe?dl=1")
EndIf
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
if $arquitectura = x64 then
_Updater_update("MCY.exe", "https://www.dropbox.com/s/l19ywvrocy7vsoc/MCY_setup.exe?dl=1", "https://www.dropbox.com/s/d49pf4blsv61aoz/extract.exe?dl=1")
Else
_Updater_update("MCY.exe", "https://www.dropbox.com/s/guo5n4uzro43v6e/MCY_setup_x86.exe?dl=1", "https://www.dropbox.com/s/ccp9mjaw35gzn9s/extract_x86.exe?dl=1")
EndIf
case else
checkmotd()
endselect
endif
InetClose($fileinfo)
If @Compiled Then
FileDelete("MCYWeb.dat")
endif
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
$downloading = $device.opensound ("sounds/soundsdata.dat/update_downloading1.ogg", true)
$downloading.play
motdprincipal()
Case $latestMotd = $lMotd
principal()
endselect
InetClose($fileinfo)
endfunc
func motdprincipal()
$LatestMotd = iniRead (@TempDir & "\MCYWeb.dat", "motd", "Latest", "")
$bagground = $device.opensound ("sounds/soundsdata.dat/update.ogg", true)
$downloadingmotd = GUICreate("Descargando mensaje del día...")
GUICtrlCreateLabel("Espera, por favor.", 85, 20)
GUISetState(@SW_SHOW)
$bagground.play
$bagground.repeating=1
Sleep(100)
$ReadAccs = iniRead ("config\config.st", "accessibility", "Enable enanced accessibility", "")
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
$motd = $device.opensound ("tmp_motd_es.ogg", true)
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
$ttsString = " Pulsa enter para continuar, espacio para repetir la información."
$M_text = iniRead (@TempDir & "\MCYWeb.dat", "motd", "Text1", "")
$sound = $device.opensound ("sounds/soundsdata.dat/selected.ogg", true)
$sound.play
if $ReadAccs ="Yes" then
TTSDialog($m_text)
else
msgbox(0, "Mensaje del día", $m_text)
EndIf
endselect
case $grlanguage ="eng"
select
case $m_mode = "text"
if $bagground.playing == "1" then
$bagground.stop
endif
$M_text = iniRead (@TempDir & "\MCYWeb.dat", "motd", "Text2", "")
$sound = $device.opensound ("sounds/soundsdata.dat/selected.ogg", true)
$sound.play
if $ReadAccs ="Yes" then
TTSDialog($m_text)
else
MSGBox(0, "MOTD", $m_text)
EndIf
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
$welcome = $device.opensound ("sounds/soundsdata.dat/open.ogg", true)
$welcome.play
sleep(500)
endfunc
$grlanguage = iniRead ("config\config.st", "General settings", "language", "")
;Set version number. Estableciendo el número de versión.
select
case $grlanguage ="es"
$version="versión 0.8.1 beta"
case $grlanguage ="eng"
$version="version 0.8.1 beta"
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
toolTip("Bienvenido, " &$yourname)
case $grlanguage ="eng"
toolTip("Welcome, " &$yourname)
endselect
;toolTip("")
sleep(300)
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
$viewchanges = GUICreate("Changes:")
GUISetState(@SW_SHOW)
sleep(200)
select
case $grlanguage ="es"
createTtsOutput("Documentation\changes1.txt", "changes")
case $grlanguage ="eng"
createTtsOutput("Documentation\changes2.txt", "changes")
EndSelect
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
Menuprogram()
EndSwitch
WEnd
endfunc
func ReadChanges2()
select
case $grlanguage ="es"
Local $manualdoc = "documentation\changes1.txt"
$editmessage1="Manual del usuario."
$editmessage2="No se encuentra el archivo."
$editmessage3="abriendo..."
$editmessage4="Ocurrió un error al leer el archivo."
$editmessage5="error"
case $grlanguage ="eng"
Local $manualdoc = "documentation\changes2.txt"
$editmessage1="User manual."
$editmessage2="The file cannot be found."
$editmessage3="opening..."
$editmessage4="An error occurred while reading the file."
$editmessage5="error"
endSelect
Local $DocOpen = FileOpen($manualdoc, $FO_READ)
ToolTip($editmessage3)
speaking($editmessage3)
sleep(200)
If $DocOpen = -1 Then
MsgBox($MB_SYSTEMMODAL, $editmessage5, $editmessage4)
Return False
EndIf
Local $openned = FileRead($DocOpen)
$manualwindow = GUICreate($manualdoc)
Local $idMyedit = GUICtrlCreateEdit($openned, 8, 92, 121, 97, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $WS_VSCROLL, $WS_VSCROLL, $WS_CLIPSIBLINGS))
GUISetState(@SW_SHOW)
; Loop until the user exits.
While 1
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE
FileClose($DocOpen)
ExitLoop
EndSwitch
WEnd
GUIDelete()
EndFunc
func updcomponents()
select
case $grlanguage ="es"
$upd1="Error"
$upd2="Youtube-dl no encontrado."
$upd3="Buscando actualización de YouTubeDl"
$upd4="Por favor espera..."
$upd5="Espera mientras se está buscando la actualización de la librería de YouTube"
$upd6="Correcto"
$upd7="Youtube-dl se actualizó correctamente. Disfruta!"
$upd8="Está todo actualizado"
$upd9="No hay ninguna actualización por el momento."
case $grlanguage ="eng"
$upd1="Error"
$upd2="Youtube-dl not found."
$upd3="Looking for YouTubeDl update"
$upd4="Please wait..."
$upd5="Please wait while the YouTube library update is being searched."
$upd6="Done"
$upd7="Youtube-dl should be updated. Enjoin!"
$upd8="Everything is up to date"
$upd9="There is no update at the moment."
endSelect
If Not FileExists($sYouTube_DL) Then
MsgBox(16, $upd1, $upd2)
exitpersonaliced()
EndIf
$update = $device.opensound ("sounds/soundsdata.dat/update.ogg", true)
;Plays the music wen downloading YouTubeDl updatte. Reproduce la música mientras se descarga la actualización de YouTubeDl.
$update.play
$update.repeating=1
Global $g_hGui, $g_aGuiPos
$g_hGui = GUICreate($upd3)
$g_hPic = GUICreate("", 80, 50, 25, 30, $WS_POPUp, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $g_hGui)
GUICtrlCreatePic("..\logo.gif", 0, 0, 0, 0)
GUISetState(@SW_SHOW, $g_hGui)
$g_aGuiPos = WinGetPos($g_hGui)
writeinlog("Updating Youtube Dl...")
$updatelabel = GUICtrlCreateLabel($upd4, 25, 16)
GUICtrlSetTip(-1, $upd4)
ToolTip($upd3 &$upd4)
TrayTip($upd4, $upd5, 0, $TIP_ICONASTERISK)
Local $iPID = Run(@ComSpec & ' /C "' & $sYouTube_DL & '" --update', @ScriptDir, @SW_HIDE, 6)
ProcessWaitClose($iPID)
If Not StringInStr(StdoutRead($iPID), 'youtube-dl is up-to-date') Then
writeinlog(StdoutRead($iPID))
$update.stop
MsgBox(48, $upd6, $upd7)
GUIDelete($g_hGui)
MENUPROGRAM()
else
$update.stop
MsgBox(48, $upd8, $upd9)
GUIDelete($g_hGui)
MENUPROGRAM()
endif
endfunc
Func Imputdownload()
say()
select
case $grlanguage ="es"
$msg1="MCY Downloader: Descargar multimedia"
$msg2="conectando con internet..."
$msg3="No tienes conexión a internet!"
case $grlanguage ="eng"
$msg1="MCY Downloader: Download multimedia"
$msg2="connecting to internet..."
$msg3="¡You don't have an internet connection!"
endselect
$dmain = GUICreate($msg1)
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
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
if @ProcessorArch = "x64" then
Global Const $MAIN = " engines64\youtube-dl- "
Global Const $ffmpeg = " engines64\ffmpeg.exe"
Global Const $MSVCR100_PATH = "engines64\msvcr100.dll"
Global Const $CMD_VIDEO = 'engines64\youtube-dl-.exe -o "'
EndIf
if @ProcessorArch = "x86" then
Global Const $MAIN = " engines\youtube-dl- "
Global Const $ffmpeg = " engines\ffmpeg.exe"
Global Const $MSVCR100_PATH = "engines\msvcr100.dll"
Global Const $CMD_VIDEO = 'engines\youtube-dl-.exe -o "'
EndIf
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
local $count = 0
global $d_folder = iniRead ("config\config.st", "General settings", "Destination folder", "")
select
case $d_folder =""
$d_folder="C:\MCY\Download\Audio"
iniWrite ("config\config.st", "General settings", "Destination folder", $d_folder)
endSelect
#Region ### START Koda GUI section ### Form=Include\mainform.kxf
#Region INPUT URL
select
case $grlanguage ="es"
$idLabel1 = GUICtrlCreateLabel("Introduzca una &URL: Inserte aquí el enlace del vídeo, playlist o canal a descargar:", 10, 10, 200, 20)
Local $sData = ClipGet()
$input_url = GUICtrlCreateInput($sData, 18, 30, 497, 20)
case $grlanguage ="eng"
$idLabel1 = GUICtrlCreateLabel("Enter a &URL, Insert here the link, playlist or channel of the video to download:", 10, 10, 200, 20)
Local $sData = ClipGet()
$input_url = GUICtrlCreateInput($sData, 18, 30, 497, 20)
endselect
#EndRegion INPUT URL
select
case $grlanguage ="es"
$chkbox_isSingle = GUICtrlCreateCheckbox("Descargar solo &vídeo" & @LF & "Deja marcada solamente esta casilla para descargar el vídeo original, en el caso de YouTube.", 8, 80, 145, 17)
case $grlanguage ="eng"
$chkbox_isSingle = GUICtrlCreateCheckbox("Download only &video" & @lf & "Check only this checkbox to download the original video, in case of YouTube.", 8, 80, 145, 17)
endselect
GUICtrlSetState(-1, $GUI_CHECKED)
select
case $grlanguage ="es"
$chkbox_isMP3 = GUICtrlCreateCheckbox("Descargar como &MP3 (calidad alta)" &@lf & "Marca esta casilla para convertir este vídeo descargado a mp3.", 8, 104, 145, 17)
$chkbox_sub = GUICtrlCreateCheckbox("Descargar &subtítulos" & @lf & "Puedes descargar subtítulos, si el vídeo los soporta.", 8, 190, 145, 17)
$input_dir = GUICtrlCreateInput($d_folder, 8, 240, 145, 17)
$idFolder = GUICtrlCreateLabel("Carpeta de destino", 8, 300, 150, 17)
$btn_dir = GUICtrlCreateButton("Seleccionar &carpeta de destino..."& @lf & "La carpeta de descarga donde se guardarán tus archivos.", 8, 340, 150, 17)
$btn_generate = GUICtrlCreateButton("&Descargar" & @lf & "Comienza la descarga del enlace seleccionado", 8, 440, 145, 17)
$btn_share = GUICtrlCreateButton("&Compartir enlace" & @lf & "Comparte URL a través de redes sociales.", 8, 480, 145, 17)
$btn_prev = GUICtrlCreateButton("&Preview", 8, 520, 145, 17)
case $grlanguage ="eng"
$chkbox_isMP3 = GUICtrlCreateCheckbox("Download as &MP3 (high quality)" & @lf & "Check this box to convert this downloaded video to mp3.", 8, 104, 145, 17)
$chkbox_sub = GUICtrlCreateCheckbox("Download &subtittles" & @lf & "You can download subtitles, if the video supports them.", 8, 190, 145, 17)
$input_dir = GUICtrlCreateInput($d_folder, 8, 240, 145, 17)
$idFolder = GUICtrlCreateLabel("Destination folder", 8, 300, 150, 17)
$btn_dir = GUICtrlCreateButton("Choose &Folder" & @lf & "The download folder where your files will be saved.", 8, 340, 150, 17)
$btn_generate = GUICtrlCreateButton("&Download" & @lf & "Starts download of the selected link", 8, 440, 145, 17)
$btn_share = GUICtrlCreateButton("&Share link" & @lf & "Share URLs through social networks.", 8, 480, 145, 17)
$btn_prev = GUICtrlCreateButton("&Preview", 8, 520, 145, 17)
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
Local $DOWNLOADLINE = $EMPTY_STRING
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
$sound_update_es = $device.opensound ("sounds/soundsdata.dat/update_downloading1.ogg", true)
$sound_update_es.play
msgbox(0, "Descargando", "Espera un momento, estamos buscando el vídeo. Presiona aceptar para comenzar.")
case $grlanguage ="eng"
$sound_update_en = $device.opensound ("sounds/soundsdata.dat/update_downloading2.ogg", true)
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
GUISetState(@SW_HIDE, $main)
;Run(@ComSpec & " /K " & $command &$exitcmd)
Select
case $grlanguage ="es"
$dMSG="Descargando..."
case $grlanguage ="eng"
$dMSG="Downloading..."
EndSelect
global $downloading = guicreate($DMSG)
$edit_out = GUICtrlCreateEdit($EMPTY_STRING, 8, 152, 325, 17, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $WS_HSCROLL, $WS_VSCROLL, $WS_CLIPSIBLINGS));
Local $idProgressbar = GUICtrlCreateProgress(200, 50, 325, 17)
GUICtrlSetColor(-1, 32250)
GUISetState(@SW_SHOW)
writeinlog("Starting process...")
Local $iSavPos = 0
;Global Const $GUI_ON_EVENT_MODE = "GUIOnEventMode"
;Global Const $CLOSE_ON_EVENT = "close_clicked"
;HotKeySet("alt {f4}", $CLOSE_ON_EVENT)
;Opt($GUI_ON_EVENT_MODE, 1)
;GUISetOnEvent($GUI_EVENT_CLOSE, $CLOSE_ON_EVENT, $downloading)
Local $runcmd = Run(@ComSpec & " /C " & "generated.bat", @ScriptDir, @SW_HIDE, 6)
GUICtrlSetData($edit_out, $EMPTY_STRING)
writeinlog("downloading " & GUICtrlRead($input_url))
ProgressOn("Downloading", "Please wait", "0%", 100, 20)
Local $downloadline
While 1
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE
If BitAND(WinGetState($downloading), $WIN_STATE_ACTIVE) Then
If ProcessExists("youTube-dl-.exe") <> 0 Then
Dim $iMsgBoxAnswer
$iMsgBoxAnswer = MsgBox(5244324,"question","Your download has not finished yet. Are you sure you really want to get out of here?")
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
;ProgressSet($merge, "downloading...")
If $downloadline <> $EMPTY_STRING Then
If StringInStr($downloadline, $DOWNLOAD_TAG) > 1 Then
GUICtrlSetData($edit_out, $downloadline)
;NVDAController_SpeakText($downloadline)
$split1 = StringRight($downloadline, 5) ;
$split2 = StringLeft($downloadline, 18) 
$split3 = StringRight($split2, 6) 
$split4 = StringRight($split2, 3) 
$iSavPos = $split3
GUICtrlSetData($idProgressbar, $split3)
;$merge = $split1 &$split2
Select
case $ReadAccs ="yes"
If $SayProgresses ="yes" then
Speaking($split3)
endIf
If $BeepProgresses ="yes" then
CreateAudioProgress($split3)
EndIf
If $SayTime ="yes" then
Speaking("Estimated time remaining: " &$split1)
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
$downloaded = $device.opensound ("sounds/soundsdata.dat/downloaded.ogg", true)
$downloaded.play
SLEEP(250)
FileDelete("generated.bat")
select
case $grlanguage="es"
TrayTip("Descarga completa", "Tu enlace " &$url &"¡Se ha procesado y descargado correctamente!", 0, $TIP_ICONASTERISK)
$Dialog_Complete=MsgBox(4, "Descarga completa", "¿Quieres abrir la carpeta de descargas actualmente en uso?")
case $grlanguage="eng"
TrayTip("Download complete", "Your link " &$url &"Has been processed and uploaded correctly!", 0, $TIP_ICONASTERISK)
$Dialog_Complete=MsgBox(4, "Download complete", "¿Do you want to open the download folder currently in use?")
endselect
if $Dialog_Complete == 6 then
ShellExecute($d_folder)
If @error Then
MsgBox(BitOR($MB_ICONERROR, $MB_SYSTEMMODAL), 'Error', 'Unable to open folder "' & $d_folder & '".' & @CRLF & @CRLF & @extended)
writeinlog("Unable to open folder " & $d_folder & '".' & @CRLF & @CRLF & @extended)
else
writeinlog("video Downloaded. Open Folder=yes. Opening: " &$d_folder)
EndIf
else
writeinlog("video Downloaded. Open Folder=no")
endIf
GUIDelete($downloading)
GUISetState(@SW_SHOW, $main)
Case $Btn_Share
global $URLData = ClipGet()
Share()
Case $Btn_Prev
Escuchavistaprevia()
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
func share()
$ln = iniRead ("config\config.st", "General settings", "language", "")
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
select
case $ln ="es"
$sh1="Compartir con..."
$sh2="Volver"
$sh3="Compartir con "
$sh4="Comparto este enlace contigo: este enlace se compartió a través de MCY Downloader. Enlace: "
$sh5="Enlace compartido a través de MCY Downloader"
case $ln ="eng"
$sh1="Share with..."
$sh2="Back"
$sh3="Share on "
$sh4="I share this link with you: This link has been shared through MCY Downloader. Link: "
$sh5="Shared Link via MCY Downloader"
endSelect
$shareGui = Guicreate($sh1)
GUISetState(@SW_SHOW)
Select
case $ReadAccs ="yes"
$shareMenu = Reader_Create_Menu($sh1, "Whatsapp,Facebook,Skype," &$sh2, "1", $menuPos)
select
case $shareMenu = 1
ShellExecute("https://api.whatsapp.com/send?text= " &$sh4 &$URLData)
GuiDelete($shareGui)
case $shareMenu = 2
ShellExecute("https://www.facebook.com/sharer.php?u=" &$URLData &"&t=" &$sh5)
GuiDelete($shareGui)
case $shareMenu = 3
ShellExecute("https://web.skype.com/share?url=" &$URLData &"&lang=en-US=&source=jetpack")
GuiDelete($shareGui)
case $shareMenu = 4
GuiDelete($shareGui)
EndSelect
case $ReadAccs ="No"
$idWhatsapp = GUICtrlCreateButton($sh3 &"WhatsApp", 90, 50, 70, 25)
$idFacebook = GUICtrlCreateButton($sh3 &"Facebook", 130, 50, 70, 25)
$idSkype = GUICtrlCreateButton($sh3 &"Skype", 180, 50, 70, 25)
$idBack = GUICtrlCreateButton($sh2, 250, 50, 70, 25)
; Loop until the user exits.
While 1
$idMsg = GUIGetMsg()
Switch $idMsg
Case $GUI_EVENT_CLOSE, $idBack
GuiDelete($shareGui)
;GUISetState(@SW_SHOW, $dmain)
ExitLoop
Case $idWhatsapp
ShellExecute("https://api.whatsapp.com/send?text= " &$sh4 &$URLData)
GuiDelete($shareGui)
ExitLoop
Case $idFacebook
ShellExecute("https://www.facebook.com/sharer.php?u=" &$URLData &"&t=" &$sh5)
GuiDelete($shareGui)
ExitLoop
Case $idSkype
ShellExecute("https://web.skype.com/share?url=" &$URLData &"&lang=en-US=&source=jetpack")
GuiDelete($shareGui)
ExitLoop
EndSwitch
WEnd
EndSelect
endFunc
FileDelete("generated.bat")

;run("engines\youtube-dl-.exe $Enlace --prefer-ffmpeg ffmpeg-location PATH ffmpeg.exe --audio-quality 320K (default 5) mp3 --convert-subs srt")
; al pulsar el botón cambios en el menú llama a la función Readchanges()