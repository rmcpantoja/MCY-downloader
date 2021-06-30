; This file has no functions, it is simply used to initialize COMAudio, the com library that ; I use for audio playback. All it does is to register the object using regsvr32, and then 
; it initializes it.
$comaudio = ObjCreate("ComAudio.Service")
If @Error then
$installing = GUICreate("Installing audio")
GUICtrlCreateLabel("Installing necessary audio libraries ...", 55, 32)
GUISetState(@SW_SHOW)
sleep(500)
$dwncomaudio InetGet("https://www.dropbox.com/s/vqi3yi50mti9gp8/comaudio.exe?dl=1", "comaudio.exe")
RunWait("comaudio.exe /SILENT")
InetClose($dwncomaudio)
GUIDelete($installing)
$comaudio = ObjCreate("ComAudio.Service")
If @Error then
if $windowslanguage = "0c0a" or $windowslanguage = "040a" or $windowslanguage = "080a" or $windowslanguage = "100a" or $windowslanguage = "140a" or $windowslanguage = "180a" or $windowslanguage = "1c0a" or $windowslanguage = "200a" or $windowslanguage = "240a" or $windowslanguage = "280a" or $windowslanguage = "2c0a" or $windowslanguage = "300a" or $windowslanguage = "340a" or $windowslanguage = "380a" or $windowslanguage = "3c0a" or $windowslanguage = "400a" or $windowslanguage = "440a" or $windowslanguage = "480a" or $windowslanguage = "4c0a" or $windowslanguage = "500a" then
MsgBox(4096, "Error", "No fue posible instalar las librerías de audio necesarias. Saliendo...")
Exit
endif
;English languages:
if $windowslanguage = "0809" or $windowslanguage = "0c09" or $windowslanguage = "1009" or $windowslanguage = "1409" or $windowslanguage = "1809" or $windowslanguage = "1c09" or $windowslanguage = "2009" or $windowslanguage = "2409" or $windowslanguage = "2809" or $windowslanguage = "2c09" or $windowslanguage = "3009" or $windowslanguage = "3409" or $windowslanguage = "0425" then
MsgBox(4096,"Error","The audio library could not be initialized.")
Exit
endIf
EndIf
endif
;$comaudio.archiveExtension = "sounds.dat"
;$comaudio.UseEncryption = true
;$comaudio.EncryptionKey = "mateocedillopantoja"
$device = $comaudio.openDevice("","")