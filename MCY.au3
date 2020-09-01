;Begining off script
; Defining the version number, and program info.
; #pragma compile(Icon, C:\Program Files\AutoIt3\Icons\au3.ico)
#pragma compile(ExecLevel, Lowestavailable)
#pragma compile(UPX, False)
#pragma compile(FileDescription, Music YouTube Downloader)
#pragma compile(ProductName, Music YouTube Downloader)
#pragma compile(ProductVersion, 0.5.116.13)
#pragma compile(FileVersion, 0.5.116.13, 0.5.116.13)
#pragma compile(LegalCopyright, © 2018-2020 Mateo Programs, All rights reserved)
#pragma compile(CompanyName, 'Mateo Programs, a.p.p')
;Including program scripts:
#include <new\Base64.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <new\audio.au3>
#include <new\functions.au3>
#include <new\menu.au3>
#include <new\keyinput.au3>
;#include <MsgBoxConstants.au3>
#include <SendMessage.au3>
#include <StaticConstants.au3>
#include <TrayConstants.au3>
#include <WinAPIFiles.au3>
#include <WinAPISys.au3>
#include <WindowsConstants.au3>
FileInstall("extractor.exe", @ProgramFilesDir & "/MCY/tmp/extractor.exe")
FileInstall("MailSend.exe", @ProgramFilesDir & "/MCY/TMP/MailSend.exe")
;Extracting package of sounds:
;Creates a window wenn the program is loading:
$l1 = GUICreate("The program is loading...")
Extractor()
Func Extractor()
Run("C:\Program Files (x86)\MCY\tmp\extractor.exe")
	WinWait("[CLASS:extractor]", "", 3)
	If WinExists("[CLASS:extractor]") Then
	GUICtrlCreateLabel("Extracting sounds... Extrayendo sonidos...", 40, 20)
GUISetState(@SW_SHOW)
Else
comprovarArc()
	EndIf
