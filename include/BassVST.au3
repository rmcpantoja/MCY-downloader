#include-once
;
Global Const $BASS_VST_PARAM_CHANGED = 1;
Global Const $BASS_VST_EDITOR_RESIZED = 2;
Global Const $BASS_VST_AUDIO_MASTER = 3;

Global Const $BASS_VST_ERROR_NOINPUTS = 3000;;the given effect has no inputs and is probably a VST instrument and no effect
Global Const $BASS_VST_ERROR_NOOUTPUTS = 3001; ;the given effect has no outputs
Global Const $BASS_VST_ERROR_NOREALTIME = 3002; ;the given effect does not support realtime processing

Global $BASS_VST_PARAM_INFO = "char[15]  name;" & _	;examples" & _ Time, Gain, RoomType
        "char[15] FUnit;" & _ 	;examples" & _ sec, dB, type
        "char[15] Display;" & _	;the current value in a readable format, examples" & _ 0.5, -3, PLATE
        "float defaultValue;" & _	;the default value
        "char[255] rsvd;"


Global $BASS_VST_INFO = "dword ChannelHandle;" & _	 	;the channelHandle as given to BASS_VST_ChannelSetDSP()
        "dword uniqueID;" & _ 			;a unique ID for the effect (the IDs are registered at Steinberg)
        "char[79] effectName;" & _		;the effect name
        "dword effectVersion;" & _		;the effect version
        "dword effectVstVersion;" & _ 	;the VST version, the effect was written for
        "dword hostVstVersion;" & _		;the VST version supported by BASS_VST, currently 2.4
        "char[79] productName;" & _		;the product name, may be empty
        "char[79] vendorName;" & _		;the vendor name, may be empty
        "dword vendorVersion;" & _		;vendor-specific version number
        "dword chansIn;" & _      		;max. number of possible input channels
        "dword chansOut;" & _     		;max. number of possible output channels
        "dword initialDelay;" & _ 		;for algorithms which need input in the first place, in milliseconds
        "dword hasEditor;" & _   		;can the BASS_VST_EmbedEditor() function be called?
        "dword editorWidth;" & _  		;initial/current width of the editor, also note BASS_VST_EDITOR_RESIZED
        "dword editorHeight;" & _ 		;initial/current height of the editor, also note BASS_VST_EDITOR_RESIZED
        "ptr aeffect;" & _				;the underlying AEffect object (see the VST SDK)
        "char[255] rsvd;"

; #INDEX# =======================================================================================================================
; Title .........: BASSVST.au3
; Description ...: Wrapper of BassVST.DLL
; Author ........: Brett Francis (BrettF)
; Notes..........: This was horrible to create because of the ultimate lack of documentation.  The person that made this
;					could have least included a decent helpfile or readme.  >_>
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;			_BASS_VST_Startup()
;			_BASS_VST_ChannelSetDSP()
;			_BASS_VST_ChannelRemoveDSP()
;			_BASS_VST_EmbedEditor()
;			_BASS_VST_GetInfo()
;			_BASS_VST_GetParam()
;			_BASS_VST_SetParam()
;			_BASS_VST_GetParamCount()
;			_BASS_VST_GetParamInfo()
;			_BASS_VST_Resume()
;			_BASS_VST_SetBypass()
;			_BASS_VST_GetBypass()
; ===============================================================================================================================

;~ Global $_ghbassVSTDll = -1; <- BYPASSED
Global $BASS_VST_DLL_UDF_VER = "2.4.0.6"
Global $BASS_VST_UDF_VER = "10.0"
;Global $BASS_ERR_DLL_NO_EXIST = -1

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_Startup
; Description ...: Starts up BassCD functions.
; Syntax ........: _BASS_VST_Startup($sBassVSTDll = "")
; Parameters ....: -	$sBassVSTDll	-	The relative path to Bass_VST.dll.
; Return values .: Success      - Returns True
;                  Failure      - Returns False and sets @ERROR
;									@error will be set to-
;										- $BASS_ERR_DLL_NO_EXIST	-	File could not be found.
; Author ........: Prog@ndy
; Modified ......: Eukalyptus
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func DISABLED_BASS_VST_Startup($sBassVSTDll = "")
    If $_ghbassVSTDll <> -1 Then Return True
    If Not $sBassVSTDll Then $sBassVSTDll = @ScriptDir & "\bass_vst.dll"

    If Not FileExists($sBassVSTDll) Then Return SetError($BASS_ERR_DLL_NO_EXIST, 0, False)

    Local $sBit = __BASS_LibraryGetArch($sBassVSTDll)
    Select
        Case $sBit = "32" And @AutoItX64
            ConsoleWrite(@CRLF & "!BassVST.dll is for 32bit only!" & @CRLF & "Run/compile Script at 32bit" & @CRLF)
        Case $sBit = "64" And Not @AutoItX64
            ConsoleWrite(@CRLF & "!BassVST.dll is for 64bit only!" & @CRLF & "use 32bit version of BassVST.dll" & @CRLF)
    EndSelect

    If $BASS_STARTUP_VERSIONCHECK Then
        If Not @AutoItX64 And _VersionCompare(FileGetVersion($sBassVSTDll), $BASS_VST_DLL_UDF_VER) <> 0 Then ConsoleWrite(@CRLF & "!This version of BASSVST.au3 is made for BassVST.dll V" & $BASS_VST_DLL_UDF_VER & ".  Please update" & @CRLF)
        If $BASS_VST_UDF_VER <> $BASS_UDF_VER Then ConsoleWrite("!This version of BASSVST.au3 (v" & $BASS_VST_UDF_VER & ") may not be compatible to BASS.au3 (v" & $BASS_UDF_VER & ")" & @CRLF)
    EndIf

    $_ghbassVSTDll = DllOpen($sBassVSTDll)
    Return $_ghbassVSTDll <> -1
