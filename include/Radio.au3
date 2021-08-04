#include-once
#include <Bass.au3>
#include <BassConstants.au3>
;#include <GUIConstantsEx.au3>
#include "WindowsConstants.au3"
#include <menu_nvda.au3>
func radio()
HotKeySet("{i}", "sayinfo")
global $Window_radio = GUICreate("¡MCY Radio")
Global $BASS_PAUSE_POS
$VolLevel="100"
Example()
endfunc
Func Example()
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
$grlanguage = iniRead ("config\config.st", "General settings", "language", "")
$ultimaURLCargada = iniRead ("config\config.st", "Misc", "Last radio loaded", "")
Select
case $grlanguage ="es"
global $rmessage1="usa flechas izzquierda y derecha para navegar por las opciones"
global $rmessage1a="Selector de radios"
global $rmessage1b="Lista de radios, usa las flechas para navegar entre las disponibles y enter para encender."
global $rmessage2="Cambiar volumen"
global $rmessage3="Reproducir"
global $rmessage4="Pausar"
global $rmessage5="Detener"
global $rmessage6="Nombre de transmisión/canción"
global $rmessage7="Cerrar este menú"
global $rmessage8="Nombre de transmisión / canción: "
global $rmessage9="Cancelado"
global $rmessage10="Volumen de música establecido al "
global $rmessage11="Nose está reproduciendo ninguna canción"
global $rmessage12="Abrir el menú"
global $rmessage13="Cerrar"
global $rmessage14="Pulsa alt para abrir el menú"
global $rmessage15="Obtener versión para Android"
global $rmessage16="error"
global $rmessage17="imposible cargar la URL. Razón: "
case $grlanguage ="eng"
global $rmessage1="use left and right arrows to navigate through options"
global $rmessage1a="Radio selector"
global $rmessage1b="List of radios, use the arrows to navigate between the available ones and enter to turn on."
global $rmessage2="change volume"
global $rmessage3="Play"
global $rmessage4="Pause"
global $rmessage5="Stop"
global $rmessage6="stream/song info"
global $rmessage7="close this menu"
global $rmessage8="stream/song name: "
global $rmessage9="cancelled"
global $rmessage10="music volume set to "
global $rmessage11="no song is playing"
global $rmessage12="Open menu"
global $rmessage13="Close"
global $rmessage14="Press alt to open the menu."
global $rmessage15="Get version for Android"
global $rmessage16="error"
global $rmessage17="The URL cannot be loaded. Reason: "
endSelect
Global $MusicHandle
Global $info1
_Audio_init_start()
select 
case $ultimaURLCargada =""
iniWrite ("config\config.st", "Misc", "Last radio loaded", "https://stream.zeno.fm/qhpfuuaq11zuv")
EndSelect
$MusicHandle = _Set_url(iniRead ("config\config.st", "Misc", "Last radio loaded", ""))
;if @error then
;MSGBox(0, $rmessage16, $rmessage17 &@extended)
;guiDelete($Window_radio)
;_Audio_stop($MusicHandle)
;_Audio_init_stop($MusicHandle)
;EndIf
_Audio_play($MusicHandle)
Local $idMenu = GUICtrlCreateButton($rmessage12, 90, 50, 70, 25)
Local $idInfo = GUICtrlCreateButton($rmessage6, 110, 50, 70, 25)
Local $idBtn_Close = GUICtrlCreateButton($rmessage13, 140, 50, 70, 25)
$label = GUICtrlCreateLabel($rmessage14, 0,100,20,20,$WS_TABSTOP)
GUISetState(@SW_SHOW)
global $info1 = _Get_streamtitle($MusicHandle)
; Loop until the user exits.
While 1
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE, $idBtn_Close
guiDelete($Window_radio)
_Audio_stop($MusicHandle)
_Audio_init_stop($MusicHandle)
ExitLoop
Case $idInfo
Sleep(500)
MsgBox(0, $rmessage8, $info1)
Case $idMenu
menublind()
EndSwitch
WEnd
_Audio_init_stop($MusicHandle)
EndFunc
func menublind()
$menutab = Reader_Create_Menu($rmessage1, $rmessage1a & "," &$rmessage2 & "," &$rmessage3 & "," &$rmessage4 & "," &$rmessage5 & "," &$rmessage6 & "," &$rmessage15 & "," &$rmessage7)
select
case $menutab = 1
$radioseleccionada = Reader_create_menu($rmessage1b, "Blaster radio,Default,back")
select
case $radioseleccionada = "1"
_Audio_stop($MusicHandle)
_Audio_init_stop($MusicHandle)
iniWrite ("config\config.st", "Misc", "Last radio loaded", "https://blasterradio.net/blaster")
sleep(100)
_Audio_init_start()
_Audio_play(iniRead ("config\config.st", "Misc", "Last radio loaded", ""))
case $radioseleccionada = "2"
_Audio_stop($MusicHandle)
_Audio_init_stop($MusicHandle)
iniWrite ("config\config.st", "Misc", "Last radio loaded", "https://stream.zeno.fm/qhpfuuaq11zuv")
sleep(100)
_Audio_init_start()
_Audio_play(iniRead ("config\config.st", "Misc", "Last radio loaded", ""))
case $radioseleccionada = "3"
Speaking("cancelled")
EndSelect
case $menutab = 2
$volumeSlider = Reader_create_menu($rmessage2 &": slider 100", "actual (100), 0, 10, 20, 30, 40, 50, 60, 70, 80, 90")
select
case $volumeSlider = "1"
Speaking($rmessage9)
case $volumeSlider = "2"
_Set_volume(0)
speaking($rmessage10 &"0%.")
case $volumeSlider = "3"
_Set_volume(10)
speaking($rmessage10 &"10%.")
case $volumeSlider = "4"
_Set_volume(20)
speaking($rmessage10 &"20%.")
case $volumeSlider = "5"
_Set_volume(30)
speaking($rmessage10 &"30%.")
case $volumeSlider = "6"
_Set_volume(40)
speaking($rmessage10 &"40%.")
case $volumeSlider = "7"
_Set_volume(50)
speaking($rmessage10 &"50%.")
case $volumeSlider = "8"
_Set_volume(60)
speaking($rmessage10 &"60%.")
case $volumeSlider = "9"
_Set_volume(70)
speaking($rmessage10 &"70%.")
case $volumeSlider = "10"
_Set_volume(80)
speaking($rmessage10 &"80%.")
case $volumeSlider = "11"
_Set_volume(90)
speaking($rmessage10 &"90%.")
endselect
case $menutab = 3
_Audio_play($MusicHandle)
case $menutab = 4
_Audio_pause($MusicHandle)
case $menutab = 5
_Audio_stop($MusicHandle)
case $menutab = 6
speaking($rmessage8 &$info1)
if $info1 = "0" then
speaking($rmessage11)
endif
case $menutab = 7
ShellExecute("http://mateocedillo.260mb.net/MCY_Radio_android.zip")
endselect
EndFunc
func sayinfo()
;local $info2 = _Get_streamtitle($MusicHandle)
$MusicHandle = _Set_url("https://stream.zeno.fm/qhpfuuaq11zuv")
Sleep(300)
speaking("stream/song name: " &_Get_streamtitle($MusicHandle))
if $info1 = "0" then
speaking("no song is playing")
endif
endfunc
Func _Audio_init_start()
If _BASS_STARTUP(@ScriptDir & "\bass.dll") Then
If _BASS_Init(0, -1, 44100, 0) Then
If _BASS_SetConfig($BASS_CONFIG_NET_PLAYLIST, 1) = 0 Then
SetError(3)
EndIf
Else
SetError(2)
EndIf
Else
SetError(@error)
EndIf
EndFunc