EndFunc
func comprovarArc()
$debelopermode= "1"
if @ProcessorArch = "x64" then
MsgBox(0, "información", "tu arquitectura es de 64 bits. Puedes continuar.")
endif
if @ProcessorArch = "x86" then
MsgBox(0, "Error!", "tu arquitectura es de 32 bits y por lo tanto no está soportada en este programa. El soporte para 32 bits terminó el 27 de mayo de 2020.")
exit
endif
select
case $debelopermode = 1
selector()
case $debelopermode = 0
NotCompiled()
EndSelect
EndFunc
GUIDelete($l1)
;FileMove(@ProgramFilesDir & "\*.wav", @ScriptDir & "sounds\soundsdata.dat\", $FC_OVERWRITE + $FC_CREATEPATH)
Func Selector()
$mainmenu = $device.opensound ("sounds\soundsdata.dat\menumusic.wav", 0)
$mainmenu.volume=0.50
$mainmenu.play
$mainmenu.repeating=1
DirCreate("config")
$langGUI= GUICreate("por favor, selecciona un idioma con las flechas arriba y abajo, o, si eres una persona con visión, también puedes tocar el menú contextual para hacerlo.")
	GUISetBkColor(0x00E0FFFF)
	GUISetState(@SW_SHOW)
$menu=Create_Audio_Menu("sounds/soundsdata.dat/langselect.wav", "sounds/soundsdata.dat/es.wav,sounds/soundsdata.dat/eng2.wav")
select
case $menu = 1
SoundPlay("sounds\soundsdata.dat\selected.wav",1)
IniWrite("config\config.st", "General settings", "language", "es")
sleep(500)
$mainmenu.stop
GUIDelete($langGUI)
Principal()
case $menu = 2
SoundPlay("sounds\soundsdata.dat\selected.wav",1)
IniWrite ("config\config.st", "General settings", "language", "eng")
sleep(500)
$mainmenu.stop
GUIDelete($langGUI)
Principal()
EndSelect
EndFunc
Func Principal()
DirCreate("C:\Program Files (x86)\MCY\tmp")
;Show the window
AutoItWinSetTitle("Descargador de músicas de YouTube, por Mateo Cedillo")
Break(0)
;Play welcome sound
SoundPlay("sounds\soundsdata.dat\open.wav",1)
endfunc
;Set version number
$version="version 0.5 beta"
;Set the service
$service="www.youtube.com"
;greetings
$greeting="Saludos "
$yourname="un gusto verte, " &@username 
$welcomemessage="Y Bienvenido a MCY downloader, "
Func Variables()
$result= ($greeting &$yourname &$welcomemessage &$version)
MsgBox(0, "te damos la bienvenida", $result)
endfunc
;Show dialog
$confirmation=MsgBox(4, "MCY", "¿Quieres ejecutar el script con saludos personalizables?")
if $confirmation == 6 then
Saludo()
else
Variables()
endif
Func Saludo()
$messagea="buenas madrugadas, te damos la bienvenida"
$messageb="buenos días, te damos la bienvenida"
$messagec="buenas tardes, te damos la bienvenida"
$messaged="buenas noches, te damos la bienvenida"
$Messagee="buenas tardísimas, te damos la bienvenida"
$buenas=@hour
Switch @HOUR
	Case 0 To 5
msgbox(0, "Qué frío hace...", $messagea &$result)
	Case 6 To 11
msgbox(0, "Espero que hayas tenido un buen amanecer", $messageb &$result)
	Case 12 To 14
msgbox(0, "Que tenga un buen día comiendo", $messagec &$result)
	Case 18 To 21
msgbox(0, "espero que duerma bien", $messaged &$result)
	Case 22 To 23
msgbox(0, "Esperemos que duerma pronto", $messagee &$result)
	Case Else
msgbox(0, "Espero que te sientas bien", "bienvenido a MCY downloader")
EndSwitch
endfunc
;orijinal 
DirCreate("C:\MCY\download\audio")
DirCreate("C:\MCY\download\video")
Menuprogram()
Func Readchanges()
$leercambios = InetGet("https://drive.google.com/uc?id=1cqgiKqYr_z2Ho5Rye3SBbDbT2Y_vkAhK&export=download","changes1.txt",1,1)
While @InetGetActive
TrayTip("Descargando","Bytes = "& @InetGetBytesRead,10,16)
Sleep(1500)
Wend
Local $hForm = GUICreate('Changes ' & StringReplace(@ScriptName, '.au3', '()'), 200, 200, 10, 20, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX), $WS_EX_TOPMOST)
Global $g_idEdit = GUICtrlCreateEdit('', 50, 50, 100, 100, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY))
GUIRegisterMsg($file, 'line')
GUISetState(@SW_SHOW)
_SendMessage($file, $line)
endfunc
Func Window()
run("enjines\youtube-act.exe")
Global $g_hGui, $g_aGuiPos
	$g_hGui = GUICreate("Buscando actualización de YouTubeDl, esto puede tardar un momento", 250, 120)
	$g_hPic = GUICreate("", 80, 50, 25, 30, $WS_POPUp, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $g_hGui)
	GUICtrlCreatePic("..\logo.gif", 0, 0, 0, 0)
	GUISetState(@SW_SHOW, $g_hGui)
	$g_aGuiPos = WinGetPos($g_hGui)
	GUICtrlCreateLabel("looking for updates ...", 25, 16)
	GUICtrlSetTip(-1, "please wait...")
ToolTip("Looking for updates to the YouTubeDl library, this may take a while. Please wait...")
TrayTip("Por favor espera", "Espera mientras se está buscando la actualización de la librería de YouTube", 0, $TIP_ICONASTERISK)
;Plays the music wen downloading YouTubeDlUpdatte
SoundPlay("sounds\soundsdata.dat\bagground.wav",0)
sleep(15000)
SoundSetWaveVolume(40)
endfunc
Func Imputdownload()
$Enlace=InputBox("Introduzca una URL", "Inserte aquí el enlace del vídeo a descargar:", "")
select
case  $Enlace="other" then
SoundPlay("sounds\soundsdata.dat\error.wav",1)
msgbox(0, "Este link es incorrecto", "Has introducido una URL no bálida. Por favor inténtalo.")
case  $Enlace="https://www.youtube.com/" then
msgbox(0, "Descargando", "Espera un momento, estamos buscando el vídeo.")
descargar()
endselect
endfunc
func descargar()
Send("#r")
WinWaitActive("Ejecutar", "", 3)
Send("%temp%\youtube-dl-.exe ")
send($enlace)
send("--prefer-ffmpeg ffmpeg-location PATH ffmpeg.exe --audio-quality 320K (default 5) mp3 --convert-subs srt{enter}")
endfunc
;run("enjines\youtube-dl-.exe $Enlace --prefer-ffmpeg ffmpeg-location PATH ffmpeg.exe --audio-quality 320K (default 5) mp3 --convert-subs srt")
; al pulsar el botón cambios en el menú llama a la función Readchanges()

