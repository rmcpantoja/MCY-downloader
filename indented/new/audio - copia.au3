	;; This file has no functions, it is simply used to initialize COMAudio, the com library that 	;; I use for audio playback. All it does is to register the object using regsvr32, and then
	;; it initializes it.
$comaudio = ObjCreate("ComAudio.Service")
If @error Then
	$installing = GUICreate("Installing audio")
	GUICtrlCreateLabel("Installing necessary audio libraries ...", 55, 32)
	GUISetState(@SW_SHOW)
	Sleep(500)
	RunWait("comaudio.exe /SILENT")
	GUIDelete($installing)
	$comaudio = ObjCreate("ComAudio.Service")
	If @error Then
		Select
			Case $windowslanguage = "0c0a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "040a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "080a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "100a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "140a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "180a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "1c0a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "200a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "240a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "280a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "2c0a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "300a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "340a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "380a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")

			Case $windowslanguage = "3c0a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "400a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "440a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "480a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "4c0a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
			Case $windowslanguage = "500a"
				MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
				Exit
					;;English languages:
			Case $windowslanguage = "0809"
				MsgBox(4096, "Error", "The audio library could not be initialized.")
				Exit
			Case $windowslanguage = "0c09"
				MsgBox(4096, "Error", "The audio library could not be initialized.")
				Exit
			Case $windowslanguage = "1009"
				MsgBox(4096, "Error", "The audio library could not be initialized.")
				Exit
			Case $windowslanguage = "1409"
				MsgBox(4096, "Error", "The audio library could not be initialized.")
				Exit
			Case $windowslanguage = "1809"
				MsgBox(4096, "Error", "The audio library could not be initialized.")
				Exit
			Case $windowslanguage = "1c09"
				MsgBox(4096, "Error", "The audio library could not be initialized.")
				Exit
			Case $windowslanguage = "2009"
				MsgBox(4096, "Error", "The audio library could not be initialized.")
				Exit
			Case $windowslanguage = "2409"
				MsgBox(4096, "Error", "The audio library could not be initialized.")
				Exit
			Case $windowslanguage = "2809"
				MsgBox(4096, "Error", "The audio library could not be initialized.")
				Exit
			Case $windowslanguage = "2c09"
				MsgBox(4096, "Error", "The audio library could not be initialized.")
				Exit
			Case $windowslanguage = "3009"
				MsgBox(4096, "Error", "The audio library could not be initialized.")
				Exit
			Case $windowslanguage = "3409"
				MsgBox(4096, "Error", "The audio library could not be initialized.")
				Exit
			Case $windowslanguage = "0425"
				MsgBox(4096, "Error", "The audio library could not be initialized.")
				Exit
		EndSelect
	EndIf
EndIf
$device = $comaudio.openDevice("", "")