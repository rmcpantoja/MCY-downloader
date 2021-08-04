;This is the functions off MCY downloader.
;**please do not touch this file in case you do not have knowledge about programming or technical things.
;Function wen the program is not compiled for use.
Func NotCompiled()
;If the program is not compiled, it plays the sound along with the following message:
If @Compiled Then
selector()
Else
$errorsound = $device.opensound ("sounds/soundsdata.dat/error_not_comp.ogg", true)
$errorsound.play
sleep(500)
;Show error message.
MsgBox($MB_SYSTEMMODAL, "", "You have to compile this program first to run it. Then the program will close now.")
writeinlog("The program is not compiled... Exiting.")
exitpersonaliced()
EndIf
EndFunc
; This is the function to support the MCY Downloader interface. We are going to create a window.
Func Menuprogram()
Local $sDefaultstatus = "Ready"
; We create the window.
$PROGRAMGUI = GUICreate("MCY Downloader " &$program_ver, 500, 500)
; We set the keyboard shortcut to view to the help document.
HotKeySet("{F1}", "playhelp")
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
; Now we will create the menus along with their respective options.
; We add multi-language support.
select
case $grlanguage ="es"
Local $idDownload = GUICtrlCreateMenu("&MCY")
Local $idDownloaditem = GUICtrlCreateMenuItem("Descargar enlace multimedia, listas de reproducción y más...", $idDownload)
Local $idSearchitem = GUICtrlCreateMenuItem("Búsqueda desde youtube", $idDownload)
Local $idRadioitem = GUICtrlCreateMenuItem("Radio", $idDownload)
Local $idOptionsitem = GUICtrlCreateMenuItem("Opciones...", $idDownload)
GUICtrlSetState(-1, $GUI_DEFBUTTON)
Local $idTSmenu = GUICtrlCreateMenu("Herramientas")
Local $idconvitem = GUICtrlCreateMenuItem("Convertir archivos...", $idTSmenu)
Local $idURLitem = GUICtrlCreateMenuItem("Reproducir muestra de audio en línea", $idTSmenu)
Local $idHelpmenu = GUICtrlCreateMenu("Ayuda")
Local $idChanges = GUICtrlCreateMenuItem("Cambios", $idHelpmenu)
Local $idHelpitemc = GUICtrlCreateMenuItem("&Manual de usuario", $idHelpmenu)
Local $idErrorreporting = GUICtrlCreateMenuItem("Errores y sugerencias", $idHelpmenu)
Local $idGitHub = GUICtrlCreateMenuItem("Errores y sugerencias (gitHub)", $idHelpmenu)
Local $idHelpitemb = GUICtrlCreateMenuItem("&Visitar sitio web", $idHelpmenu)
Local $idCheckupdates = GUICtrlCreateMenuItem("Buscar actualizaciones...", $idHelpmenu)
Local $idHelpitema = GUICtrlCreateMenuItem("Acerca de...", $idHelpmenu)
Local $idExititem = GUICtrlCreateMenuItem("&Salir", $idDownload)
GUICtrlCreateMenuItem("", $idDownload, 2)
case $grlanguage ="eng"
Local $idDownload = GUICtrlCreateMenu("&MCY")
Local $idDownloaditem = GUICtrlCreateMenuItem("Download multimedia link, playlists and more...", $idDownload)
Local $idSearchitem = GUICtrlCreateMenuItem("Search from youtube", $idDownload)
Local $idRadioitem = GUICtrlCreateMenuItem("Radio", $idDownload)
Local $idOptionsitem = GUICtrlCreateMenuItem("Options...", $idDownload)
GUICtrlSetState(-1, $GUI_DEFBUTTON)
Local $idTSmenu = GUICtrlCreateMenu("Tools")
Local $idconvitem = GUICtrlCreateMenuItem("Convert files...", $idTSmenu)
Local $idURLitem = GUICtrlCreateMenuItem("Play audio URL online", $idTSmenu)
Local $idHelpmenu = GUICtrlCreateMenu("help")
Local $idChanges = GUICtrlCreateMenuItem("Changes", $idHelpmenu)
Local $idErrorreporting = GUICtrlCreateMenuItem("Errors and suggestions", $idHelpmenu)
Local $idGitHub = GUICtrlCreateMenuItem("Errors and suggestions (gitHub)", $idHelpmenu)
Local $idCheckupdates = GUICtrlCreateMenuItem("Check for updates...", $idHelpmenu)
Local $idHelpitema = GUICtrlCreateMenuItem("About", $idHelpmenu)
Local $idHelpitemb = GUICtrlCreateMenuItem("&Visit website", $idHelpmenu)
Local $idHelpitemc = GUICtrlCreateMenuItem("&User manual", $idHelpmenu)
Local $idExititem = GUICtrlCreateMenuItem("E&xit", $idDownload)
GUICtrlCreateMenuItem("", $idDownload, 2)
endselect
GUICtrlSetState(-1, $GUI_CHECKED)
; Note: All of this now applies language detection.
select
case $grlanguage ="es"
$main1="Abre el menú o explora las siguientes opciones:"
$main2="Abrir menú"
$main3="Manual de usuario"
$main4="Cambios"
$main5="&Salir"
case $grlanguage ="eng"
$main1="Open the menu or explore the following options:"
$main2="Open menu"
$main3="User Manual"
$main4="Changes"
$main5="E&xit"
endselect
GUICtrlCreateLabel($main1,0,100,20,20,$WS_TABSTOP)
GUICtrlSetState(-1, $GUI_FOCUS)
Local $idMenubtn = GUICtrlCreateButton($main2, 10, 150, 20, 20)
Local $idManualbutton = GUICtrlCreateButton($main3, 65, 100, 20, 20)
Local $idChangesbutton = GUICtrlCreateButton($main4, 130, 100, 20, 20)
Local $idGithubBTN = GUICtrlCreateButton("Github", 170, 100, 20, 20)
Local $idExitbutton = GUICtrlCreateButton($main5, 200, 50, 20, 20)
Local $idStatuslabel = GUICtrlCreateLabel($sDefaultstatus, 0, 165, 300, 16, BitOR($SS_SIMPLE, $SS_SUNKEN))
GUISetState(@SW_SHOW)
; Now we are going to give more meaning to each menu option, especially the one chosen by the user.
; Loop until the user exits.
While 1
Switch GUIGetMsg()
Case $idDownloaditem
GUISetState(@SW_Hide, $PROGRAMGUI)
$idDownloaditem = Imputdownload()
writeinlog("Function: download from link...")
Case $idSearchitem
GUISetState(@SW_Hide, $PROGRAMGUI)
Search()
writeinlog("Function: Search.")
case $idRadioitem
Radio()
case $idConvitem
mp3Converter()
case $idURLitem
ReproducirURL()
case $idOptionsitem 
writeinlog("Function: options")
sleep(100)
If $ReadAccs ="yes" Then
$optionsitem = menu_options()
Else
$optionsitem = menu_options2()
EndIf
case $idChanges 
If $ReadAccs ="yes" Then
readchanges()
Else
readchanges2()
EndIf
Case $idErrorreporting
ShellExecute("https://docs.google.com/forms/d/e/1FAIpQLSdDW6LqMKGHjUdKmHkAZdAlgSDilHaWQG9VZjwLz0CJSXKqHA/viewform?usp=sf_link")
case $idGitHub 
ShellExecute("https://github.com/rmcpantoja/MCY-downloader/issues/new")
case $idCheckupdates
writeinlog("Checking components...")
GUIDelete($PROGRAMGUI)
$idCheckupdates = updcomponents()
Case $GUI_EVENT_CLOSE, $idExitbutton, $idExititem
exitpersonaliced()
Case $idHelpitema
; This is the dialogue about the program in which it will be shown on the screen.
select
case $grlanguage ="es"
MsgBox(48, "Acerca de...", "MCY downloader versión " &$program_ver &" beta. Programa desarrollado por mateo cedillo. Este software sirve para descargar multimedia a través de una variedad de sitios. 2018-2021 MT programs.")
case $grlanguage ="eng"
MsgBox(48, "About", "MCY downloader version " &$program_ver &" beta. Program developed by mateo cedillo. This software is used to download multimedia from a variety of sites. 2018-2021 MT programs.")
endselect
continueLoop
case $idHelpitemb
ShellExecute("http://mateocedillo.260mb.net/")
writeinlog("Visited website &$numViews times")
case $idHelpitemc
writeinlog("Exec function: User manual.")
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
EndSwitch
WEnd
GUIDelete()
EndFunc
Func MyErrFunc()
$HexNumber = Hex($oMyError.number, 8)
$oMyRet[0] = $HexNumber
$oMyRet[1] = StringStripWS($oMyError.description, 3)
ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $oMyError.scriptline & "   Description:" & $oMyRet[1] & @LF)
SetError(1) ;something to check for when this function returns
Return
EndFunc   ;==>MyErrFunc
func playhelp()
select
case $grlanguage ="es"
Local $manualdoc = "documentation\manual1.txt"
$editmessage1="Manual del usuario."
$editmessage2="No se encuentra el archivo."
$editmessage3="abriendo..."
$editmessage4="Ocurrió un error al leer el archivo."
$editmessage5="error"
case $grlanguage ="eng"
Local $manualdoc = "documentation\manual2.txt"
$editmessage1="User manual."
$editmessage2="The file cannot be found."
$editmessage3="opening..."
$editmessage4="An error occurred while reading the file."
$editmessage5="error"
endSelect
Local $DocOpen = FileOpen($manualdoc, $FO_READ)
ToolTip($editmessage3)
speaking($editmessage3)
sleep(100)
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
Func ReproducirURL()
global $ENlace = inputBox("Enter URL", "Please enter the direct multimedia link you want to play.")
if $enlace = "" then
MSGBox(48, "Error", "There is no URL!"
Else
PlayDirectAudioURL($ENlace)
EndIf
EndFunc
func menu_options()
; This option is to add the program's options menu, where you can configure everything your way.
$sLanguage = iniRead ("config\config.st", "General settings", "language", "")
$download_dir = iniRead ("config\config.st", "General settings", "Destination folder", "")
$Rpositioning = iniRead ("config\config.st", "Accessibility", "Announce position", "")
select
case $download_dir =""
$download_dir="C:\MCY\Download\Audio"
endSelect
select
case $slanguage ="es"
$omenu_Message="Menú de opciones. Usa flechas arriba y avajo para ir a ellas, y enter para ejecutar una acción."
$omensaje0="Menú de opciones"
$omensaje1 = "Seleccionar calidad de audio"
$omensaje1a="por favor selecciona:"
$omensaje2="Cambiar carpeta de descargas Actualmente " &$download_dir
$omensaje2a="Selecciona la carpeta de destino:"
$omensaje3="Cambiar idioma Idioma actual: " & $sLanguage
$omensaje4="Activar o desactivar accesibilidad mejorada"
$omensaje5="si"
$omensaje6="no"
$omensaje7="Seleccionar lector de pantalla"
$omensaje7a="Qué lector de pantalla quieres usar?"
$omensaje8="Re-organizar audios y videos ahora"
$omensaje9="Guardar archivo de registro (recomendado)"
$omensaje10="Buscar siempre las actualizaciones del programa y de los componentes (recomendado)"
$omensaje10a="Activar / desactivar: "
$omensaje10b="Leer barras de progreso de descarga"
$omensaje10c="Leer tiempo restante estimado de descarga"
$omensaje10d="Pitar para barras de progreso"
$omensaje10e="Vajar el volumen multimedia mientras el lector de pantalla está hablando"
$omensaje10f="Anunciar posición de elementos en menús y en listas"
$omensaje10g="Mostrar consejos"
$omensaje10h="Seleccionar cantidad de resultados de la búsqueda"
$omensaje10i="Borrar configuración"
$omensaje11="Estás seguro?"
$omensaje12="Cerrar este menú"
$menuPos = "de"
case $sLanguage ="eng"
$omenu_Message="Options menu. Use up and down arrows to go to them, and enter to execute an action."
$omensaje0="Options menu"
$omensaje1 = "Select audio quality."
$omensaje1a="please select:"
$omensaje2 = "Change download folder Currently " &$download_dir
$omensaje2a="Select destination folder:"
$omensaje3 = "Change language Currently Language: " & $sLanguage
$omensaje4 = "Enable or disable enhanced accessibility."
$omensaje5 = "yes"
$omensaje6 = "no"
$omensaje7 = "Select screen reader"
$omensaje7a="What screen reader do you want to use?"
$omensaje8 = "Re-organize audios and videos now"
$omensaje9 = "Save log file"
$omensaje10 = "Always check for program and component updates (recommended)"
$omensaje10a="Enable / disable: "
$omensaje10b="Read download progress bars"
$omensaje10c="Read remaining time of download"
$omensaje10d="Beep for progress bars"
$omensaje10e="Down the multimedia volume while the screen reader is speaking"
$omensaje10f="Announce position of items in menus and in lists"
$omensaje10g="Show tips"
$omensaje10h="Select quantity of search results"
$omensaje10i="Clear settings"
$omensaje11 = "Are you sure?"
$omensaje12 = "Close this menu."
$menuPos = "of"
endselect
$okmessaje="OK"
$p_options=reader_Create_Menu($Omenu_message, $omensaje1 & "," &$omensaje2 & "," &$omensaje3 & "," &$omensaje4 & "," &$omensaje7 & "," &$omensaje8 & "," &$omensaje9 & "," &$omensaje10 & "," &$omensaje10a&$omensaje10b & "," &$omensaje10a &$omensaje10c & "," &$omensaje10a &$omensaje10d & "," &$omensaje10a &$omensaje10e & "," &$omensaje10a &$omensaje10f & "," &$omensaje10g & "," &$omensaje10h & "," &$omensaje10i & "," &$omensaje12, $Rpositioning, $menuPos)
select
case $p_options = 1
$Bitrate=reader_Create_Menu($omensaje1a, "128 kbps,160 kbps,192 kbps,224 kbps,256 kbps,320 kbps,384 kbps(experimental", $Rpositioning, $menuPos)
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
Local $d_path = FileSelectFolder($omensaje2a,$download_dir)
speaking($d_path)
IniWrite("config\config.st", "General settings", "Destination folder", $d_path)
case $p_options = 3
$configureaccs = iniRead ("config\config.st", "accessibility", "Enable enanced accessibility", "")
$windowslanguage= @OSLang
;Spanish languages:
select
case $windowslanguage = "0c0a" or $windowslanguage = "040a" or $windowslanguage = "080a" or $windowslanguage = "100a" or $windowslanguage = "140a" or $windowslanguage = "180a" or $windowslanguage = "1c0a" or $windowslanguage = "200a" or $windowslanguage = "240a" or $windowslanguage = "280a" or $windowslanguage = "2c0a" or $windowslanguage = "300a" or $windowslanguage = "340a" or $windowslanguage = "380a" or $windowslanguage = "3c0a" or $windowslanguage = "400a" or $windowslanguage = "440a" or $windowslanguage = "480a" or $windowslanguage = "4c0a" or $windowslanguage = "500a"
$menu_lang=reader_Create_Menu("Por favor selecciona tu idioma", "Español,Inglés,Volver", $Rpositioning, $menuPos)
;English languages:
case $windowslanguage = "0809" or $windowslanguage = "0c09" or $windowslanguage = "1009" or $windowslanguage = "1409" or $windowslanguage = "1809" or $windowslanguage = "1c09" or $windowslanguage = "2009" or $windowslanguage = "2409" or $windowslanguage = "2809" or $windowslanguage = "2c09" or $windowslanguage = "3009" or $windowslanguage = "3409" or $windowslanguage = "0425" or 
$menu_lang=reader_Create_Menu("Please select your language", "Spanish,English,Back", $Rpositioning, $menuPos)
case else
$menu_lang=reader_Create_Menu("Please select your language", "Spanish,English,back", $Rpositioning, $menuPos)
endselect
select
case $menu_lang = 1
IniDelete ( "config\config.st", "General settings", "language")
sleep(100)
IniWrite("config\config.st", "General settings", "language", "es")
$language="1"
MsgBox(48, "Información", "Por favor, reinicia MCY Downloader para que los cambios del idioma tengan efecto.")
case $menu_lang = 2
IniDelete ( "config\config.st", "General settings", "language")
sleep(100)
IniWrite ("config\config.st", "General settings", "language", "eng")
$language="2"
MsgBox(48, "Information", "Please restart MCY Downloader for the language changes to take effect.")
EndSelect
;case $menu_lang = 3
;$s_selected = $device.opensound ("sounds/soundsdata.dat/selected.ogg", true)
;$s_selected.play
;speaking($okmessaje)
case $p_options = 4
$en_a=reader_Create_Menu($omensaje1a, $omensaje5 & "," &$omensaje6, $Rpositioning, $menuPos)
select
case $en_a = 1
IniWrite("config\config.st", "accessibility", "Enable enanced accessibility", "Yes")
case $en_a = 2
IniWrite("config\config.st", "accessibility", "Enable enanced accessibility", "No")
endselect
case $p_options = 5
$SpeakWh=Reader_Create_Menu($omensaje7a, "NVDA,JAWS,sapi5", $Rpositioning, $menuPos)
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
$menu_log=reader_Create_Menu($omensaje1a, $omensaje5 & "," &$omensaje6, $Rpositioning, $menuPos)
select
case $menu_log = 1
IniWrite("config\config.st", "General settings", "Sabe Logs", "Yes")
case $menu_log = 2
IniWrite("config\config.st", "General settings", "Sabe Logs", "No")
endselect
case $p_options = 8
$menu_update=reader_Create_Menu($omensaje1a, $omensaje5 & "," &$omensaje6, $Rpositioning, $menuPos)
select
case $menu_Update = 1
IniWrite("config\config.st", "General settings", "Check updates", "Yes")
case $menu_update = 2
IniWrite("config\config.st", "General settings", "Check updates", "No")
endselect
case $p_options = 9
$m_progress=reader_Create_Menu($omensaje1a, $omensaje5 & "," &$omensaje6, $Rpositioning, $menuPos)
select
case $m_progress = 1
iniWrite ("config\config.st", "Accessibility", "Read download progress bar", "Yes")
case $m_progress = 2
iniWrite ("config\config.st", "Accessibility", "Read download progress bar", "No")
EndSelect
case $p_options = 10
$m_time=reader_Create_Menu($omensaje1a, $omensaje5 & "," &$omensaje6, $Rpositioning, $menuPos)
select
case $m_time = 1
iniWrite ("config\config.st", "Accessibility", "Read download remaining time", "Yes")
case $m_time = 2
iniWrite ("config\config.st", "Accessibility", "Read download remaining time", "No")
EndSelect
case $p_options = 11
$PBeep=reader_Create_Menu($omensaje1a, $omensaje5 & "," &$omensaje6, $Rpositioning, $menuPos)
select
case $PBeep = 1
iniWrite ("config\config.st", "Accessibility", "Beep for progress bars", "Yes")
case $PBeep = 2
iniWrite ("config\config.st", "Accessibility", "Beep for progress bars", "No")
EndSelect
case $p_options = 12
$audioDuck=reader_Create_Menu($omensaje1a, $omensaje5 &"," &$omensaje6, $Rpositioning, $menuPos)
select
case $audioDuck = 1
iniWrite ("config\config.st", "Accessibility", "Audio ducking", "Yes")
case $AudioDuck = 2
iniWrite ("config\config.st", "Accessibility", "Audio ducking", "No")
EndSelect
case $p_options = 13
$AnouncePositions=reader_Create_Menu($omensaje1a, $omensaje5 &"," &$omensaje6, $Rpositioning, $menuPos)
select
case $AnouncePositions = 1
iniWrite ("config\config.st", "Accessibility", "Announce position", "1")
case $AnouncePositions = 2
iniWrite ("config\config.st", "Accessibility", "Announce position", "0")
EndSelect
case $p_options = 14
$showtips=reader_Create_Menu($omensaje1a, $omensaje5 &"," &$omensaje6, $Rpositioning, $menuPos)
select
case $showtips = 1
iniWrite ("config\config.st", "misc", "Show tips", "1")
case $showtips = 2
iniWrite ("config\config.st", "misc", "Show tips", "0")
EndSelect
case $p_options = 15
$qsearch=reader_Create_Menu($omensaje1a, "5,10,25,50,75,100,150,200,250,300", $Rpositioning, $menuPos)
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
$confirmarborrado=reader_Create_Menu($omensaje11, $omensaje5 & "," &$omensaje6, $Rpositioning, $menuPos)
select
case $confirmarborrado ="1"
DirRemove(@ScriptDir & "\config", 1)
MsgBox(48, "Information", "Please restart MCY Downloader for the language changes to take effect.")
Exitpersonaliced()
case $confirmarborrado ="2"
Menu_options()
EndSelect
case $p_options = 17
$s_selected = $device.opensound ("sounds/soundsdata.dat/selected.ogg", true)
$s_selected.play
speaking($okmessaje)
EndSelect
EndFunc
Func _IsChecked($idControlID)
Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc
Func Menu_Options2()
$sLanguage = iniRead ("config\config.st", "General settings", "language", "")
$download_dir = iniRead ("config\config.st", "General settings", "Destination folder", "")
select
case $download_dir =""
$download_dir="C:\MCY\Download\Audio"
endSelect
Dim $aArray[0]
Dim $bArray[0]
Select
case $sLanguage ="es"
$mensaje0="Menú de opciones"
$mensaje1="Seleccionar calidad de mp3."
$mensaje1a="por favor selecciona:"
$mensaje2="Cambiar carpeta de descargas, Actualmente " &$download_dir
$mensaje2a="Selecciona la carpeta de destino:"
$mensaje3="Cambiar idioma, Idioma actual: " & $sLanguage
$mensaje4="Activar o desactivar accesibilidad mejorada."
$mensaje5="si"
$mensaje6="no"
$mensaje8="Re-organizar audios y videos ahora"
$mensaje9="Guardar archivo de registro (recomendado)"
$mensaje10="Buscar siempre las actualizaciones del programa y de los componentes (recomendado)"
$mensaje10a="Mostrar consejos"
$mensaje10b="Seleccionar cantidad de resultados de la búsqueda"
$mensaje10c="Borrar configuración"
$mensaje11="Cerrar este menú."
$mensaje12="Estás seguro?"
case $sLanguage ="eng"
$mensaje0="Options menu"
$mensaje1 = "Select mp3 quality."
$mensaje1a="please select:"
$mensaje2 = "Change download folder, Currently " &$download_dir
$mensaje2a="Select destination folder:"
$mensaje3 = "Change language, Currently Language: " & $sLanguage
$mensaje4 = "Enable or disable enhanced accessibility."
$mensaje5 = "yes"
$mensaje6 = "no"
$mensaje8 = "Re-organize audios and videos now"
$mensaje9 = "Save log file"
$mensaje10 = "Always check for program and component updates (recommended)"
$mensaje10a="Show tips"
$mensaje10b="Select quantity of search results"
$mensaje10c="Clear settings"
$mensaje11 = "Close this menu."
$mensaje12 = "Are you sure?"
endselect
$okmessaje="OK"
$guioptions = GuiCreate($mensaje0)
$iRadio_Count = 7
GUICtrlCreateGroup($mensaje1, 20, 10, 100, 60)
Local $idBtr1 = GUICtrlCreateRadio("128KBPS", 30, 30, 120, 30)
Local $idBtr2 = GUICtrlCreateRadio("160KBPS", 30, 50, 120, 30)
Local $idBtr3 = GUICtrlCreateRadio("192KBPS", 30, 70, 120, 30)
Local $idBtr4 = GUICtrlCreateRadio("224KBPS", 30, 90, 120, 30)
Local $idBtr5 = GUICtrlCreateRadio("256KBPS", 30, 130, 120, 30)
Local $idBtr6 = GUICtrlCreateRadio("320KBPS", 30, 150, 120, 30)
Local $idBtr7 = GUICtrlCreateRadio("384KBPS", 30, 170, 120, 30)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState($idBTR7, $GUI_CHECKED)
local $BTNChooseF = GUICtrlCreateButton($mensaje2, 50, 200, 120, 25)
$lang_Label = GUICtrlCreateLabel($mensaje3, 60, 200, 120, 25)
$idComboBox = GUICtrlCreateCombo("Spanish", 60, 200, 150, 30, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData($idComboBox, "English", "Spanish")
$accs_Label = GUICtrlCreateLabel($mensaje4, 90, 200, 120, 25)
$idComboBox2 = GUICtrlCreateCombo("On", 60, 260, 150, 30, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData($idComboBox2, "Off", "Off")
$search_Label = GUICtrlCreateLabel($mensaje10b, 115, 200, 120, 25)
$idQsearch = GUICtrlCreateCombo("5", 60, 280, 150, 30, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData($idQsearch, "10|25|50|75|100|150|200|250|300")
local $BTN_ReOrder = GUICtrlCreateButton($mensaje8, 120, 200, 180, 25)
Local $idSabeLogs = GUICtrlCreateCheckbox($mensaje9, 150, 200, 185, 25)
Local $idCheckupds = GUICtrlCreateCheckbox($mensaje10, 250, 200, 185, 25)
Local $idShowtips = GUICtrlCreateCheckbox($mensaje10a, 285, 200, 185, 25)
Local $idBTN_Clean = GUICtrlCreateButton($mensaje10c, 325, 200, 185, 25)
Local $idBTN_Close = GUICtrlCreateButton($mensaje11, 400, 200, 185, 25)
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
Local $d_path = FileSelectFolder($mensaje2a,$download_dir)
speaking($d_path)
IniWrite("config\config.st", "General settings", "Destination folder", $d_path)
Case $idMsg = $idComboBox
$sComboRead = GUICtrlRead($idComboBox)
select
case $sComboRead = "Spanish"
IniDelete ( "config\config.st", "General settings", "language")
sleep(100)
IniWrite("config\config.st", "General settings", "language", "es")
$language="1"
MsgBox(48, "Información", "Por favor, reinicia MCY Downloader para que los cambios del idioma tengan efecto.")
case $sComboRead = "English"
IniDelete ( "config\config.st", "General settings", "language")
sleep(100)
IniWrite ("config\config.st", "General settings", "language", "eng")
$language="2"
MsgBox(48, "Information", "Please restart MCY Downloader for the language changes to take effect.")
EndSelect
Case $idMsg = $idComboBox2
$sComboRead = GUICtrlRead($idComboBox2)
IniWrite("config\config.st", "accessibility", "Enable enanced accessibility", $sComboRead)
MsgBox(48, "Information", "Please restart MCY Downloader for the changes to take effect.")
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
$confirmarborrado = MsgBox(4, $mensaje10c, $mensaje12)
select
case $confirmarborrado = 6
DirRemove(@ScriptDir & "\config", 1)
select
Case $grlanguage="es"
MsgBox(48, "Información", "Por favor reinicia MCY Downloader para que los cambios surtan efecto.")
Case $grlanguage="eng"
MsgBox(48, "Information", "Please restart MCY Downloader for the changes to take effect.")
EndSelect
Exitpersonaliced()
EndSelect
Case $idMsg = $idBTN_Close
guiDelete($guioptions)
ExitLoop
EndSelect
WEnd
endfunc