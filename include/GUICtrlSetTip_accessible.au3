#include <GuiConstantsEx.au3>
#include "reader.au3"

func _GUICtrlSetTip($hGui, $CTRL, $text)
local $repeated = 0
local $action = 0
;If _IsFocused($hGUI, $CTRL) Then
GUICtrlSetTip($ctrl, $text)
;$action = 1
;while $action = 1
;if $repeated = 0 then speaking($text)
;$repeated = 1
;$action = 0
;if $action = 0 then exitloop
;sleep(10)
;Wend
;Else
;GUICtrlSetState($ctrl, $GUI_FOCUS)
;$repeated = 0
;_GUICtrlSetTip($hGui, $CTRL, $text)
;EndIf
EndFunc

; Check if a control is focused.
Func _IsFocused($hWnd, $iControlID)
Return ControlGetHandle($hWnd, "", $iControlID) = ControlGetHandle($hWnd, "", ControlGetFocus($hWnd))
EndFunc   ;==>_IsFocused