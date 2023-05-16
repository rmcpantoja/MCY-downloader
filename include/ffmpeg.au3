#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>



Local $nombreVideoSinExtension
$nombreVideoSinExtension = InputBox("Definir nombre","Elige un nombre para el archivo final SIN EXTENSION ya que será un mp4","video-final","",-1,-1)
Local $videoFinal
$videoFinal = $nombreVideoSinExtension & ".mp4"
Local $duracionVideoFinal
$duracionVideoFinal = InputBox("Definir duración","Define la duración del video expresada en segundos","10","",-1,-1)
Local $videoResolucion
$videoResolucion = InputBox("Definir resolución","Define la resolución del video","1280x720","",-1,-1)
Local $imagenes
$imagenes = InputBox("Escoger imagen","Escribe el nombre de la imagen CON SU EXTENSION que será el fondo del video","audio.mp3","",-1,-1)
Local $duracionCadaImagen
$duracionCadaImagen = 5
Local $relacionDeAspecto
$relacionDeAspecto = "4:3"
Local $audioVideo
$audioVideo = InputBox("Escoger audio","Escribe el nombre del audio CON SU EXTENSION","imagen.jpg","",-1,-1)
Local $velocidadAlCodificar
;$velocidadAlCodificar[] = [ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow]
Local $fpsVideoFinal
$fpsVideoFinal = 20


EstablecerVelocidadAlCodificar()

Func EstablecerVelocidadAlCodificar()
; Create a GUI with various controls.
Local $InterfazEstablecerVelocidadAlCodificar = GUICreate("Elige la velocidad de codificación", 300, 200)

; Create a combobox control.
Local $idComboBox = GUICtrlCreateCombo("", 10, 10, 185, 20)
Local $idClose = GUICtrlCreateButton("Cerrar", 210, 170, 85, 25)

; Add additional items to the combobox.
GUICtrlSetData($idComboBox, "ultrafast|superfast|veryfast|faster|fast|medium|slow|slower|veryslow", "fast")

; Display the GUI.
GUISetState(@SW_SHOW, $InterfazEstablecerVelocidadAlCodificar)

Local $sComboRead = ""

; Loop until the user exits.
While 1
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE, $idClose
ExitLoop

Case $idComboBox
$sComboRead = GUICtrlRead($idComboBox)
MsgBox($MB_SYSTEMMODAL, "", "Elegiste " & $sComboRead & " como velocidad de codificación", 0, $InterfazEstablecerVelocidadAlCodificar)
$velocidadAlCodificar = $sComboRead

EndSwitch
WEnd

; Delete the previous GUI and all controls.
GUIDelete($InterfazEstablecerVelocidadAlCodificar)
EndFunc
;And the FFmpeg code with AutoIt variables:
run ('cmd /k engines64\ffmpeg.exe -loop 1 -framerate ' & 1 /$duracionCadaImagen & ' -i ' & $imagenes & ' -i ' & $audioVideo & ' -c:v libx264 -s ' & $videoResolucion & ' -t ' & $duracionVideoFinal & ' -aspect ' & $relacionDeAspecto & ' -c:a libvo_aacenc -ac 2 -ab 128k -r ' & $fpsVideoFinal & ' -preset ' & $velocidadAlCodificar & $videoFinal)
;run (@ComSpec & " /C engines\ffmpeg.exe -loop 1 -framerate ' & 1 /$duracionCadaImagen & ' -i ' & $imagenes & ' -i ' & $audioVideo & ' -c:v libx264 -s ' & $videoResolucion & ' -t ' & $duracionVideoFinal & ' -aspect ' & $relacionDeAspecto & ' -c:a libvo_aacenc -ac 2 -ab 128k -r ' & $fpsVideoFinal & ' -preset ' & $velocidadAlCodificar & $videoFinal)