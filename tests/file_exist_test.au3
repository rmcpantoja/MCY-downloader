#include <sapi.au3>
speak("verificando archivo")
Sleep(400)
FileTest()
Func FileTest()
	Local $iFileExists = FileExists("tmp_motd_es.ogg")
	If $iFileExists Then
		speak("el audio del mensaje del día está disponible en tu ordenador.")
		Exit
	Else
		speak("Lo siento. No he podido encontrar el archivo del mensaje del día. No está descargado. Saliendo...")
		Exit
	EndIf
EndFunc   ;==>FileTest
