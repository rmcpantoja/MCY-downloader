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
sleep(3000)
$separar = StringSplit($enlaceareproducir,@lf)
If @Error Then return 0
$seleccion = $separar[1]
msgbox(0, "cómo quedó", $seleccion)
if not StringInStr($enlaceareproducir, "https://") then
MsgBox(0, "error" ,"No se reconoce él URL")
EndIf
writeinlog(@crlf &"Selection: " &$seleccion)
speaking($seleccion)
Local $MusicHandle
_Audio_init_start()
$youtubereproduce = $seleccion &@lf
$MusicHandle = _Set_url("https://r1---sn-xu525-j0xz.googlevideo.com/videoplayback?expire=1628026832&ei=cGMJYdPJLf7Ij-8PlaeU-AY&ip=191.100.126.159&id=o-APbiprb8gVRvIrERldcOQoTeQfd6Y-8B-03DsItzentu&itag=140&source=youtube&requiressl=yes&mh=Mf&mm=31%2C29&mn=sn-xu525-j0xz%2Csn-cvb7ln7z&ms=au%2Crdu&mv=m&mvi=1&pcm2cms=yes&pl=21&initcwndbps=651250&vprv=1&mime=audio%2Fmp4&ns=SncLOXCALzH6x1D5IDtZTgQG&gir=yes&clen=54550625&dur=3370.631&lmt=1611408120720337&mt=1628004791&fvip=6&keepalive=yes&fexp=24001373%2C24007246&c=WEB&txp=5531432&n=o0DYzlo5gjUCrzzDv&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cns%2Cgir%2Cclen%2Cdur%2Clmt&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpcm2cms%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRQIhAI9snmMHXWY50CZa7JqzPMMDBk5MGpfYMp-FXAyIMz5eAiAUwTAkexDr_Wa3KTeUnHOqR7_3CYXl4sYLy2G5K7lRVw%3D%3D&sig=AOq0QJ8wRgIhAMVo2I4yqVg2vQBT0YdiPAnWvoHG9JUdew5BgJM7P9n9AiEA46yRVpu7p4f30VBiYOCipwj4pBrAmmE-_p7fXooH7Bo=  1 de 10")
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
