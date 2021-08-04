#include <AutoItConstants.au3>
#include "GuiConstantsEx.au3"
#include "radio.au3"
func search()
select
case $grlanguage ="es"
global $ms1="Buscar"
global $ms2="Escribe lo que deseas buscar: "
global $ms2a="Resultados de la búsqueda"
global $ms3="Lista de resultados a continuación:"
global $ms4="Título: "
global $ms5="Enlace de descarga"
global $ms6="Copiar título"
global $ms7="Copiar enlace de descarga"
global $ms8="Escuchar una vista prebia"
global $ms9="Reproduciendo..."
global $ms10="Retroceder 10 segundos"
global $ms11="Avanzar 10 segundos"
global $ms12="Pausar"
global $ms13="Detener"
global $ms14="cambiar volumen"
global $ms15="Error"
global $ms16="Ocurrió un error al reproducir la URL. Razón: "
global $ms17="Cerrar"
case $grlanguage ="eng"
global $ms1="Search"
global $ms2="Write what you want to search for:"
global $ms2a="Search results"
global $ms3="List of results below:"
global $ms4="Title:"
global $ms5="Download link"
global $ms6="Copy title"
global $ms7="Copy download link"
global $ms8="Listen preview"
global $ms9="Playing..."
global $ms10="Go back 10 seconds"
global $ms11="Forward 10 seconds"
global $ms12="Pause"
global $ms13="Stop"
global $ms14="change volume"
global $ms15="Error"
global $ms16="An error occurred while reproducing the URL. Reason: "
global $ms17="Close"
endselect
global $searchgui = GUICreate($ms1)
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
$idSearchlabel = GUICtrlCreateLabel($ms2, 10, 30, 20, 20)
global $imputsearch = GUICtrlCreateInput("", 10, 50, 20, 30)
$search_btn = GUICtrlCreateButton($ms1, 45, 50, 20, 25)
$close_btn = GUICtrlCreateButton($ms17, 110, 50, 20, 25)
GUISetState(@SW_SHOW)
While 1
Switch  GUIGetMsg()
Case $GUI_EVENT_CLOSE, $close_btn
GuiDelete($searchgui)
Menuprogram()
case $search_btn
global $textoBusqueda = GUICtrlRead($imputsearch)
GuiResultados()
EndSwitch
Wend
EndFunc
func ytsearch($text, $DownloadAllVideos="0")
;Local $runcmd = Run(@ComSpec & " /C " & "engines64\youtube-dl-.exe -e ytsearch" &$cantidad &":" &$text, @ScriptDir, @SW_HIDE, 6)
select
case $DownloadAllVideos="0"
Local $runcmd = Run(@ComSpec & " /C " & "engines64\youtube-dl-.exe -g ytsearch" &$cantidad &":" &$text, @ScriptDir, @SW_HIDE,$STDERR_CHILD + $STDOUT_CHILD)
Case $DownloadAllVideos="1"
Local $runcmd = Run(@ComSpec & " /C " & "engines64\youtube-dl-.exe ytsearch" &$cantidad &":" &$text, @ScriptDir, @SW_HIDE,$STDERR_CHILD + $STDOUT_CHILD)
EndSelect
if    @error then
MsgBox(16, "Error", "The operation cannot be performed because the Youtube-dl.exe file cannot be found.")
else
EndIf
ProcessWaitClose($RUNCmd)
Local $line
$line=StdoutRead($runcmd)
If @error Then MsgBox(16, "Error", "Can't read stdout")
return $line
EndFunc
func guiResultados()
GUISetState(@SW_HIDE, $searchgui)
global $results = guicreate($ms2a)
local $idReslabel = GUICtrlCreateLabel($ms3, 120, 30, 20, 20)
Local $idSlist = GUICtrlCreateList("", 150, 30, 121, 50)
GUICtrlSetLimit(-1, 200)
$cname_btn = GUICtrlCreateButton($ms6, 190, 50, 20, 25)
$clink_btn = GUICtrlCreateButton($ms7, 220, 50, 20, 25)
$preb_btn = GUICtrlCreateButton($ms8, 250, 50, 20, 25)
$cs_btn = GUICtrlCreateButton($ms17, 280, 50, 30, 30)
$loTengo = ytSearch($textoBusqueda)
GUISetState(@SW_SHOW)
$listita = StringSplit($loTengo, @LF)
For $listartitulos = 1 To $cantidad step 1
;GUICtrlSetData($idSlist, $ms4 &": " &$listita[$listartitulos])
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

func preb()
$playing = guicreate((ms9)
GuiSetState(@SW_SHOW)
if not StringInStr($seleccionado, "https://") then
MsgBox(0, "error" ,"The URL is not recognized")
EndIf
Local $MusicHandle
_Audio_init_start()
$MusicHandle = _Set_url($seleccionado)
if @error then
MSGBox(0, "error", $ms16 &@extended)
;Exit
EndIf
_Audio_play($MusicHandle)
Local $idBtn_Stop = GUICtrlCreateButton($ms12, 75, 40, 50, 25)
While 1
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE, $idBtn_Stop
_Audio_stop($MusicHandle)
_Audio_init_stop($MusicHandle)
guiDelete($playing)
EndSwitch
WEnd
EndFunc