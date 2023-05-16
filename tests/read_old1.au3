#include <AutoItConstants.au3>
#INCLUDE "include\reader.au3"
Local $runcmd = Run(@ComSpec & " /C " & "engines64\youtube-dl-.exe -e ytsearch10:AMOR", @ScriptDir, @SW_HIDE, 6)
Local $line
While 1
$line=StdoutRead($runcmd)
If @error Then ExitLoop
MsgBox(48, "Results", "STDOUT: " &$line)
Wend

While 1
$line=StderrRead($runcmd)
If @error Then ExitLoop
MsgBox(48, "Results", "STDERR: " &$line)
Wend


MsgBox(48, "Results", "exiting...")