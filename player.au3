#include <guiConstants.au3>
#include "include\log.au3"
#include "include\reader.au3"
#include "include\radio.au3"
$inputUrl = "https://www.youtube.com/watch?v=o-z3pcd4Mxo"
Global $sYouTube_DL = IniRead("config\config.st", 'General Settings', 'Youtube-DL', 'engines64\yt-dlp.exe')
local $linkareplay
guicreate("playing")
Guisetstate(@SW_SHOW)
Local $iPID = Run(@ComSpec & ' /C "' & $sYouTube_DL & '" -g ' &$inputUrl, @ScriptDir, @SW_HIDE, 6)
ProcessWaitClose($iPID)
$linkareplay = StdoutRead($iPID)
sleep(1000)
$split = StringSplit($linkareplay, @lf)
If @Error Then return 0
$selection = $Split[1] ;Because are two URLs generated
msgbox(0, "url result", $selection)
if not StringInStr($linkareplay, "https://") then
MsgBox(16, "error" ,"The URL is not recognized")
EndIf
;writeinlog(@crlf &"Selection: " &$selection)
;speaking($seleccion)
Local $MusicHandle
_Audio_init_start()
;The following doesn't work:
;$youtubereproduce = __YTApi_URLDecode($seleccion) &@lf
;But this does play it:
$youtubereproduce = "https://rr1---sn-xu525-j0xz.googlevideo.com/videoplayback?expire=1655594101&ei=FQiuYtfZGseBy_sPj-mh4AM&ip=186.43.212.71&id=o-AO55NySKp2fB8EsfRBLZnNPCe_xNC4N40pGGWlHbFWHM&itag=18&source=youtube&requiressl=yes&mh=tI&mm=31%2C29&mn=sn-xu525-j0xz%2Csn-cvb7lnl7&ms=au%2Crdu&mv=m&mvi=1&pl=21&gcr=ec&initcwndbps=968750&vprv=1&mime=video%2Fmp4&gir=yes&clen=8103588&ratebypass=yes&dur=377.068&lmt=1639903585608340&mt=1655572143&fvip=3&fexp=24001373%2C24007246&beids=23886218&c=ANDROID&txp=5538422&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cgcr%2Cvprv%2Cmime%2Cgir%2Cclen%2Cratebypass%2Cdur%2Clmt&sig=AOq0QJ8wRQIgJYbxsegqFVZuGhDITE8Q91QMgI8FNnrpjGNBhHi7jcwCIQDOzMbyZYwQj8D8X4S5f2sW6kKYfFn4ErjsrHq9Bem8Cg%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRQIgGCMCByL_Zpw4g8g2lhciRVMWpqrfrWkUFr9oW4K7UhMCIQDNRnRjlN9FRpppRHIWxaFp2FkzBDKRg5JPCILihHqOPw%3D%3D" &@crlf
;speaking($youtubereproduce)
$MusicHandle = _Set_url($youtubereproduce)
if @error then
MSGBox(16, "error", "impossible to load. Reason:" &@extended)
Exit
EndIf
_Audio_play($MusicHandle)
Local $idBtn_Stop = GUICtrlCreateButton("stop", 10, 50, 100, 20)
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
Func __YTApi_URLDecode($s_url)
	Local $strChar = "", $iOne, $iTwo, $aryHex
	$aryHex = StringSplit($s_url, "")

	For $i = 1 To $aryHex[0]
		If $aryHex[$i] = "%" Then
			$i += 1
			$iOne = $aryHex[$i]
			$i += 1
			$iTwo = $aryHex[$i]
			$strChar = $strChar & Chr(Dec($iOne & $iTwo))
		Else
			$strChar = $strChar & $aryHex[$i]
		EndIf
	Next

	$strChar = StringReplace($strChar, "\/", "/")
	$strChar = StringReplace($strChar, "%3A", ":")
	$strChar = StringReplace($strChar, "\u0026", "&")

	Return $strChar
EndFunc   ;==>__MyTube_URLDecode