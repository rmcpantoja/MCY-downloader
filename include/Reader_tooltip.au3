#include "kbc.au3"
#include "reader.au3"
$readerpos=1
func createtooltip($text, $key, $pos)
While 1
If NOT _ispressed($key) Then $key = 0
If NOT _ispressed($shift) and _ispressed($tab) Then $key = 0
If NOT _ispressed($enter) Then $key = 0
If _ispressed($key) AND $readerpos > 1 Then
$readerpos = $readerpos +1
if $pos = $readerpos then
Speaking($text)
EndIf
EndIf
If _ispressed($shift) AND _ispressed($tab) and $readerpos > 1 Then
$readerpos = $readerpos -1
if $pos = $readerpos then
Speaking($text)
EndIf
EndIf
If _ispressed($enter) Then
ExitLoop
EndIf
Wend
EndFunc