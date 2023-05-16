;Para saber de dónde se está ejecutando la copia:
MsgBox(0, "el scrypt se ejecuta de:", @ScriptDir)
If @ScriptDir = "C:\Program Files (x86)\MCY" Then
	MsgBox(0, "Tu versión:", "la versión que ejecutas es instalable.")
Else
	MsgBox(0, "Tu versión:", "la versión que ejecutas es portable.")
EndIf
