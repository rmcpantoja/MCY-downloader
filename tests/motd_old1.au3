#include <InetConstants.au3>
;#include <GUIConstantsEx.au3>
func motdprincipal()
$dmotd = GUICreate("Downloading messaje of the day....")
GUICtrlCreateLabel("Descargando el mensaje del día.", 85, 20)
GUISetState(@SW_SHOW)
Sleep(700)
$grlanguage = iniRead ("config\config.st", "General settings", "language", "")
select
case $grlanguage ="es"
downloadmotd()
case $grlanguage ="eng"
principal()
endselect
endfunc
func downloadmotd()
$audio = InetGet("https://contenidoaccesible.droppages.com/motd_es.ogg","tmp_motd_es.ogg",1,0)
While @InetGetActive
$downloading = $device.opensound ("sounds\soundsdata.dat\update_downloading1.wav", 0)
$downloading.play
TrayTip("Descargando mensaje del día...","Bytes = "& @InetGetBytesRead,10,16)
Sleep(1500)
Wend
InetClose($audio)
$motd = $device.opensound ("motd_es.ogg", 0)
GUICtrlCreateLabel("Reproduciendo audio...", 85, 20)
$motd.play
GUIDelete($dmotd)
principal()
endfunc