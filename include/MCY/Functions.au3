#include <EditConstants.au3>
#include "reorder.au3"
#include "..\share.au3"
#include <WindowsConstants.au3>
;This is the functions of MCY downloader.
;**please do not touch this file in case you do not have knowledge about programming or technical things.
; #FUNCTION# ====================================================================================================================
; Name ..........: _StringInArray
; Description ...: check if string is part of array
; Syntax ........: _StringInArray($a_Array, $s_String)
; Parameters ....: $a_Array             - An array of unknowns.
;                  $s_String            - A string value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _StringInArray($a_Array, $s_String)
	Local $i_ArrayLen = UBound($a_Array) - 1
	For $i = 0 To $i_ArrayLen
		If $a_Array[$i] = $s_String Then
			Return $i
		EndIf
	Next
	SetError(1)
	Return 0
EndFunc   ;==>_StringInArray
;Function wen the program is not compiled for use.
; #FUNCTION# ====================================================================================================================
; Name ..........: NotCompiled
; Description ...: function that checks when the program is not compiled
; Syntax ........: NotCompiled()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func NotCompiled()
	;If the program is not compiled, it plays the sound along with the following message:
	If @Compiled Then
		selector()
	Else
		$errorsound = $device.opensound("sounds/error_not_comp.ogg", 0)
		$errorsound.play
		;Show error message.
		MsgBox($MB_SYSTEMMODAL, "", "You have to compile this program first to run it. Then the program will close now.")
		writeinlog("The program is not compiled... Exiting.")
		exitpersonaliced()
	EndIf
EndFunc   ;==>NotCompiled
; #FUNCTION# ====================================================================================================================
; Name ..........: _IsChecked
; Description ...: check if a control is checked
; Syntax ........: _IsChecked($idControlID)
; Parameters ....: $idControlID         - An AutoIt controlID.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked
