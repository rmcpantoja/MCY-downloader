#include <guiConstants.au3>
#include "include\log.au3"
#include "include\reader.au3"
#include "include\radio.au3"
$inputUrl = "https://www.youtube.com/watch?v=x10_H4KvGk0"
Global $sYouTube_DL = IniRead("config\config.st", 'General Settings', 'Youtube-DL', 'engines64\youtube-dl-.exe')
local $enlaceareproducir
guicreate("reproduciendo")
Guisetstate(@SW_SHOW)
Local $iPID = Run(@ComSpec & ' /C "' & $sYouTube_DL & '" -g ' &$inputUrl, @ScriptDir, @SW_HIDE, 6)
ProcessWaitClose($iPID)
$enlaceareproducir = StdoutRead($iPID)
$separar = StringSplit($enlaceareproducir,@lf)
If @Error Then return 0
$seleccion = $separar[1]
msgbox(0, "cómo quedó", $seleccion)
if not StringInStr($enlaceareproducir, "https://") then
MsgBox(0, "error" ,"No se reconoce él URL")
;ExitLoop
EndIf
writeinlog(@crlf &"Selection: " &$seleccion)
speaking($seleccion)
Local $MusicHandle
_Audio_init_start()
$youtubereproduce = $seleccion &@lf
$MusicHandle = _Set_url($youtubereproduce)
if @error then
MSGBox(0, "error", "imposible cargar. Razón: " &@extended)
Exit
EndIf
_Audio_play($MusicHandle)
Local $idBtn_Stop = GUICtrlCreateButton("stop", 140, 50, 70, 25)
While 1
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE, $idBtn_Stop
guiDelete()
_Audio_stop($MusicHandle)
_Audio_init_stop($MusicHandle)
Sleep(1000)
Exit
EndSwitch
WEnd
