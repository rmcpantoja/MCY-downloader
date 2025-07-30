; misc string functions
; by Mateo C
#include-once

; #FUNCTION# ====================================================================================================================
; Name ..........: _String_startsWith
; Description ...: Checks if the string starts with a specific criteria, similar to the function in Python.
; Syntax ........: _String_startswith($sString, $sStart)
; Parameters ....: $sString             - The string to be examined.
;                  $sStart              - A value (string) to check.
; Return values .: True if the string starts with that value; otherwise, return false. If $sString is not a string, return @error.
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _String_startsWith($sString, $sStart)
	If Not IsString($sString) Then Return SetError(1, 0, "")
	Return $sStart = StringLeft($sString, StringLen($sStart))
EndFunc   ;==>_String_startsWith
; #FUNCTION# ====================================================================================================================
; Name ..........: _String_EndsWith
; Description ...: Checks if the string ends with a specific criteria, similar to the function in Python.
; Syntax ........: _String_Endswith($sString, $sEnd)
; Parameters ....: $sString             - The string to be examined.
;                  $sEnd                - A value (string) to check.
; Return values .: True if the string ends with that value; otherwise, return false. If $sString is not a string, return @error
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _String_EndsWith($sString, $sEnd)
	If Not IsString($sString) Then Return SetError(1, 0, "")
	Return $sEnd = StringRight($sString, StringLen($sEnd))
EndFunc   ;==>_String_EndsWith
