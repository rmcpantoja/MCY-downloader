; reorder:
#include-once
; #FUNCTION# ====================================================================================================================
; Name ..........: reOrganizar
; Description ...: function to reorganice audio and video
; Syntax ........: reOrganizar()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func reOrganizar()
	Local $AudioFormats[10] = ["Aiff", "Aac", "flac", "IFF", "mp3", "m4a", "ogg", "OPUS", "wav", "wma"]
	Local $videoFormats[10] = ["Mp4", "FLV", "AVI", "MKV", "3gp", "WMV", "asf", "MOV", "SWF", "WEBM"]
	$ReorderGui = GUICreate("Reordering...")
	$rlabel = GUICtrlCreateLabel(translate($lng, "starting reordering... Please wait."), 10, 100, 200, 20)
	GUISetState(@SW_SHOW)
	Sleep(1000)
	For $I = 0 To UBound($AudioFormats, $UBOUND_ROWS) - 1
		GUICtrlSetData($rlabel, translate($lng, "Reordering audios with the format") & " " & $AudioFormats[$I] & "...")
		$reorderrresult = ReOrder("video", $AudioFormats[$I], $d_folder & "\audio")
		Sleep(100)
		If $reorderrresult = 0 Then GUICtrlSetData($rlabel, translate($lng, "There is nothing to reorder here."))
		Sleep(100)
	Next
	For $I = 0 To UBound($videoFormats, $UBOUND_ROWS) - 1
		GUICtrlSetData($rlabel, translate($lng, "Reordering videos with the format") & " " & $videoFormats[$I] & "...")
		$reorderrresult = ReOrder("Audio", $videoFormats[$I], $d_folder & "\video")
		Sleep(100)
		If $reorderrresult = 0 Then GUICtrlSetData($rlabel, translate($lng, "There is nothing to reorder here."))
		Sleep(100)
	Next
	MsgBox(48, translate($lng, "Done"), translate($lng, "The audios and videos have been reordered correctly!"))
	GUIDelete($ReorderGui)
EndFunc   ;==>reOrganizar
