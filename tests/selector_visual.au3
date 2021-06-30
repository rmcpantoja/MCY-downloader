;selector visual:
Func LanguageSelectorMenu()
$mainmenu = $device.opensound ("sounds\soundsdata.dat\menumusic.wav", 0)
$mainmenu.volume=0.50
$mainmenu.play
$mainmenu.repeating=1
DirCreate("config")
$visualmenu= GUICreate("Please select a language... Por favor, selecciona un idioma.")
$widthCell=70
	GUICtrlCreateLabel("Select a language with up and down arrows. Too you can also touch the context menu to do so.", 30, 50,$widthCell)
GUICtrlCreateLabel("Selecciona un idioma con las flechas arriba y abajo, o, si eres una persona con visión, también puedes tocar el menú contextual para hacerlo.",-1,0)
	GUISetBkColor(0x00E0FFFF)
	Local $idSpanish = GUICtrlCreateButton("Spanish", 90, 50, 70, 25)
	Local $idEnglish = GUICtrlCreateButton("English", 120, 50, 70, 25)
	Local $idBtn_Close = GUICtrlCreateButton("Close", 180, 50, 70, 30)
	GUISetState(@SW_SHOW, $visualmenu)
	; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $idBtn_Close
exitpersonaliced()
Case $idSpanish
SoundPlay("sounds\soundsdata.dat\selected.wav",1)
IniWrite("config\config.st", "General settings", "language", "es")
$language="1"
$mainmenu.stop
GUIDelete($visualmenu)
Principal()

Case $idEnglish
SoundPlay("sounds\soundsdata.dat\selected.wav",1)
IniWrite("config\config.st", "General settings", "language", "es")
$language="1"
$mainmenu.stop
Principal()

		EndSwitch
	WEnd
endfunc
