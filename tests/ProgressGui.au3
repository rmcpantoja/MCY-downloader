#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>

Example()

Func Example()
	GUICreate("Testing progress", 220, 100, 100, 200)
	Local $idProgressbar1 = GUICtrlCreateProgress(10, 10, 200, 20)
	GUICtrlSetColor(-1, 32250) ; not working with Windows XP Style
	GUISetState(@SW_SHOW)

	Local $iSavPos = 0

	For $i = $iSavPos To 100

		$iSavPos = $i
		GUICtrlSetData($idProgressbar1, $i)
		Sleep(25)
	Next
	If $i > 100 Then
		MsgBox(0, "done", "done")
	EndIf

EndFunc   ;==>Example
