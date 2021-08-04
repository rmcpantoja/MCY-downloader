#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
Example()

Func Example()
	Local $iPID = Run(@ComSpec & " /C " & "engines64\youtube-dl-.exe", @SW_HIDE, 6, BitOR($STDERR_CHILD, $STDOUT_CHILD))
	Local $sOutput = ""
	While 1
		$sOutput &= StdoutRead($iPID)
		If @error Then ; Exit the loop if the process closes or StdoutRead returns an error.
			MsgBox(16, "Error", "File not found")
			ExitLoop
		EndIf
		MsgBox($MB_SYSTEMMODAL, "Stdout Read:", $sOutput)
	WEnd

	$sOutput = ''
	While 1
		$sOutput &= StderrRead($iPID)
		If @error Then ; Exit the loop if the process closes or StderrRead returns an error.
			ExitLoop
		EndIf
		MsgBox($MB_SYSTEMMODAL, "Stderr Read:", $sOutput)
	WEnd
EndFunc   ;==>Example
