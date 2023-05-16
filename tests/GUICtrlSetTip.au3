#include <GUIConstantsEx.au3>
#include "GUICtrlSetTip_accessible.au3"
Example()

Func Example()
	$l1 = GUICreate("My GUI control tip") ; will create a dialog box that when displayed is centered

	$label = GUICtrlCreateLabel("my label", 10, 20)
	_GUICtrlSetTip($l1, $label, "tip of my label")
	GUISetState(@SW_SHOW)

	; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop

		EndSwitch
	WEnd
EndFunc   ;==>Example
