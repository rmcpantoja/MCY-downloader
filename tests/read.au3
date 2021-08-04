#include <AutoItConstants.au3>
#include "NEW\NVDAControllerClient.au3"
Local $runcmd = Run(@ComSpec & " /C " & "engines\youtube-dl-.exe", @ScriptDir, @SW_HIDE, 6)
Local $line
While 1
	$line = StdoutRead($runcmd)
	If @error Then ExitLoop
	NVDAController_Speaktext("STDOUT: " & $line)
WEnd

While 1
	$line = StderrRead($runcmd)
	If @error Then ExitLoop
	NVDAController_Speaktext("STDERR: " & $line)
WEnd


NVDAController_Speaktext("exiting...")
