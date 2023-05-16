#include <AutoItConstants.au3>
	; Display a progress bar window.
	ProgressOn("Descargando archivo", "Downloading", "0%", 100, 100, 1)
WinActivate("Descargando archivo", "")
$iPlaces = 2
$url = 'https://test.com/test.html'
$fldr = 'downloaded.dat'
$hInet = InetGet($url, $fldr, 1, 1)
$URLSize = InetGetSize($url)
While Not InetGetInfo($hInet, 2)
Sleep(100)
$Size = InetGetInfo($hInet, 0)
$Percentage = Int($Size / $URLSize * 100)
$iSize = $URLSize - $Size
ProgressSet($Percentage, _GetDisplaySize($iSize, $iPlaces = 2) & " restante(s)             " & $Percentage & " % completed")
WEnd
	ProgressSet(100, "Completado", "Listo para abrir.")
sleep(4000)
	; Close the progress window.
ProgressOff()
Func _GetDisplaySize($iTotalDownloaded, Const $iPlaces)
Local Static $aSize[4] = ["Bytes", "KB", "MB", "GB"]
For $i = 0 to 3
$iTotalDownloaded /= 1024
If (Int($iTotalDownloaded) = 0) Then Return Round($iTotalDownloaded * 1024, $iPlaces) & " " & $aSize[$i]
Next
EndFunc