Func _Set_buffer($buffer)
_BASS_SetConfig($BASS_CONFIG_NET_BUFFER, $buffer)
EndFunc

Func _Audio_stop($MusicHandle)
_BASS_ChannelStop($MusicHandle)
EndFunc

Func _Audio_play($MusicHandle)
_BASS_ChannelPlay($MusicHandle, 1)
EndFunc

Func _Audio_pause($MusicHandle)
If _Get_playstate($MusicHandle) = 2 Then
$BASS_PAUSE_POS = _BASS_ChannelGetPosition($MusicHandle, $BASS_POS_BYTE)
_BASS_ChannelPause($MusicHandle)
ElseIf _Get_playstate($MusicHandle) = 3 Then
_Audio_play($MusicHandle)
_BASS_ChannelSetPosition($MusicHandle, $BASS_PAUSE_POS, $BASS_POS_BYTE)
EndIf
EndFunc

Func _Audio_init_stop($MusicHandle)
_BASS_StreamFree($MusicHandle)
_BASS_Free()
EndFunc

Func _Set_url($file)
If FileExists($file) Then
$MusicHandle = _BASS_StreamCreateFile(False, $file, 0, 0, 0)
Else
$MusicHandle = _BASS_StreamCreateURL($file, 0, 1)
EndIf
If @error Then
Return SetError(1)
EndIf
Return $MusicHandle
EndFunc

