#include-once
;
Global Const $BASS_VST_PARAM_CHANGED = 1
Global Const $BASS_VST_EDITOR_RESIZED = 2
Global Const $BASS_VST_AUDIO_MASTER = 3
;
Global Const $BASS_VST_ERROR_NOINPUTS = 3000 ; the given effect has no inputs and is probably a VST instrument and no effect
Global Const $BASS_VST_ERROR_NOOUTPUTS = 3001 ; the given effect has no outputs
Global Const $BASS_VST_ERROR_NOREALTIME = 3002 ; the given effect does not support realtime processing
;
Global $BASS_VST_PARAM_INFO = _
        "char name[16];" & _          ; Time, Gain, RoomType
        "char unit[16];" & _ 	      ; sec, dB, type
        "char display[16];" & _       ; the current value in a readable format, examples: 0.5, -3, PLATE
        "float defaultValue;"         ; the default value - this is the value used by the VST plugin just after creation

Local $BASS_VST_INFO = _
        "dword channelHandle;" & _    ; the channelHandle as given to BASS_VST_ChannelSetDSP()
        "dword uniqueID;" & _         ; a unique ID for the effect (the IDs are registered at Steinberg)
        "char effectName[80];" & _    ; the effect name
        "dword effectVersion;" & _    ; the effect version
        "dword effectVstVersion;" & _ ; the VST version, the effect was written for
        "dword hostVstVersion;" & _   ; the VST version supported by BASS_VST, currently 2.4
        "char productName[80];" & _   ; the product name, may be empty
        "char vendorName[80];" & _    ; the vendor name, may be empty
        "dword vendorVersion;" & _    ; vendor-specific version number
        "dword chansIn;" & _          ; max. number of possible input channels
        "dword chansOut;" & _         ; max. number of possible output channels
        "dword initialDelay;" & _     ; for algorithms which need input in the first place, in milliseconds
        "dword hasEditor;" & _        ; can the BASS_VST_EmbedEditor() function be called?
        "dword editorWidth;" & _      ; initial/current width of the editor, also note BASS_VST_EDITOR_RESIZED
        "dword editorHeight;" & _     ; initial/current height of the editor, also note BASS_VST_EDITOR_RESIZED
        "ptr aeffect;" & _            ; the underlying AEffect object (see the VST SDK)
        "dword isInstrument;" & _     ; 1=the VST plugin is an instrument, 0=the VST plugin is an effect
        "dword dspHandle;"            ; the internal DSP handle

