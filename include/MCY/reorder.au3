#include <FileConstants.au3>
#include "..\translator.au3"
#include-once

; #FUNCTION# ====================================================================================================================
; Name ..........: reorder
; Description ...: rearrange audio and video, UDF which is part of MCY Downloader.
; Syntax ........: reorder($orig, $format, $destination)
; Parameters ....: $orig                - A object value.
;                  $format              - A floating point number value.
;                  $destination         - A binary value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func reorder($sOrig, $sFormat, $sBase, $sDestination)
	$beep = "110"
	$hFiles = FileFindFirstFile($sBase & "\" & $sOrig & "\*." & $sFormat)
	If $hFiles = -1 Then Return False
	Local $sFileName = "", $iResult = 0
	While 1
		$beep = $beep + 1
		$sFileName = FileFindNextFile($hFiles)
		If @error Then ExitLoop
		$iResult = FileMove($sBase & "\" & $sFileName, $sDestination)
		Beep($beep, 70)
		Sleep(100)
	WEnd
	Return 1
EndFunc   ;==>reorder