Func _Get_pos($MusicHandle)
$current = _BASS_ChannelGetPosition($MusicHandle, $BASS_POS_BYTE)
Return Round(_Bass_ChannelBytes2Seconds($MusicHandle, $current))
EndFunc

Func _Get_len($MusicHandle)
$current = _BASS_ChannelGetLength($MusicHandle, $BASS_POS_BYTE)
Return Round(_Bass_ChannelBytes2Seconds($MusicHandle, $current))
EndFunc

Func _Set_pos($MusicHandle, $seconds)
_BASS_ChannelSetPosition($MusicHandle, _BASS_ChannelSeconds2Bytes($MusicHandle, $seconds), $BASS_POS_BYTE)
EndFunc

Func _Set_volume($volume)
_BASS_SetConfig($BASS_CONFIG_GVOL_STREAM, $volume * 100)
EndFunc

Func _Get_volume()
Return _BASS_GetConfig($BASS_CONFIG_GVOL_STREAM) / 100
EndFunc

Func _Get_bitrate($MusicHandle)
$a = Round(_Bass_ChannelBytes2Seconds($MusicHandle, _BASS_ChannelGetLength($MusicHandle, $BASS_POS_BYTE)))
$return = Round(_BASS_StreamGetFilePosition($MusicHandle, $BASS_FILEPOS_END) * 8/ $a/ 1000)
If StringInStr($return, "-") Then
$return = _BASS_StreamGetFilePosition($MusicHandle, $BASS_FILEPOS_END) * 8 / _BASS_GetConfig($BASS_CONFIG_NET_BUFFER)
EndIf
Return $return
EndFunc

Func _Get_playstate($MusicHandle)
Switch _BASS_ChannelIsActive($MusicHandle)
Case $BASS_ACTIVE_STOPPED
$returnstate = 1
Case $BASS_ACTIVE_PLAYING
$returnstate = 2
Case $BASS_ACTIVE_PAUSED
$returnstate = 3
Case $BASS_ACTIVE_STALLED
$returnstate = 4
EndSwitch
Return $returnstate
EndFunc

Func _Get_streamtitle($MusicHandle)
$pPtr = _BASS_ChannelGetTags($MusicHandle, $BASS_TAG_META)
$sStr = _BASS_PtrStringRead($pPtr)
If StringInStr($sStr, ";") Then
$infosplit = StringSplit($sStr, ";")
$infosplit[1] = StringReplace($infosplit[1], "'", "")
$infosplit[1] = StringReplace($infosplit[1], "StreamTitle=", "")
If StringInStr($infosplit[1], "-") Then
Return $infosplit[1]
EndIf
EndIf
EndFunc