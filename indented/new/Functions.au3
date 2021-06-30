		;;estas son las funciones de MCY downloader:
		;;**por favor no tocar este archivo en caso de que no tengas conocimientos sobre programación o cosas técnicas.
		;;This is the functions off MCY downloader.
		;;**please do not touch this file in case you do not have knowledge about programming or technical things.
		;;Function wen the program is not compiled for use. Función cuando el programa no está compilado para su uso.
Func NotCompiled()
			;;If the program is not compiled, it plays the sound along with the following message: Si el programa no está compilado, reproduce el sonido junto con el siguiente mensaje:
	If @Compiled Then
		selector()
	Else
		$errorsound = $device.opensound("sounds\soundsdata.dat\error_not_comp.wav", 0)
		$errorsound.play
				;;Esperemos un segundo y medio. Let's wait a second and a half.
		Sleep(1500)
				;;Muestra el mensage de error. Show error message.
		MsgBox($MB_SYSTEMMODAL, "", "You have to compile this program first to run it. Then the program will close now.")
		exitpersonaliced()
	EndIf
EndFunc
		;;Esta es la función para dar soporte a la interfaz de MCY Downloader. Vamos a crear una ventana. This is the function to support the MCY Downloader interface. We are going to create a window.
Func Menuprogram()
	Local $sDefaultstatus = "Ready"
			;;Creamos la ventana. We create the window.
			;;Añadimos el soporte de multiidioma. We add multi-language support.
	Select
		Case $grlanguage = "es"
			$PROGRAMGUI = GUICreate("Descargador de músicas de YouTube, por Mateo Cedillo", 150, 100)
		Case $grlanguage = "eng"
			$PROGRAMGUI = GUICreate("YouTube music downloader, by Mateo Cedillo", 150, 100)
	EndSelect
			;;Establecemos el atajo de teclado para escuchar la ayuda en audio. We set the keyboard shortcut to listen to the audio help.
	HotKeySet("{F1}", "playhelp")
			;;Ahora crearemos los menús junto a sus respectivas opciones. Now we will create the menus along with their respective options.
	Select
		Case $grlanguage = "es"
			Local $idDownload = GUICtrlCreateMenu("&descargar")
			Local $idDownloaditem = GUICtrlCreateMenuItem("Descargar en audio mp3...", $idDownload)
			GUICtrlSetState(-1, $GUI_DEFBUTTON)
			Local $idHelpmenu = GUICtrlCreateMenu("Ayuda")
			Local $idErrorreporting = GUICtrlCreateMenuItem("Reportero de errores...", $idHelpmenu)
			Local $idCheckupdates = GUICtrlCreateMenuItem("Buscar actualizaciones...", $idHelpmenu)
			Local $idHelpitema = GUICtrlCreateMenuItem("Acerca de...", $idHelpmenu)
			Local $idExititem = GUICtrlCreateMenuItem("Salir", $idDownload)
			GUICtrlCreateMenuItem("", $idDownload, 2)
		Case $grlanguage = "eng"
			Local $idDownload = GUICtrlCreateMenu("&download")
			Local $idDownloaditem = GUICtrlCreateMenuItem("download in audio mp3...", $idDownload)
			GUICtrlSetState(-1, $GUI_DEFBUTTON)
			Local $idHelpmenu = GUICtrlCreateMenu("help")
			Local $idErrorreporting = GUICtrlCreateMenuItem("Bug Reporter...", $idHelpmenu)
			Local $idCheckupdates = GUICtrlCreateMenuItem("Check for updates...", $idHelpmenu)
			Local $idHelpitema = GUICtrlCreateMenuItem("About", $idHelpmenu)
			Local $idExititem = GUICtrlCreateMenuItem("Exit", $idDownload)
			GUICtrlCreateMenuItem("", $idDownload, 2)
	EndSelect

	GUICtrlSetState(-1, $GUI_CHECKED)
			;;Crear una etiqueta de texto. Creates a text label.
			;;Nota: Todo esto ahora aplica la detección de idioma. Note: All of this now applies language detection.
	Select
		Case $grlanguage = "es"
			GUICtrlCreateLabel("Pulsa alt para abrir el menú.", 55, 100)
		Case $grlanguage = "eng"
			GUICtrlCreateLabel("Press alt to open the menu.", 55, 100)
	EndSelect
	GUICtrlSetState(-1, $GUI_FOCUS)
			;;Botón de salir. Exit button.
	Select
		Case $grlanguage = "es"
			Local $idExitbutton = GUICtrlCreateButton("Salir", 120, 100, 20, 20)
		Case $grlanguage = "eng"
			Local $idExitbutton = GUICtrlCreateButton("Exit", 120, 100, 20, 20)
	EndSelect
	Local $idStatuslabel = GUICtrlCreateLabel($sDefaultstatus, 0, 165, 300, 16, BitOR($SS_SIMPLE, $SS_SUNKEN))

	GUISetState(@SW_SHOW)
			;;Ahora vamos a darle más sentido a cada opción del menú, especialmente la elegida por el usuario. Now we are going to give more meaning to each menu option, especially the one chosen by the user.
			;; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $idDownloaditem
				GUIDelete($PROGRAMGUI)
				$idDownloaditem = Imputdownload()
			Case $idErrorreporting
				$idErrorreporting = bugreporter()
			Case $idCheckupdates
				GUIDelete($PROGRAMGUI)
				$idCheckupdates = updcomponents()
			Case $GUI_EVENT_CLOSE, $idExitbutton, $idExititem
				exitpersonaliced()
			Case $idHelpitema
				$idHelpitema = aboutdialog()
		EndSwitch
	WEnd
	GUIDelete()
