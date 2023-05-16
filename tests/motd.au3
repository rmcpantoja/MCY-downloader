#include <InetConstants.au3>
;#include <GUIConstantsEx.au3>
Func motdprincipal()
	$dmotd = GUICreate("Downloading messaje of the day....")
	GUICtrlCreateLabel("Descargando el mensaje del día.", 85, 20)
	GUISetState(@SW_SHOW)
	Sleep(700)
	$grlanguage = IniRead("config\config.st", "General settings", "language", "")
	Select
		Case $grlanguage = "es"
			downloadmotd()
		Case $grlanguage = "eng"
			principal()
	EndSelect
EndFunc   ;==>motdprincipal
Func downloadmotd()
	$audio = InetGet("https://contenidoaccesible.droppages.com/motd_es.ogg", "tmp_motd_es.ogg", 1, 0)
	While @InetGetActive
		$downloading = $device.opensound("sounds\soundsdata.dat\update_downloading1.wav", 0)
		$downloading.play
		TrayTip("Descargando mensaje del día...", "Bytes = " & @InetGetBytesRead, 10, 16)
		Sleep(1500)
	WEnd
	InetClose($audio)
	$motd = $device.opensound("motd_es.ogg", 0)
	GUICtrlCreateLabel("Reproduciendo audio...", 85, 20)
	$motd.play
	GUIDelete($dmotd)
	principal()
EndFunc   ;==>downloadmotd
