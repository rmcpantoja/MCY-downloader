func PlayDirectAudioURL($url)
HotKeySet("{i}", "info")
$player_window = GUICreate("MCY Downloader: Playing " &$url)
Global $BASS_PAUSE_POS
global $Volume="100"
StartAudio()
endfunc
Func StartAudio()
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
$grlanguage = iniRead ("config\config.st", "General settings", "language", "")
Select
case $grlanguage ="es"
$rmessage1="Usa las flechas para navegar por los controles multimedia: "
$rmessage2="Cambiar volumen"
$rmessage3="Reproducir"
$rmessage4="Pausar"
$rmessage5="Detener"
$rmessage6="Nombre de audio"
$rmessage7="Cerrar este menú"
$rmessage8="El verdadero nombre de tu enlace es: "
$rmessage9="Cancelado"
$rmessage10="Volumen de muestra establecido al "
$rmessage11="No hay información."
$rmessage12="Abrir el menú"
$rmessage13="Volver a la aplicación"
case $grlanguage ="eng"
$rmessage1="Use the arrows to navigate the multimedia controls: "
$rmessage2="change volume"
$rmessage3="Play"
$rmessage4="Pause"
$rmessage5="Stop"
$rmessage6="File info"
$rmessage7="close this menu"
$rmessage8="the real name of your audio is:"
$rmessage9="cancelled"
$rmessage10="Sample volume set to "
$rmessage11="There is no information"
$rmessage12="Open menu"
$rmessage13="Close"
endSelect
Local $MusicHandle
local $info1
_Audio_init_start()
$MusicHandle = _Set_url($Enlace)
_Audio_play($MusicHandle)
Local $idMenu = GUICtrlCreateButton($rmessage12, 90, 50, 70, 25)
Local $idBtn_Close = GUICtrlCreateButton($rmessage13, 140, 50, 70, 25)
GUISetState(@SW_SHOW)
global const $info1 = _Get_streamtitle($MusicHandle)
; Loop until the user exits.
While 1
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE, $idBtn_Close
guiDelete()
_Audio_stop($MusicHandle)
_Audio_init_stop($MusicHandle)
Case $idMenu
$menutab = Reader_Create_Menu($rmessage1, $rmessage2 & "," &$rmessage3 & "," &$rmessage4 & "," &$rmessage5 & "," &$rmessage6 & "," &$rmessage7)
select
case $menutab = 1
$volumeSlider = Reader_create_menu($rmessage2 &": slider 100", "actual (100), 0, 10, 20, 30, 40, 50, 60, 70, 80, 90")
select
case $volumeSlider = "1"
Speaking($rmessage9)
case $volumeSlider = "2"
_Set_volume(0)
$volume="0"
speaking($rmessage10 &"0%.")
case $volumeSlider = "3"
_Set_volume(10)
$volume="10"
speaking($rmessage10 &"10%.")
case $volumeSlider = "4"
_Set_volume(20)
$volume="20"
speaking($rmessage10 &"20%.")
case $volumeSlider = "5"
_Set_volume(30)
$volume="30"
speaking($rmessage10 &"30%.")
case $volumeSlider = "6"
_Set_volume(40)
$volume="40"
speaking($rmessage10 &"40%.")
case $volumeSlider = "7"
_Set_volume(50)
$volume="50"
speaking($rmessage10 &"50%.")
case $volumeSlider = "8"
_Set_volume(60)
$volume="60"
speaking($rmessage10 &"60%.")
case $volumeSlider = "9"
_Set_volume(70)
$volume="70"
speaking($rmessage10 &"70%.")
case $volumeSlider = "10"
_Set_volume(80)
$volume="80"
speaking($rmessage10 &"80%.")
case $volumeSlider = "11"
_Set_volume(90)
$volume="90"
speaking($rmessage10 &"90%.")
endselect
case $menutab = 2
_Audio_play($MusicHandle)
case $menutab = 3
_Audio_pause($MusicHandle)
case $menutab = 4
_Audio_stop($MusicHandle)
case $menutab = 5
_Set_volume(25)
speaking($rmessage8 &$info1)
if $info1 = "0" then
speaking($rmessage11)
endif
_Set_volume($volume)
endselect
EndSwitch
WEnd
_Audio_init_stop($MusicHandle)
EndFunc
func info()
;local $info2 = _Get_streamtitle($MusicHandle)
$MusicHandle = _Set_url($ENlace)
_Set_volume(25)
Sleep(300)
speaking("stream/song name: " &_Get_streamtitle($MusicHandle))
if $info1 = "0" then
speaking("no song is playing")
endif
_Set_volume($volume)
endfunc