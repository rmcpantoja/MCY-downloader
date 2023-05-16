#include <GUIConstantsEx.au3>
#include "include\kbc.au3"
#include "include\reader.au3"
; Check to see if a window / control has focus or not.

Example()

Func Example()
; Create a GUI with various controls.
Local $hGUI = GUICreate("Example", 300, 200)
local $repeated = 0
local $action = 0
; Create a button control.
Local $idb1 = GUICtrlCreateButton("botón 1", 120, 170, 85, 25)
Local $idb2 = GUICtrlCreateButton("Salir", 210, 170, 85, 25)

; Display the GUI.
GUISetState(@SW_SHOW, $hGUI)

; Loop until the user exits.
While 1
;Reproducir un sonido de pitido solo una vez cuando el botón uno está enfocado.
If _IsFocused($hGUI, $idb1) Then
$action = 1
while $action = 1
if $repeated = 0 then speaking("El control está enfocado...")
$repeated = 1
$action = 0
if $action = 0 then exitloop
sleep(10)
Wend
Else
$repeated = 0
EndIf
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE, $idb2
ExitLoop
Case $idb1
msgBox(0, "Prueba", "Hola")
EndSwitch
WEnd

; Delete the previous GUI and all controls.
GUIDelete($hGUI)
EndFunc   ;==>Example

; Check if a control is focused.
Func _IsFocused($hWnd, $iControlID)
Return ControlGetHandle($hWnd, "", $iControlID) = ControlGetHandle($hWnd, "", ControlGetFocus($hWnd))
EndFunc   ;==>_IsFocused