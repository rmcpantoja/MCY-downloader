#include "include\progress.au3"
Example()
Func Example()
	Local $iSavPos = 0
	For $i = $iSavPos To 100
		$iSavPos = $i
		CreateAudioProgress($i)
		Sleep(250)
	Next
	If $i > 100 Then
		MsgBox(0, "done", "done")
	EndIf
EndFunc   ;==>Example
