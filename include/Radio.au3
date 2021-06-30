#include <Bass.au3>
#include <BassConstants.au3>
;#include <GUIConstantsEx.au3>
#include "WindowsConstants.au3"
#include <menu_nvda.au3>
func radio()
HotKeySet("{i}", "sayinfo")
$Window_radio = GUICreate("¡MCY Radio")
Global $BASS_PAUSE_POS
$VolLevel="100"
Example()
endfunc
Func Example()
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
$grlanguage = iniRead ("config\config.st", "General settings", "language", "")
Select
case $grlanguage ="es"
$rmessage1="usa flechas izzquierda y derecha para navegar por las opciones"
$rmessage2="Cambiar volumen"
$rmessage3="Reproducir"
$rmessage4="Pausar"
$rmessage5="Detener"
$rmessage6="Nombre de transmisión/canción"
$rmessage7="Cerrar este menú"
$rmessage8="Nombre de transmisión / canción: "
$rmessage9="Cancelado"
$rmessage10="Volumen de música establecido al "
$rmessage11="Nose está reproduciendo ninguna canción"
$rmessage12="Abrir el menú"
$rmessage13="Cerrar"
$rmessage14="Pulsa alt para abrir el menú"
$rmessage15="Obtener versión para Android"
case $grlanguage ="eng"
$rmessage1="use left and right arrows to navigate through options"
$rmessage2="change volume"
$rmessage3="Play"
$rmessage4="Pause"
$rmessage5="Stop"
$rmessage6="stream/song info"
$rmessage7="close this menu"
$rmessage8="stream/song name: "
$rmessage9="cancelled"
$rmessage10="music volume set to "
$rmessage11="no song is playing"
$rmessage12="Open menu"
$rmessage13="Close"
$rmessage14="Press alt to open the menu."
$rmessage15="Get version for Android"
endSelect
Local $MusicHandle
local $info1
_Audio_init_start()
$MusicHandle = _Set_url("")
_Audio_play($MusicHandle)
$EMPTY_STRING = ""
Local $idMenu = GUICtrlCreateButton($rmessage12, 90, 50, 70, 25)
Local $idInfo = GUICtrlCreateButton($rmessage6, 110, 50, 70, 25)
Local $idBtn_Close = GUICtrlCreateButton($rmessage13, 140, 50, 70, 25)
$label = GUICtrlCreateLabel($rmessage14, 0,100,20,20,$WS_TABSTOP)
GUISetState(@SW_SHOW)
global const $info1 = _Get_streamtitle($MusicHandle)
; Loop until the user exits.
While 1
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE, $idBtn_Close
guiDelete($Window_radio)
_Audio_stop($MusicHandle)
_Audio_init_stop($MusicHandle)
Case $idInfo
Sleep(500)
MsgBox(0, $rmessage8, $info1)
Case $idMenu
$menutab = Reader_Create_Menu($rmessage1, $rmessage2 & "," &$rmessage3 & "," &$rmessage4 & "," &$rmessage5 & "," &$rmessage6 & "," &$rmessage15 & "," &$rmessage7)
select
case $menutab = 1
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
case $menutab = 2
_Audio_play($MusicHandle)
case $menutab = 3
_Audio_pause($MusicHandle)
case $menutab = 4
_Audio_stop($MusicHandle)
case $menutab = 5
;_Audio_init_stop($MusicHandle)
speaking($rmessage8 &$info1)
if $info1 = "0" then
speaking($rmessage11)
endif
case $menutab = 6
ShellExecute("http://mateocedillo.260mb.net/MCY_Radio.zip")
endselect
EndSwitch
WEnd
_Audio_init_stop($MusicHandle)
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