#include <FileConstants.au3>
#include "translator.au3"
global $d_folder = iniRead ("config\config.st", "General settings", "Destination folder", "")
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
Func reorder($orig, $format, $destination)
$beep = "110"
$hFiles = FileFindFirstFile($d_folder &"\" &$orig &"\*." &$format)
If $hFiles = -1 Then return false
Local $sFileName = "", $iResult = 0
While 1
$beep = $Beep +1
$sFileName = FileFindNextFile($hFiles)
If @error Then ExitLoop
$iResult = FileMove($d_folder &"\" &$sFileName, $destination)
Beep($beep, 70)
Sleep(100)
WEnd
return 1
EndFunc   ;==>Example
