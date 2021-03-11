#include <AutoItConstants.au3>
#include <EditConstants.au3>
#include <FileConstants.au3>
#include <GUIConstantsEx.au3>
#include<Constants.au3>
#include <WindowsConstants.au3>
#include "new\NVDAControllerClient.au3"
; Demuestra StdoutRead()
Global Const $EMPTY_STRING = ""
Global Const $DOWNLOAD_TAG = "[download]"
Global $iPID = -1
	Local $sOutput = $EMPTY_STRING
$gui = guicreate("download test")
GUISetState(@SW_SHOW)
$btn_generate = GUICtrlCreateButton("&Descargar", 432, 80, 169, 121)
;while 1
sleep(10000)
;wend
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $btn_generate
	$iPID = Run("generated.bat", $STDERR_CHILD + $STDOUT_CHILD)
NVDAController_SpeakText($EMPTY_STRING)
	While 1
		$sOutput = StdoutRead($iPID)
		If @error Then msgbox(0, "error!", @error)
		If $sOutput <> $EMPTY_STRING Then
			If StringInStr($sOutput, $DOWNLOAD_TAG) > 1 Then
NVDAController_SpeakText($sOutput)
			Else
NVDAController_SpeakText($sOutput)
			EndIf
		EndIf
		$sOutput = StderrRead($iPID)
		If @error Then msgbox(0, "error!", @error)
		If $sOutput <> $EMPTY_STRING Then NVDAController_SpeakText($sOutput)
WEnd
EndSwitch
WEnd