; program compiler:
#include <Array.au3>
#include <File.au3>

; Check cmd params:
If $CmdLine[0] = 2 Then
	If $CmdLine[1] == "--arch" Then
		If $CmdLine[2] == "x86" Or $CmdLine[2] == "x64" Then
			$sArch = $CmdLine[2]
		Else
			ConsoleWriteError("Error: you mmust specify a valid architecture, x86 or x64")
			Exit (1)
		EndIf
	Else
		ConsoleWriteError("Error: invalid argument " & $CmdLine[2])
		Exit (1)
	EndIf
Else
	ConsoleWriteError("Error: invalid command line params." & @CRLF)
	Exit (1)
EndIf

Local $aPaths = [ _
		"Documentation", _
		"engines", _
		"lng", _
		"sounds" _
		]
If $sArch == "x64" Then $aPaths[1] = "engines64"
$sFileList = "*.dll;*.txt"
$sBuildDestination = @ScriptDir & "\..\compiled"

_prepare_to_compile($sArch, $aPaths, $sFileList, $sBuildDestination)

; #FUNCTION# ====================================================================================================================
; Name ..........: _prepare_to_compile
; Description ...:
; Syntax ........: _prepare_to_compile($sArch, $aPaths, $sFileList, $sBuildDestination)
; Parameters ....: $sArch               - a string value.
;                  $aPaths              - an array of unknowns.
;                  $sFileList           - a string value.
;                  $sBuildDestination   - a string value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _prepare_to_compile($sArch, $aPaths, $sFileList, $sBuildDestination)
	Local $sCopy = ""
	ConsoleWrite("Compilation util: starting stuff for " & $sArch & @CRLF)
	If @Compiled Then
		ConsoleWriteError("Error: script compiled" & @CRLF)
		Exit
	EndIf
	ConsoleWrite("Compilation util: Starting paths..." & @CRLF)
	_start_paths($sBuildDestination, $aPaths)
	ConsoleWrite("Copying files..." & @CRLF)
	_CopiFiles($sBuildDestination, $sFileList)
	If @error Then
		ConsoleWrite("Error: ")
		Switch @error
			Case 1
				ConsoleWriteError("Base dir doesn't exists." & @CRLF)
			Case 2
				ConsoleWriteError("Required files not found." & @CRLF)
			Case 3
				ConsoleWriteError("Can't compy file." & @CRLF)
		EndSwitch
		Exit
	EndIf
	ConsoleWrite("Final steps: copying final folders..." & @CRLF)
	$sCopy = _copyFolders($sBuildDestination, $aPaths)
	If @error Then
		ConsoleWrite("Error: ")
		Switch @error
			Case 1
				ConsoleWriteError("Base dir doesn't exists." & @CRLF)
			Case 2
				ConsoleWriteError("Folder " & $sCopy & " not found." & @CRLF)
		EndSwitch
		Exit
	EndIf
	ConsoleWrite("Ready to compile" & @CRLF)
	Return 1
EndFunc   ;==>_prepare_to_compile


; #FUNCTION# ====================================================================================================================
; Name ..........: _start_paths
; Description ...: Starts creating folder structure.
; Syntax ........: _start_paths($sBaseDir, $aPaths)
; Parameters ....: $sBaseDir            - The destination folder in which to create the subfolders.
;                  $aPaths              - an array containing the folders to create.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _start_paths($sBaseDir, $aPaths)
	Local $sPath = ""
	If Not FileExists($sBaseDir) Then DirCreate($sBaseDir)
	For $sPath In $aPaths
		If Not FileExists($sBaseDir & "\" & $sPath) Then DirCreate($sBaseDir & "\" & $sPath)
	Next
	Return 1
EndFunc   ;==>_start_paths
; #FUNCTION# ====================================================================================================================
; Name ..........: _CopiFiles
; Description ...: Function that is responsible for copying the files necessary for the project.
; Syntax ........: _CopiFiles($sBaseDir)
; Parameters ....: $sBaseDir            - The destination folder where the files will be copied.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _CopiFiles($sBaseDir, $sFileList)
	Local $aFiles
	If Not FileExists($sBaseDir) Then Return SetError(1, 0, "") ; please call to _start_paths first
	$aFiles = _FileListToArrayRec(@ScriptDir, $sFileList, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT)
	If @error Then Return SetError(2, 0, "")
	For $I = 1 To $aFiles[0]
		If Not FileExists($aFiles) Then FileCopy($aFiles[$I], $sBaseDir)
		If @error Then
			ExitLoop
			Return SetError(3, 0, "")
		EndIf
	Next
	Return 1
EndFunc   ;==>_CopiFiles
; #FUNCTION# ====================================================================================================================
; Name ..........: _copyFolders
; Description ...: Copies the folders and their content required for the project.
; Syntax ........: _copyFolders($sBaseDir, $aPaths)
; Parameters ....: $sBaseDir            - the destination folder.
;                  $aPaths              - An array containing the folders to be copied.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _copyFolders($sBaseDir, $aPaths)
	Local $sPath
	If Not FileExists($sBaseDir) Then Return SetError(1, 0, "") ; please call to _start_paths first
	For $sPath In $aPaths
		If Not FileExists(@ScriptDir & "\" & $sPath) Then Return SetError(2, 0, $sPath)
		ConsoleWrite("Copying folder " & @ScriptDir & "\" & $sPath & " to " & $sBaseDir & @CRLF)
		DirCopy(@ScriptDir & "\" & $sPath, $sBaseDir & "\" & $sPath, 1)
	Next
	Return 1
EndFunc   ;==>_copyFolders
