#include <AutoItConstants.au3>
#include "GuiConstantsEx.au3"
#include "radio.au3"
; #FUNCTION# ====================================================================================================================
; Name ..........: search
; Description ...: Search whit youtube-dl or youtube-dlp
; Syntax ........: search()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
func search()
global $searchgui = GUICreate(translate($lng, "Search"))
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
$showtip = iniRead ("config\config.st", "misc", "Show tips", "")
$sayProgresses = iniRead ("config\config.st", "Accessibility", "Read download progress bar", "")
$sayTime = iniRead ("config\config.st", "Accessibility", "Read download remaining time", "")
$BeepProgresses = iniRead ("config\config.st", "Accessibility", "Beep for progress bars", "")
global $cantidad = iniRead ("config\config.st", "search", "Number of results", "")
select
case $sayProgresses =""
iniWrite ("config\config.st", "Accessibility", "Read download progress bar", "Yes")
EndSelect
Select
case $sayTime = ""
iniWrite ("config\config.st", "Accessibility", "Read download remaining time", "No")
endselect
Select
CASE $BeepProgresses = ""
iniWrite ("config\config.st", "Accessibility", "Beep for progress bars", "Yes")
endselect
Select
CASE $cantidad = ""
iniWrite ("config\config.st", "search", "Number of results", "25")
endselect
$idSearchlabel = GUICtrlCreateLabel(translate($lng, "Write what you want to search for:"), 10, 30, 20, 20)
global $inputsearch = GUICtrlCreateInput("", 10, 50, 20, 30)
$search_btn = GUICtrlCreateButton(translate($lng, "Search"), 45, 50, 20, 25)
$close_btn = GUICtrlCreateButton(translate($lng, "Close"), 110, 50, 20, 25)
GUISetState(@SW_SHOW)
While 1
Switch  GUIGetMsg()
Case $GUI_EVENT_CLOSE, $close_btn
GuiDelete($searchgui)
Menuprogram()
case $search_btn
global $textoBusqueda = GUICtrlRead($inputsearch)
GuiResultados()
EndSwitch
Wend
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: ytsearch
; Description ...: Youtube search handler
; Syntax ........: ytsearch($text [, $DownloadAllVideos="0"])
; Parameters ....: $text                - A dll struct value.
;                  $DownloadAllVideos   - [optional] An AutoIt controlID. Default is "0".
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
func ytsearch($text, $DownloadAllVideos="0")
Local $line
$bagground = $device.opensound("sounds/update.ogg", true)
$bagground.volume=0.25
$bagground.play
$bagground.repeating=1
;Local $runcmd = Run(@ComSpec & " /C " & "engines64\youtube-dl-.exe -e ytsearch" &$cantidad &":" &$text, @ScriptDir, @SW_HIDE, 6)
select
case $DownloadAllVideos="0"
if @OSArch = "x64" then
Local $runcmd = Run(@ComSpec & " /C " & "engines64\yt-dlp.exe -e ytsearch" &$cantidad &":" &$text, @ScriptDir, @SW_HIDE, 6)
msgBox(0, "Debug", "engines64\yt-dlp.exe ytsearch" &$cantidad &":" &$text)
Else
Local $runcmd = Run(@ComSpec & " /C " & "engines\yt-dlp_x86.exe -e -g ytsearch" &$cantidad &":" &$text, @ScriptDir, @SW_HIDE, 6)
EndIf
Case $DownloadAllVideos="1"
if @OSArch = "x64" then
Local $runcmd = Run(@ComSpec & " /C " & "engines64\yt-dlp.exe ytsearch" &$cantidad &":" &$text, @ScriptDir, @SW_HIDE, 6)
else
Local $runcmd = Run(@ComSpec & " /C " & "engines\yt-dlp_x86.exe ytsearch" &$cantidad &":" &$text, @ScriptDir, @SW_HIDE, 6)
EndIf
EndSelect
if    @error then
MsgBox(16, translate($lng, "Error"), translate($lng, "The operation cannot be performed because the Youtube-dl.exe file cannot be found."))
else
EndIf
ProcessWaitClose($RUNCmd)
local $line=StdoutRead($runcmd)
If @error Then MsgBox(16, translate($lng, "Error"), translate($lng, "Can't read stdout"))
$bagground.stop
MSgBox(48, "Linea de resultados", $line)
return $line
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: guiResultados
; Description ...: Search results
; Syntax ........: guiResultados()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
func guiResultados()
GUISetState(@SW_HIDE, $searchgui)
global $results = guicreate(translate($lng, "Search results"))
local $idReslabel = GUICtrlCreateLabel(translate($lng, "List of results below:"), 120, 30, 20, 20)
Local $idSlist = GUICtrlCreateList("", 150, 30, 200, 50)
GUICtrlSetLimit(-1, 300)
$cname_btn = GUICtrlCreateButton(translate($lng, "Copy title"), 190, 50, 20, 25)
$clink_btn = GUICtrlCreateButton(translate($lng, "Copy download link"), 220, 50, 20, 25)
$preb_btn = GUICtrlCreateButton(translate($lng, "Listen preview"), 250, 50, 20, 25)
$cs_btn = GUICtrlCreateButton(translate($lng, "Close"), 280, 50, 30, 30)
$loTengo = ytSearch($textoBusqueda)
GUISetState(@SW_SHOW)
$listita = StringSplit($loTengo, @LF)
For $listartitulos = 1 To $cantidad
;GUICtrlSetData($idSlist, translate($lng, "Title:") &": " &$listita[$listartitulos])
GUICtrlSetData($idSlist, $listita[$listartitulos])
Next
; Loop until the user exits.
While 1
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE, $cs_btn
GuiDelete($results)
GUISetState(@SW_SHOW, $searchgui)
ExitLoop
case $clink_btn
ClipPut(GUICtrlRead($idSlist))
case $preb_btn
global $seleccionado = GUICtrlRead($idSlist)
preb()
EndSwitch
Wend
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: preb
; Description ...: Plays a preview
; Syntax ........: preb()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
func preb()
$playing = guicreate(translate($lng, "Playing..."))
GuiSetState(@SW_SHOW)
if not StringInStr($seleccionado, "https://") then
MsgBox(16, translate($lng, "error"), translate($lng, "The URL is not recognized"))
EndIf
Local $MusicHandle
_Audio_init_start()
$MusicHandle = _Set_url($seleccionado)
if @error then
MSGBox(16, translate($lng, "error"), translate($lng, "An error occurred while playing the URL. Reason: ") &@extended)
;Exit
EndIf
_Audio_play($MusicHandle)
Local $idBtn_Stop = GUICtrlCreateButton(translate($lng, "Stop"), 75, 40, 50, 25)
While 1
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE, $idBtn_Stop
_Audio_stop($MusicHandle)
_Audio_init_stop($MusicHandle)
guiDelete($playing)
EndSwitch
WEnd
EndFunc