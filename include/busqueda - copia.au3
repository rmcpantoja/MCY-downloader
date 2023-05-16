#include <AutoItConstants.au3>
#include "GuiConstantsEx.au3"
search()
func search()
$grlanguage = "es"
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
Menuprogram()
case $search_btn
global $textoBusqueda = GUICtrlRead($imputsearch)
YtSearch($textoBusqueda)
EndSwitch
Wend
EndFunc
func ytsearch($text)
;Local $runcmd = Run(@ComSpec & " /C " & "engines64\youtube-dl-.exe -e ytsearch" &$cantidad &":" &$text, @ScriptDir, @SW_HIDE, 6)
Local $runcmd = Run(@ComSpec & " /C " & "engines64\youtube-dl-.exe -e ytsearch" &$cantidad &":" &$text, @ScriptDir, @SW_HIDE,$STDERR_CHILD + $STDOUT_CHILD)
if    @error then
MsgBox(16, "Error", "The operation cannot be performed because the Youtube-dl.exe file cannot be found.")
else
GUISetState(@SW_HIDE, $searchgui)
EndIf
ProcessWaitClose($RUNCmd)
global $results = guicreate($ms2a)
Local $line
local $idReslabel = GUICtrlCreateLabel($ms3, 120, 30, 20, 20)
Local $idSlist = GUICtrlCreateList("", 150, 30, 121, 50)
GUICtrlSetLimit(-1, 200)
$cname_btn = GUICtrlCreateButton($ms6, 190, 50, 20, 25)
$clink_btn = GUICtrlCreateButton($ms7, 220, 50, 20, 25)
$preb_btn = GUICtrlCreateButton($ms8, 250, 50, 20, 25)
$cs_btn = GUICtrlCreateButton($ms17, 280, 50, 30, 30)
$line=StdoutRead($runcmd)
If @error Then MsgBox(16, "Error", "Can't read stdout")
GUICtrlSetData($idSlist, $line)
GUISetState(@SW_SHOW)
; Loop until the user exits.
While 1
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE, $cs_btn
GuiDelete($results)
GUISetState(@SW_SHOW, $searchgui)
ExitLoop
EndSwitch
Wend
EndFunc