;
; #INDEX# =======================================================================================================================
; Title .........: BASSVST.au3
; Description ...: Wrapper of BassVST.DLL
; Author ........: Brett Francis (BrettF)
; Notes..........: This was horrible to create because of the ultimate lack of documentation.
;                  The person that made this could have least included a decent helpfile or readme.  >_>
;--------------------------------------------------------------------------------------------------------
;
;
; Modified by ripdad
;
; _BASS_VST_GetInfo ..........: Fixed May 03, 2020 (thanks to TheXman for dll structure)
; _BASS_VST_GetParamInfo .....: Fixed May 03, 2020 (thanks to TheXman for dll structure)
; _BASS_VST_ChannelRemoveDSP .: Fixed May 14, 2020 (added channel handle parameter)
;
;
;
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;
; _BASS_VST_Startup()
; _BASS_VST_ChannelSetDSP()
; _BASS_VST_ChannelRemoveDSP()
; _BASS_VST_EmbedEditor()
; _BASS_VST_GetInfo()
; _BASS_VST_GetParam()
; _BASS_VST_SetParam()
; _BASS_VST_GetParamCount()
; _BASS_VST_GetParamInfo()
; _BASS_VST_Resume()
; _BASS_VST_SetBypass()
; _BASS_VST_GetBypass()
;
;
; Added Functions by ripdad (May 14, 2020)
; DLL Version: 2.4.1.0 - http://www.un4seen.com/download.php?z/5/bass_vst24
;
; _BASS_VST_GetProgram()
; _BASS_VST_SetProgram()
; _BASS_VST_GetProgramCount()
; _BASS_VST_HasEditor()
;
; ===============================================================================================================================
;
Global $_ghbassVSTDll = -1
Global $BASS_VST_DLL_UDF_VER = "2.4.1.0"
Global $BASS_VST_UDF_VER = "10.0"
Global $BASS_ERR_DLL_NO_EXIST = -1
;
; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_Startup
; Description ...: Starts up Bass_VST functions.
; Syntax ........: _BASS_VST_Startup($sBassVSTDll = "")
;
; Parameters ....: $sBassVSTDll - The relative path to Bass_VST.dll.
;
; Return values .: Success - Returns True
;                  Failure - Returns False and sets @ERROR
;                            @error will be set to $BASS_ERR_DLL_NO_EXIST - File could not be found.
;
; Author ........: Prog@ndy
; Modified ......: Eukalyptus, ripdad
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_Startup($sBassVSTDll = "")
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
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_ChannelSetDSP
; Description ...:
; Syntax ........: _BASS_VST_ChannelSetDSP($hChannel, $sDllFile, $flags, $priority)
;
; Parameters ....: $hChannel - the record or play stream
;                  $sDllFile - full path to the VST DLL
;                  $flags    - 0 = none, BASS_UNICODE, BASS_VST_KEEP_CHANS (refer to bass_vst.h)
;                  $priority - position in chain (higher numbers are given priority in chain. ex: 3 = first in chain, 2 = next in chain, 1 = last in chain)
;
; Return values .: Success - Returns the handle to the VST effect. (actually the position of the VST effect in chain)
;                  Failure - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
;
; Author ........: Brett Francis (BrettF)
; Modified ......: ripdad (May 14, 2020)
; Remarks .......:
; Related .......: _BASS_VST_ChannelRemoveDSP
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_ChannelSetDSP($hChannel, $sDllFile, $flags, $priority)
    Local $aReturn = DllCall($_ghbassVSTDll, "dword", "BASS_VST_ChannelSetDSP", "dword", $hChannel, "str", $sDllFile, "dword", $flags, "int", $priority)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_ChannelRemoveDSP
; Description ...:
; Syntax ........: _BASS_VST_ChannelRemoveDSP($hChannel, $vstHandle)
;
; Parameters ....: $hChannel  - the record or play stream
;                  $vstHandle - the handle returned by _BASS_VST_ChannelSetDSP()
;
; Return values .: Success - Returns True
;                  Failure - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
; Author ........: Brett Francis (BrettF)
; Modified ......: ripdad (May 14, 2020)
; Remarks .......:
; Related .......: _BASS_VST_ChannelSetDSP
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_ChannelRemoveDSP($hChannel, $vstHandle)
    Local $aReturn = DllCall($_ghbassVSTDll, "dword", "BASS_VST_ChannelRemoveDSP", "dword", $hChannel, "dword", $vstHandle)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_EmbedEditor
