;Para saber de dónde se está ejecutando la copia:
MsgBox(0, "el scrypt se ejecuta de:", @scriptDir)
if @scriptDir ="C:\Program Files (x86)\MCY" then
MsgBox(0, "Tu versión:", "la versión que ejecutas es instalable.")
else
MsgBox(0, "Tu versión:", "la versión que ejecutas es portable.")
endif