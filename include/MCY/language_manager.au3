; language manager:
#include <ComboConstants.au3>
#include <File.au3>
#include "globals.au3"
#include "..\translator.au3"
#include-once
; #FUNCTION# ====================================================================================================================
; Name ..........: Selector
; Description ...: language selector
; Syntax ........: Selector()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Selector()
	Global $aLangFiles, $aLangCodes[]
	Global $bSelected = False, $bReturn = False
	Global $hLangGUI
	Global $iOldOpt, $iSearch = 0
	Global $sCurrentCode = "", $sRead = "", $sCollect = "", $sCodes = ""
	$hLangGUI = GUICreate("Language Selection")
	$iOldOpt = Opt("GUIOnEventMode", 1)
	GUICtrlCreateLabel( _
			"Select language:", _
			-1, 0 _
			)
	GUISetBkColor(0x00E0FFFF)
	$aLangFiles = _FileListToArrayRec(@ScriptDir & "\lng", "*.lang", 1, 0, 2)
	If @error Then
		MsgBox(16, "Fatal error", "We cannot find the language files. Please download the program again...")
		Exit
	EndIf
	$aLangCodes[0] = "en"
	$sCodes = "English, en|"
	For $I = 1 To $aLangFiles[0]
		$sCollect = $aLangFiles[$I]
		$sCurrentCode = StringLeft($sCollect, 2)
		$sCodes &= GetLanguageName($sCurrentCode) & ", " & GetLanguageCode($sCurrentCode) & "|"
		$aLangCodes[$I] = GetLanguageCode($sCurrentCode)
	Next
	$langcount = StringSplit($sCodes, "|")
	Global $idChoose = GUICtrlCreateCombo( _
			"", 100, 50, 200, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL) _
			)
	GUICtrlSetOnEvent(-1, "LangSelect")
	GUICtrlSetData($idChoose, $sCodes, IniRead($sConfigPath, "General settings", "language", ""))
	Global $idBtn_OK = GUICtrlCreateButton( _
			"OK", _
			155, 50, 70, 30 _
			)
	GUICtrlSetOnEvent(-1, "save")
	Global $idBtn_Close = GUICtrlCreateButton( _
			"Close", _
			180, 50, 70, 30 _
			)
	GUICtrlSetOnEvent(-1, "_exitpersonaliced")
	GUISetState(@SW_SHOW)
	While 1
		If $bSelected Then
			$bReturn = True
			ExitLoop
		EndIf
	WEnd
	GUIDelete($hLangGUI)
	Opt("GUIOnEventMode", $iOldOpt)
	return $bReturn
EndFunc   ;==>Selector
; #FUNCTION# ====================================================================================================================
; Name ..........: select
; Description ...: It is a small but great function that helps to collect the language selected by the user through the GUI
; Syntax ........: select()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func LangSelect()
	$sRead = GUICtrlRead($idChoose)
	If Not $sRead = "" Then
		Global $aSplittedLanguage = StringSplit($sRead, ",") ; Example: spanish, es.
	Else
		Global $aSplittedLanguage = Null
	EndIf
	Return $aSplittedLanguage
EndFunc   ;==>LangSelect
; #FUNCTION# ====================================================================================================================
; Name ..........: save
; Description ...: This function saves the language selected by the user when running for the first time
; Syntax ........: save()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func save()
	If $sRead = "" Then
		MsgBox(16, "Error", "no language selected.")
	Else
		$bSelected = True
		IniWrite($sConfigPath, _
				"General settings", "language", StringStripWS($aSplittedLanguage[2], $STR_STRIPLEADING) _
				)
		$sLang = IniRead($sConfigPath, "General settings", "language", "")
	EndIf
EndFunc   ;==>save
