	;;testing compare versions:
#include <sapi.au3>
$newversion = " Tienes la "
$newversion2 = "y está disponible la "
$yourVersion = "0.6.2.0"
$Latest = "0.6.3"
$ReadAccs = IniRead("config\config.st", "Accessibility", "Enable enanced accessibility", "")
Select
	Case $ReadAccs = "Yes"
		voice()
	Case $ReadAccs = "No"
		visual()
EndSelect
Func voice()
	Select
		Case $latest = 0
			speak("no se ha podido comprovar versión.")
		Case $latest < $yourversion
			speak("la versión que hemos buscado es menor a la que tienes.")
		Case $latest > $yourversion
			speak("actualización disponible!" & $newversion & $yourversion & $newversion2 & $latest & ". Descargando...")
		Case $latest >= $yourversion
			speak("estás actualizado.")
	EndSelect
EndFunc
Func visual()
	Select
		Case $latest = 0
			MsgBox(0, "Error", "no se ha podido comprovar versión.")
			Exit
		Case $latest < $yourversion
			MsgBox(0, "Error", "la versión que hemos buscado es menor a la que tienes.")
			Exit
		Case $latest > $yourversion
			$result = ($newversion & $yourversion & $newversion2 & $latest)
			MsgBox(0, "actualización disponible!", $result)
			Exit
		Case $latest >= $yourversion
			MsgBox(0, "estás actualizado", "no hay actualización por el momento.")
	EndSelect
	;;### Tidy Error -> func is never closed in your script.
