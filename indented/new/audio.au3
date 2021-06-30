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
		If $windowslanguage = "0c0a" Or $windowslanguage = "040a" Or $windowslanguage = "080a" Or $windowslanguage = "100a" Or $windowslanguage = "140a" Or $windowslanguage = "180a" Or $windowslanguage = "1c0a" Or $windowslanguage = "200a" Or $windowslanguage = "240a" Or $windowslanguage = "280a" Or $windowslanguage = "2c0a" Or $windowslanguage = "300a" Or $windowslanguage = "340a" Or $windowslanguage = "380a" Or $windowslanguage = "3c0a" Or $windowslanguage = "400a" Or $windowslanguage = "440a" Or $windowslanguage = "480a" Or $windowslanguage = "4c0a" Or $windowslanguage = "500a" Then
			MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
			Exit
		EndIf
			;;English languages:
		Select
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