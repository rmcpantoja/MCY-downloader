;testing compare versions:
#include <sapi.au3>
$newversion=" Tienes la "
$newversion2="y está disponible la "
$yourVersion="0.6.2.0"
$Latest="0.6.3"
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
select
case $ReadAccs ="Yes"
voice()
case $ReadAccs ="No"
visual()
endselect
func voice()
select
		Case $latest = 0
speak("no se ha podido comprovar versión.")
		Case $latest < $yourversion
speak("la versión que hemos buscado es menor a la que tienes.")
		Case $latest > $yourversion
speak("actualización disponible!" & $newversion & $yourversion & $newversion2 & $latest & ". Descargando...")
		Case $latest >= $yourversion
speak("estás actualizado.")
endselect
endfunc
func visual()
select
		Case $latest = 0
msgbox(0, "Error", "no se ha podido comprovar versión.")
exit
		Case $latest < $yourversion
msgbox(0, "Error", "la versión que hemos buscado es menor a la que tienes.")
exit
		Case $latest > $yourversion
$result= ($newversion &$yourversion &$newversion2 &$latest)
msgbox(0, "actualización disponible!", $result)
exit
		Case $latest >= $yourversion
msgbox(0, "estás actualizado", "no hay actualización por el momento.")
endselect