EndFunc
		;;Este es el diálogo de acerca del programa en el que se mostrará en pantalla, idiomas español e inglés. This is the dialogue about the program in which it will be shown on the screen, Spanish and English languages.
Func aboutdialog()
	Select
		Case $grlanguage = "es"
			MsgBox($MB_SYSTEMMODAL, "Acerca de...", "MCY downloader versión 0.6.1 beta. Programa desarrollado por mateo cedillo para descargar videos a través de Youtube. 2018-2020 MT programs.")
		Case $grlanguage = "eng"
			MsgBox($MB_SYSTEMMODAL, "About", "MCY downloader version 0.6.1 beta. Program developed by mateo cedillo to download videos through Youtube. 2018-2020 MT programs.")
	EndSelect
EndFunc
		;;Esta es la función para el reportero de errores, en las que podrás hacer tus sugerencias y/o reportar algo. Por razones técnicas el reportero de errores se ejecuta en otro archivo aparte de este script. This is the function for the bug reporter, in which you can make your suggestions and / or report something. For technical reasons the bug reporter runs in a file other than this script.
Func bugreporter()
	Sleep(700)
	GUIDelete()
	$bugreportergui = GUICtrlCreateLabel("Bug reporter loading...", 64, 32)
	Local $iReturn = RunWait("bugReporterTool.exe /report")
	GUIDelete($bugreportergui)
	Menuprogram()
EndFunc
		;;La siguiente función es para dar soporte a la escucha de la ayuda en audio. The following function is to support listening to the audio help.
Func playhelp()
			;;Reproducimos el archivo de audio de la música. We play the audio file of the music.
	$helpmusic = $device.opensound("sounds\soundsdata.dat\menuhelp.wav", 0)
	$helpmusic.play
	$helpmusic.repeating = 1
			;;Leemos la configuración de idioma seleccionada por el usuario. We read the language settings selected by the user.
	$helplang = IniRead("config\config.st", "General settings", "language", "")
			;;Establecemos los parámetros de Cómo MCY ba a detectar el idioma. We set the parameters of How MCY will detect the language.
	Select
		Case $helplang = "es"
			$helpvoice = $device.opensound("sounds\soundsdata.dat\help1.wav", 0)
		Case $helplang = "eng"
			$helpvoice = $device.opensound("sounds\soundsdata.dat\help2.wav", 0)
	EndSelect
	Sleep(1000)
	$helpmusic.volume = 0.50
			;;Finalmente, reproducimos la ayuda en audio y la escuchamos. Finally, we play the audio help and listen to it.
	$helpvoice.play
			;;key suport:
	While $helpmusic.playing = 1
		HotKeySet("{f1}")
		$helpmusic.reset
		HotKeySet("{f2}")
		$helpmusic.stop
	WEnd
	While $helpvoice.playing = 1
		HotKeySet("{f1}")
		$helpvoice.reset
		HotKeySet("{f2}")
		$helpvoice.stop
	WEnd
EndFunc
Func hStop()
			;;while $helpvoice.playing = 1
	SoundPlay("sounds\soundsdata.dat\selected.wav", 1)
	Sleep(150)
	$helpvoice.pitchshift = 0.90
	$helpmusic.pitchshift = 0.90
	Sleep(75)
	$helpvoice.pitchshift = 0.85
	$helpmusic.pitchshift = 0.85
	Sleep(75)
	$helpvoice.pitchshift = 0.80
	$helpmusic.pitchshift = 0.80
	Sleep(75)
	$helpvoice.pitchshift = 0.75
	$helpmusic.pitchshift = 0.75
	Sleep(75)
	$helpvoice.pitchshift = 0.70
	$helpmusic.pitchshift = 0.70
	Sleep(75)
	$helpvoice.pitchshift = 0.65
	$helpmusic.pitchshift = 0.65
	Sleep(75)
	$helpvoice.pitchshift = 0.60
	$helpmusic.pitchshift = 0.60
	Sleep(75)
	$helpvoice.pitchshift = 0.50
	$helpmusic.pitchshift = 0.50
	Sleep(200)
	$helpvoice.stop
	Sleep(1000)
			;;WEnd
EndFunc