; Description ...: embeds the vst effect onto a gui (the gui dimensions can be obtained from _BASS_VST_GetInfo (#14=width, #15=height))
; Syntax ........: _BASS_VST_EmbedEditor($vstHandle, $hParent)
;
; Parameters ....: $vstHandle - the handle returned by _BASS_VST_ChannelSetDSP()
;                  $hParent   - the handle of the GUI displaying the vst effect controls (if the vst itself has an editor)
;
; Return values .: Success - Returns True
;                  Failure - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
; Author ........: Brett Francis (BrettF)
; Modified ......: ripdad
; Remarks .......:
; Related .......: _BASS_VST_GetInfo
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_EmbedEditor($vstHandle, $hParent)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_EmbedEditor", "dword", $vstHandle, "hwnd", $hParent)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_GetInfo
; Description ...: returns information about the vst effect
; Syntax ........: _BASS_VST_GetInfo($vstHandle)
;
; Parameters ....: $vstHandle - the handle returned by _BASS_VST_ChannelSetDSP()
;
; Return values .: Success - returns a struct to be used with DllStructGetData()
;                  Failure - returns False and sets @ERROR as set by _Bass_ErrorGetCode()
;
; Author ........: Brett Francis (BrettF)
; Modified ......: ripdad (May 03, 2020) - Thanks to TheXman
; Remarks .......:
; Related .......: _BASS_VST_ChannelSetDSP
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_GetInfo($vstHandle)
    Local $struct = DllStructCreate($BASS_VST_INFO)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_GetInfo", "dword", $vstHandle, "struct*", $struct)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    If IsDllStruct($struct) Then Return $struct
    Return SetError(1, 0, 0)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_GetParam
; Description ...:
; Syntax ........: _BASS_VST_GetParam($vstHandle, $paramIndex)
;
; Parameters ....: $vstHandle  - the handle returned by _BASS_VST_ChannelSetDSP()
;                  $paramIndex - the parameter index number
;
; Return values .: Success - returns the value for $paramIndex
;                  Failure - returns False and sets @ERROR as set by _Bass_ErrorGetCode()
;
; Author ........: Brett Francis (BrettF)
; Modified ......: ripdad
; Remarks .......:
; Related .......: _BASS_VST_SetParam, _BASS_VST_GetParamInfo, _BASS_VST_GetParamCount
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_GetParam($vstHandle, $paramIndex)
    Local $aReturn = DllCall($_ghbassVSTDll, "float", "BASS_VST_GetParam", "dword", $vstHandle, "int", $paramIndex)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_SetParam
; Description ...:
; Syntax ........: _BASS_VST_SetParam($vstHandle, $paramIndex, $value)
;
; Parameters ....: $vstHandle  - the handle returned by _BASS_VST_ChannelSetDSP()
;                  $paramIndex - the parameter index number
;                  $value      - the value you want set
;
; Return values .: Success - Returns True
;                  Failure - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
;
; Author ........: Brett Francis (BrettF)
; Modified ......: ripdad
; Remarks .......:
; Related .......: _BASS_VST_GetParam, _BASS_VST_GetParamInfo, _BASS_VST_GetParamCount
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_SetParam($vstHandle, $paramIndex, $value)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_SetParam", "dword", $vstHandle, "int", $paramIndex, "float", $value)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_GetParamCount
; Description ...:
; Syntax ........: _BASS_VST_GetParamCount($vstHandle)
;
; Parameters ....: $vstHandle - the handle returned by _BASS_VST_ChannelSetDSP()
;
; Return values .: Success - returns the number of parameters of a vst effect (if any)
;                  Failure - returns False and sets @ERROR as set by _Bass_ErrorGetCode()
;
; Author ........: Brett Francis (BrettF)
; Modified ......: ripdad
; Remarks .......:
; Related .......: _BASS_VST_GetParam, _BASS_VST_SetParam, _BASS_VST_GetParamInfo
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_GetParamCount($vstHandle)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_GetParamCount", "dword", $vstHandle)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_GetParamInfo
; Description ...:
; Syntax ........: _BASS_VST_GetParamInfo($vstHandle, $paramIndex)
;
; Parameters ....: $vstHandle  - the handle returned by _BASS_VST_ChannelSetDSP()
;                  $paramIndex - the parameter index number
;
; Return values .: Success - returns a struct to be used with DllStructGetData()
;                  Failure - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
;
; Author ........: Brett Francis (BrettF)
; Modified ......: ripdad (May 03, 2020) - Thanks to TheXman
; Remarks .......:
; Related .......: _BASS_VST_GetParamCount, _BASS_VST_GetParam, _BASS_VST_SetParam
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_GetParamInfo($vstHandle, $paramIndex)
    Local $struct = DllStructCreate($BASS_VST_PARAM_INFO)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_GetParamInfo", "dword", $vstHandle, "int", $paramIndex, "struct*", $struct)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    If IsDllStruct($struct) Then Return $struct
    Return SetError(1, 0, 0)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_Resume
; Description ...: This will reset the internal VST buffers which may remember some "old" data.
; Syntax ........: _BASS_VST_Resume($vstHandle)
;
; Parameters ....: $vstHandle - the handle returned by _BASS_VST_ChannelSetDSP()
;
; Return values .: Success - Returns True
;                  Failure - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
;
; Author ........: Brett Francis (BrettF)
; Modified ......: ripdad
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
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_SetBypass
; Description ...: Sets the bypass state of a vst effect
; Syntax ........: _BASS_VST_SetBypass($vstHandle, $state)
;
; Parameters ....: $vstHandle - the handle returned by _BASS_VST_ChannelSetDSP()
;                  $state     - 1 = bypass, 0 = no bypass

; Return values .: Success - Returns True
;                  Failure - Returns False and sets @ERROR as set by _Bass_ErrorGetCode()
;
; Author ........: Brett Francis (BrettF)
; Modified ......: ripdad
; Remarks .......:
; Related .......: _BASS_VST_GetBypass
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_SetBypass($vstHandle, $state)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_SetBypass", "dword", $vstHandle, "int", $state)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_GetBypass
; Description ...: Obtains the bypass state of a vst effect
; Syntax ........: _BASS_VST_GetBypass($vstHandle)
;
; Parameters ....: $vstHandle - the handle returned by _BASS_VST_ChannelSetDSP()
;
; Return values .: Success - returns bypass state (1 = bypassed, 0 = not bypassed)
;                  Failure - returns False and sets @ERROR as set by _Bass_ErrorGetCode()
;
; Author ........: Brett Francis (BrettF)
; Modified ......: ripdad
; Remarks .......:
; Related .......: _BASS_VST_SetBypass
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _BASS_VST_GetBypass($vstHandle)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_GetBypass", "dword", $vstHandle)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_GetProgram
; Description ...: Gets the current program number of a vst effect, if available.
; Syntax ........: _BASS_VST_GetProgram($vstHandle)
;
; Parameters ....: $vstHandle - the handle returned by _BASS_VST_ChannelSetDSP()

; Return values .: Success - returns program number, minus 1
;                  Failure - returns False and sets @ERROR as set by _Bass_ErrorGetCode()
;
; Author ........: ripdad
; Modified ......:
; Remarks .......:
; Related .......: _BASS_VST_SetProgram, _BASS_VST_GetProgramCount
; Link ..........:
; Example .......:
;================================================================================================================================
Func _BASS_VST_GetProgram($vstHandle)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_GetProgram", "dword", $vstHandle)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_SetProgram
; Description ...: Sets the program number of a vst effect, if available.
; Syntax ........: _BASS_VST_SetProgram($vstHandle, $programIndex)
;
; Parameters ....: $vstHandle - the handle returned by _BASS_VST_ChannelSetDSP()
;                  $programIndex - the number of the program, minus 1

; Return values .: Success - returns True
;                  Failure - returns False and sets @ERROR as set by _Bass_ErrorGetCode()
;
; Author ........: ripdad
; Modified ......:
; Remarks .......: If you want program 24, then substract 1 and set it to 23.
; Related .......: _BASS_VST_GetProgram, _BASS_VST_GetProgramCount
; Link ..........:
; Example .......:
;================================================================================================================================
Func _BASS_VST_SetProgram($vstHandle, $programIndex)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_SetProgram", "dword", $vstHandle, 'int', $programIndex)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_GetProgramCount
; Description ...: Gets the number of programs a vst effect has, if available.
; Syntax ........: _BASS_VST_GetProgramCount($vstHandle)
;
; Parameters ....: $vstHandle - the handle returned by _BASS_VST_ChannelSetDSP()

; Return values .: Success - returns number of programs
;                  Failure - returns False and sets @ERROR as set by _Bass_ErrorGetCode()
;
; Author ........: ripdad
; Modified ......:
; Remarks .......:
; Related .......: _BASS_VST_GetProgram, _BASS_VST_SetProgram
; Link ..........:
; Example .......:
;================================================================================================================================
Func _BASS_VST_GetProgramCount($vstHandle)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_GetProgramCount", "dword", $vstHandle)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _BASS_VST_HasEditor
; Description ...: Query a vst effect to see if it has an editor.
; Syntax ........: _BASS_VST_HasEditor($vstHandle)
;
; Parameters ....: $vstHandle - the handle returned by _BASS_VST_ChannelSetDSP()

; Return values .: Success - returns 1 = Yes or 0 = No
;                  Failure - returns False and sets @ERROR as set by _Bass_ErrorGetCode()
;
; Author ........: ripdad
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
;================================================================================================================================
Func _BASS_VST_HasEditor($vstHandle)
    Local $aReturn = DllCall($_ghbassVSTDll, "int", "BASS_VST_HasEditor", "dword", $vstHandle)
    If @error Then Return SetError(1, 1, 0)
    If $aReturn[0] = $BASS_DWORD_ERR Then Return SetError(_BASS_ErrorGetCode(), 0, 0)
    Return $aReturn[0]
EndFunc
;
