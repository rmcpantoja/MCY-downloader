#include <MsgBoxConstants.au3>

If ProcessExists("NVDA.exe") Then
	MsgBox($MB_SYSTEMMODAL, "", "NVDA is running")
Else
	MsgBox($MB_SYSTEMMODAL, "", "NVDA is not running. Using sapi...")
EndIf
