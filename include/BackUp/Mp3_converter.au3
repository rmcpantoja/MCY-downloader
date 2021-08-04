func mp3Converter()
$lang = iniRead ("config\config.st", "General settings", "language", "")
select
case $lang ="es"
$message="Convertir archivos"
$message1="Volver a la aplicación anterior"
$message2="Seleccione archivo de audio a convertir"
$message3="Archivos de Audio, (*.*)"
$message4="no se encontró el archivo"
$message5="ERROR"
$message6="No se ha encontrado el archivo: "
case $lang ="eng"
$message="Convert files"
$message1="Back to the previous app"
$message2="Select audio file to convert"
$message3="Audio Files, (*.*)"
$message4="file not found"
$message5="ERROR"
$message6="File not found: "
EndSelect
$mp3window = guiCreate("Convert files")
$id128 = GUICtrlCreateButton("128 KBPS", 90, 50, 70, 25)
$id192 = GUICtrlCreateButton("192 KBPS", 130, 50, 70, 25)
$id320 = GUICtrlCreateButton("320 KBPS", 180, 50, 70, 25)
$idBack = GUICtrlCreateButton($message1, 250, 50, 70, 25)
GUISetState(@SW_SHOW)
$sfile = FileOpenDialog($message2, @ScriptDir, $message3)
If @error OR NOT $sfile OR NOT FileExists($sfile) Then
speaking($message4 &$sfile)
sleep(500)
MsgBox(0, $message5, $message6 &$sfile)
GuiDelete($mp3window)
Else
speaking($sfile)
endIf
; Loop until the user exits.
While 1
$idMsg = GUIGetMsg()
Switch $idMsg
Case $GUI_EVENT_CLOSE, $idBack
GuiDelete($mp3window)
ExitLoop
Case $id128
guiDelete($main)
sleep(100)
NVDAController_SpeakText("OK")
if $arquitectura = x86 then
_encode("Encoder: Lame - 128 kBit/s", @ScriptDir & '\engines\lame.exe -mj -q0 --cbr -b128 "' & $sfile & '" "' & @ScriptDir & '\128_converted.mp3"')
else
_encode("Encoder: Lame - 128 kBit/s", @ScriptDir & '\engines64\lame.exe -mj -q0 --cbr -b128 "' & $sfile & '" "' & @ScriptDir & '\128_converted.mp3"')
EndIf
ExitLoop
Case $id192
guiDelete($main)
sleep(100)
NVDAController_SpeakText("OK")
if $arquitectura = x86 then
_encode("Encoder: Lame - 192 kBit/s", @ScriptDir & '\Engines\lame.exe -mj -q0 --cbr -b192 "' & $sfile & '" "' & @ScriptDir & '\192_converted.mp3"')
else
_encode("Encoder: Lame - 192 kBit/s", @ScriptDir & '\Engines64\lame.exe -mj -q0 --cbr -b192 "' & $sfile & '" "' & @ScriptDir & '\192_converted.mp3"')
EndIf
ExitLoop
Case $id320
guiDelete($main)
sleep(100)
NVDAController_SpeakText("OK")
if $arquitectura = x86 then
_encode("Encoder: Lame - 320 kBit/s", @ScriptDir & '\Engines\lame.exe -mj -q0 --cbr -b320 "' & $sfile & '" "' & @ScriptDir & '\320_converted.mp3"')
else
_encode("Encoder: Lame - 320 kBit/s", @ScriptDir & '\Engines64\lame.exe -mj -q0 --cbr -b320 "' & $sfile & '" "' & @ScriptDir & '\320_converted.mp3"')
EndIf
ExitLoop
EndSwitch
WEnd
endFunc
Func _encode($stitle, $scmd)
Local $itimer = TimerInit()
Local $aregexp = StringRegExp($scmd, '"[^"]*"', 3)
If IsArray($aregexp) AND UBound($aregexp) > 1 Then
$aregexp = $aregexp[1]
Else
$aregexp = ""
EndIf
$guiWorking = GUICreate("Encoding to MP3", $stitle, $aregexp)
Local $idProgressbar = GUICtrlCreateProgress(10, 10, 200, 20)
GUICtrlSetColor(-1, 32250); not working with Windows XP Style
GUISetState(@SW_SHOW)
Local $iSavPos = 0
Local $foo = Run($scmd, @SystemDir, @SW_HIDE, 8)
Local $line
While 1
$line = StdoutRead($foo)
If @error Then ExitLoop
$aregexp = StringRegExp($line, "([0-9.]+)\h*%", 3)
If IsArray($aregexp) Then GUICtrlSetData($idProgressbar, $aregexp[UBound($aregexp) - 1])
NVDAController_SpeakText($aregexp)
WEnd
Speaking($stitle & " Time: " & Round(TimerDiff($itimer), 1) & "ms" & @LF)
Sleep(200)
EndFunc