EndFunc ;==>_BASS_VST_Startup

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_ChannelSetDSP
; Description ...:
; Syntax ........: _BASS_VST_ChannelSetDSP($chan, $dllfile, $flags, $priority)
; Parameters ....: -	$
; Return values .: Success      - Returns True
;                  Failure      - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
; Author ........: Brett Francis (BrettF)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_ChannelSetDSP($chan, $dllfile, $flags, $priority)
    Local $aReturn = DllCall($_ghbassVSTDll, "DWORD", "BASS_VST_ChannelSetDSP", "dword", $chan, "str", $dllfile, "dword", $flags, "int", $priority)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc ;==>_BASS_VST_ChannelSetDSP

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_ChannelRemoveDSP
; Description ...:
; Syntax ........: _BASS_VST_ChannelRemoveDSP($vstHandle)
; Parameters ....: -	$
; Return values .: Success      - Returns True
;                  Failure      - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
; Author ........: Brett Francis (BrettF)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_ChannelRemoveDSP($vstHandle)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_ChannelRemoveDSP", "dword", $vstHandle)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc ;==>_BASS_VST_ChannelRemoveDSP

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_EmbedEditor
; Description ...:
; Syntax ........: _BASS_VST_EmbedEditor($chan, $parent)
; Parameters ....: -	$
; Return values .: Success      - Returns True
;                  Failure      - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
; Author ........: Brett Francis (BrettF)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_EmbedEditor($chan, $parent)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_EmbedEditor", "dword", $chan, "hwnd", $parent)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc ;==>_BASS_VST_EmbedEditor

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_GetInfo
; Description ...:
; Syntax ........: _BASS_VST_GetInfo($vstHandle)
; Parameters ....: -	$
; Return values .: Success      - Returns True
;                  Failure      - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
; Author ........: Brett Francis (BrettF)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_GetInfo($vstHandle)
    Local $struct = DllStructCreate($BASS_VST_INFO)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_GetInfo", $vstHandle, "ptr", DllStructGetPtr($struct))
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $struct
EndFunc ;==>_BASS_VST_GetInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_GetParam
; Description ...:
; Syntax ........: _BASS_VST_GetParam($vstHandle, $paramIndex)
; Parameters ....: -	$
; Return values .: Success      - Returns True
;                  Failure      - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
; Author ........: Brett Francis (BrettF)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_GetParam($vstHandle, $paramIndex)
    Local $aReturn = DllCall($_ghbassVSTDll, "float", "BASS_VST_GetParam", "dword", $vstHandle, "int", $paramIndex)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc ;==>_BASS_VST_GetParam

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_SetParam
; Description ...:
; Syntax ........: _BASS_VST_SetParam($vstHandle, $paramIndex, $value)
; Parameters ....: -	$
; Return values .: Success      - Returns True
;                  Failure      - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
; Author ........: Brett Francis (BrettF)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_SetParam($vstHandle, $paramIndex, $value)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_SetParam", "dword", $vstHandle, "int", $paramIndex, "float", $value)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc ;==>_BASS_VST_SetParam

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_GetParamCount
; Description ...:
; Syntax ........: _BASS_VST_GetParamCount($vstHandle)
; Parameters ....: -	$
; Return values .: Success      - Returns True
;                  Failure      - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
; Author ........: Brett Francis (BrettF)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_GetParamCount($vstHandle)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_GetParamCount", "dword", $vstHandle)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc ;==>_BASS_VST_GetParamCount

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_GetParamInfo
; Description ...:
; Syntax ........: _BASS_VST_GetParamInfo($vstHandle, $paramIndex)
; Parameters ....: -	$
; Return values .: Success      - Returns True
;                  Failure      - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
; Author ........: Brett Francis (BrettF)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_GetParamInfo($vstHandle, $paramIndex)
    Local $struct = DllStructCreate($BASS_VST_PARAM_INFO)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_GetParamInfo", "dword", $vstHandle, "int", $paramIndex, "ptr", DllStructGetPtr($struct))
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $struct
EndFunc ;==>_BASS_VST_GetParamInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_Resume
; Description ...:
; Syntax ........: _BASS_VST_Resume($vstHandle)
; Parameters ....: -	$
; Return values .: Success      - Returns True
;                  Failure      - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
; Author ........: Brett Francis (BrettF)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_Resume($vstHandle)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_Resume", "dword", $vstHandle)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc ;==>_BASS_VST_Resume

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_SetBypass
; Description ...:
; Syntax ........: _BASS_VST_SetBypass($vstHandle, $state)
; Parameters ....: -	$
; Return values .: Success      - Returns True
;                  Failure      - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
; Author ........: Brett Francis (BrettF)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_SetBypass($vstHandle, $state)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_SetBypass", "dword", $vstHandle, "int", $state)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc ;==>_BASS_VST_SetBypass

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_GetBypass
; Description ...:
; Syntax ........: _BASS_VST_GetBypass($vstHandle)
; Parameters ....: -	$
; Return values .: Success      - Returns True
;                  Failure      - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
; Author ........: Brett Francis (BrettF)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_GetBypass($vstHandle)
    Local $aReturn = DllCall($_ghbassVSTDll, "dword", "BASS_VST_GetBypass", "dword", $vstHandle)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc ;==>_BASS_VST_GetBypass
;

