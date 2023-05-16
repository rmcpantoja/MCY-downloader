#include-once
#include <AutoItConstants.au3>
#include <Bass.au3>
#include <BassConstants.au3>
#include <GUIConstantsEx.au3>
#INCLUDE <InetConstants.au3>
#include <SliderConstants.au3>
#include <WindowsConstants.au3>
global $mcyradio_ver = "0.5.3"
; #FUNCTION# ====================================================================================================================
; Name ..........: radio
; Description ...: MCY radio!
; Syntax ........: radio()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
func radio()
global $Window_radio = GUICreate("MCY Radio " &$mcyradio_ver)
Global $BASS_PAUSE_POS
$VolLevel="100"
global $lng
mcyradio()
endfunc
; #FUNCTION# ====================================================================================================================
; Name ..........: Mcyradio
; Description ...: MCY radio!
; Syntax ........: Mcyradio()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func Mcyradio()
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
$ultimaURLCargada = iniRead ("config\config.st", "Misc", "Last radio loaded", "")
Global $radios[] = ["https://stream.zeno.fm/qhpfuuaq11zuv", "https://blasterradio.net/blaster", "http://stream.zeno.fm/1d6tptefguhvv"]
global $radionames[] = ["Default", "Blaster Radio", "ALD prod radio"]
Dim $helpbuttons[7]
Global $MusicHandle
Global $info1
_Audio_init_start()
select 
case $ultimaURLCargada =""
iniWrite ("config\config.st", "Misc", "Last radio loaded", $radios[0])
EndSelect
$label = GUICtrlCreateLabel(translate($lng, "Welcome!"), 0, 50, 100, 20)
Local $idpause = GUICtrlCreateButton(CHRW(9208), 90, 50, 70, 25)
Local $idStop = GUICtrlCreateButton(chrw(9209), 90, 115, 70, 25)
Local $idvolumelabel = GUICtrlCreateLabel(translate($lng, "Change volume"), 50, 140, 70, 25)
Local $idvolume = GUICtrlCreateSlider(90, 140, 70, 25, Bitor($GUI_SS_DEFAULT_SLIDER, $WS_TABSTOP))
GUICtrlSetLimit(-1, 100, 0)
GUICtrlSetData(-1, 50)
Local $idselector = GUICtrlCreateButton(translate($lng, "Radio selector"), 90, 175, 70, 25)
Local $idInfo = GUICtrlCreateButton(translate($lng, "stream/song info"), 90, 210, 70, 25)
Local $idShowhelp = GUICtrlCreateButton(translate($lng, "Help") &", " &translate($lng, "collapsed"), 90, 250, 70, 25)
$helpbuttons[0] = GUICtrlCreateButton(translate($lng, "Visit YouTube channel"), 150, 50, 70, 25)
$helpbuttons[1] = GUICtrlCreateButton(translate($lng, "&User manual"), 150, 120, 70, 25)
$helpbuttons[2] = GUICtrlCreateButton(translate($lng, "Changes"), 150, 175, 70, 25)
$helpbuttons[3] = GUICtrlCreateButton(translate($lng, "Get version for android"), 150, 230, 70, 25)
$helpbuttons[4] = GUICtrlCreateButton(translate($lng, "About..."), 150, 260, 70, 25)
$helpbuttons[5] = GUICtrlCreateButton(translate($lng, "install only MCY Radio"), 150, 300, 70, 25)
$helpbuttons[6] = GUICtrlCreateButton(translate($lng, "Privacy policy"), 150, 375, 70, 25)
for $I = 0 to UBound($helpbuttons, $UBOUND_ROWS) - 1
GUICtrlSetState($helpbuttons[$I], $GUI_HIDE)
next
Local $idBtn_Close = GUICtrlCreateButton(translate($lng, "close"), 200, 200, 100, 25)
GUISetState(@SW_SHOW)
Local $radioStopPressed = false
Local $radioPausePressed = false
Local $ShowHelpPressed = false
Local $instPressed = false
$MusicHandle = _Set_url(iniRead ("config\config.st", "Misc", "Last radio loaded", ""))
if @error then
MSGBox(0, translate($lng, "Error"), translate($lng, "The URL cannot be loaded. Reason:") &" " &@extended)
guiDelete($Window_radio)
_Audio_stop($MusicHandle)
_Audio_init_stop($MusicHandle)
Else
_Audio_play($MusicHandle)
While 1
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE, $idBtn_Close
guiDelete($Window_radio)
_Audio_stop($MusicHandle)
_Audio_init_stop($MusicHandle)
ExitLoop
Case $idInfo
if $ReadAccs = "yes" then
speaking(translate($lng, "stream/song name:") &" " &_Get_streamtitle($MusicHandle))
if _Get_streamtitle($MusicHandle) = "0" then speaking(translate($lng, "no song is playing"))
else
MsgBox(0, translate($lng, "stream/song name:"), _Get_streamtitle($MusicHandle))
EndIf
case $idpause
$RadioPausePressed = Not $RadioPausePressed
If $RadioPausePressed Then
_Audio_pause($MusicHandle)
GUICtrlSetData($idpause, chrw("9654"))
Else
_Audio_play($MusicHandle)
GUICtrlSetData($idpause, chrw(9208))
EndIf
case $idstop
$RadioStopPressed = Not $RadioStopPressed
If $RadioStopPressed Then
_Audio_stop($MusicHandle)
GUICtrlSetData($idstop, chrw(9654))
Else
_Audio_play($MusicHandle)
GUICtrlSetData($idstop, chrw(9209))
EndIf
case $idvolume
$radiovol = GUICtrlRead($idvolume)
_Set_volume($radiovol)
if $ReadAccs = "yes" then speaking(translate($lng, "music volume set to") &" " &$radiovol &"%")
case $idselector
RadioSelector()
case $idShowhelp
$ShowHelpPressed = Not $ShowHelpPressed
If $ShowHelpPressed Then
for $I = 0 to UBound($helpbuttons, $UBOUND_ROWS) - 1
GUICtrlSetState($helpbuttons[$I], $GUI_SHOW)
next
GUICtrlSetData($idShowHelp, translate($lng, "Help") &", " &translate($lng, "expanded"))
Else
for $I = 0 to UBound($helpbuttons, $UBOUND_ROWS) - 1
GUICtrlSetState($helpbuttons[$I], $GUI_HIDE)
next
GUICtrlSetData($idShowHelp, translate($lng, "Help") &", " &translate($lng, "collapsed"))
EndIf
case $helpbuttons[0]
ShellExecute("https://www.youtube.com/channel/UC85GqFKqjaAFrpJ7IPt6gcQ")
If @error then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
case $helpbuttons[1]
ShellExecute(@ScriptDir &"\documentation\" &$lng &"\manual_radio.txt")
case $helpbuttons[2]
ShellExecute(@ScriptDir &"\documentation\" &$lng &"\changes_radio.txt")
case $helpbuttons[3]
ShellExecute("https://www.appcreator24.com/app1372446")
If @error then MsgBox(16, translate($lng, "Error"), translate($lng, "Cannot run browser. It is likely that you have to add an association."))
case $helpbuttons[4]
MsgBox(0, translate($lng, "About..."), translate($lng, "MCY Radio, version") &" " &$mcyradio_ver &". " &translate($lng, "Program to listen to content such as music, live broadcasts from users, other radios, comedy and more.") &@crlf &"Author: MT Programs" &@crlf &"Original idea: Mateo Cedillo")
case $helpbuttons[5]
$instPressed = Not $instPressed
If $instPressed Then
GUICtrlSetData($helpbuttons[5], translate($lng, "uninstall MCY Radio"))
installmcyradio()
Else
GUICtrlSetData($helpbuttons[5], translate($lng, "install only MCY Radio"))
uninstallmcyradio()
EndIf
case $helpbuttons[6]
$pp = InetRead("http://www.e-droid.net/privacy.php?ida=1372446&idl=es")
$ppdata = BinaryToString($pp)
MsgBox(48, translate($lng, "Privacy Policy"), $ppdata)
EndSwitch
WEnd
_Audio_init_stop($MusicHandle)
EndIf
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: installmcyradio
; Description ...: Install MCY radio on the desktop
; Syntax ........: installmcyradio()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
func installmcyradio()
if @compiled then
If not FileExists(@DesktopDir & "\MCY Radio.lnk") then
FileCreateShortcut(@scriptDir & "\MCY.exe", @DesktopDir & "\MCY Radio.lnk", @ScriptDir, "/radio", _
translate($lng, "Enjoy the best radio content, like music and live broadcasts."), "", "^!R", "", @SW_SHOW)
MsgBox(48, translate($lng, "Information"), translate($lng, "MCY Radio has been installed on the desktop"))
else
MSgBox(16, translate($lng, "Error"), translate($lng, "MCY Radio is already installed"))
EndIf
Else
MsgBox(16, translate($lng, "Error"), translate($lng, "Can't install MCY Radio from source code"))
EndIf
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: uninstallmcyradio
; Description ...: Uninstall MCY radio from computer
; Syntax ........: uninstallmcyradio()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
func uninstallmcyradio()
$confirmuninst = MsgBox(4, translate($lng, "Uninstall MCY Radio"), translate($lng, "Are you sure?"))
select
case $confirmuninst = 6
$uninst = FileDelete(@DesktopDir & "\MCY Radio.lnk")
If $uninst = 0 then
MSgBox(16, translate($lng, "Error"), translate($lng, "Failed to uninstall MCY Radio. It is likely that it has already been uninstalled."))
Else
MsgBox(48, translate($lng, "Information"), translate($lng, "MCY Radio has been uninstalled"))
EndIf
return 1
EndSelect
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: RadioSelector
; Description ...: Radio selector
; Syntax ........: RadioSelector()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
func RadioSelector()
$ifitisdefault = ""
GUISetState(@SW_HIDE, $Window_radio)
$rsdialog = GuiCreate(translate($lng, "List of radios"))
GUISetBkColor(0x00E0FFFF)
$rslabel = GuiCtrlCreateLabel(translate($lng, "select a radio from the list to turn it on and hit apply when done:"), 0, 10, 50, 20)
$listlabel = GuiCtrlCreateLabel(translate($lng, "radio list"), 85, 10, 50, 20)
$radioList = GUICtrlCreateListView(translate($lng, "Radio") &"|" &translate($lng, "URL"), 85, 90, 300, 20)
for $I = 0 to UBound($radios, $UBOUND_ROWS) - 1
If iniRead("config\config.st", "Misc", "Last radio loaded", "") = $radios[$i] then $ifitisdefault &= $radionames[$I] &" " &translate($lng, "is set as default") &"."
GUICtrlCreateListViewItem($radionames[$i] &"|" &$radios[$i], $radioList)
Next
GuiCtrlSetData($rslabel, translate($lng, "Status:") &" " &$ifitisdefault)
$rscopy = GuiCtrlCreateButton(translate($lng, "Copy &URL"), 140, 10, 50, 20)
$rsaply = GuiCtrlCreateButton(translate($lng, "&Aply"), 140, 60, 50, 20)
$rsclose = GuiCtrlCreateButton(translate($lng, "&Close"), 140, 120, 50, 20)
GuiSetState(@SW_SHOW)
While 1
Switch GUIGetMsg()
Case $GUI_EVENT_CLOSE, $rsclose
guiDelete($rsdialog)
GUISetState(@SW_SHOW, $Window_radio)
ExitLoop
case $rscopy
$OnlyTheRadioPlease = StringSplit(GUICtrlRead(GUICtrlRead($radioList)), "|")
ClipPut($OnlyTheRadioPlease[2])
guiDelete($rsdialog)
GUISetState(@SW_SHOW, $Window_radio)
ExitLoop
case $rsaply
$OnlyTheRadioPlease = StringSplit(GUICtrlRead(GUICtrlRead($radioList)), "|")
_Audio_stop($MusicHandle)
_Audio_init_stop($MusicHandle)
iniWrite ("config\config.st", "Misc", "Last radio loaded", $OnlyTheRadioPlease[2])
sleep(100)
_Audio_init_start()
$MusicHandle = _Set_url(iniRead ("config\config.st", "Misc", "Last radio loaded", ""))
_Audio_play($MusicHandle)
guiDelete($rsdialog)
GUISetState(@SW_SHOW, $Window_radio)
ExitLoop
EndSwitch
wend
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: sayinfo
; Description ...: Stream or song information
; Syntax ........: sayinfo()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
func sayinfo()
$MusicHandle = _Set_url(iniRead ("config\config.st", "Misc", "Last radio loaded", ""))
local $info2 = _Get_streamtitle($MusicHandle)
Sleep(300)
speaking(translate($lng, "stream/song name:") &" " &$info2)
if $info2 = "0" then speaking(translate($lng, "no song is playing"))
endfunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _Audio_init_start
; Description ...: BASS init
; Syntax ........: _Audio_init_start()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Audio_init_start()
If _BASS_STARTUP(@ScriptDir & "\bass.dll") Then
If _BASS_Init(0, -1, 48000, 0) Then
If _BASS_SetConfig($BASS_CONFIG_NET_PLAYLIST, 1) = 0 Then
SetError(3)
EndIf
Else
SetError(2)
EndIf
Else
SetError(@error)
EndIf
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _Set_buffer
; Description ...: Set buffer
; Syntax ........: _Set_buffer($buffer)
; Parameters ....: $buffer              - A boolean value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Set_buffer($buffer)
_BASS_SetConfig($BASS_CONFIG_NET_BUFFER, $buffer)
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _Audio_stop
; Description ...: Stops and audio handle
; Syntax ........: _Audio_stop($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Audio_stop($MusicHandle)
_BASS_ChannelStop($MusicHandle)
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _Audio_play
; Description ...: Plays a specific sound
; Syntax ........: _Audio_play($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Audio_play($MusicHandle)
_BASS_ChannelPlay($MusicHandle, 1)
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _Audio_pause
; Description ...: stops playing a specific audio
; Syntax ........: _Audio_pause($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Audio_pause($MusicHandle)
If _Get_playstate($MusicHandle) = 2 Then
$BASS_PAUSE_POS = _BASS_ChannelGetPosition($MusicHandle, $BASS_POS_BYTE)
_BASS_ChannelPause($MusicHandle)
ElseIf _Get_playstate($MusicHandle) = 3 Then
_Audio_play($MusicHandle)
_BASS_ChannelSetPosition($MusicHandle, $BASS_PAUSE_POS, $BASS_POS_BYTE)
EndIf
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _Audio_init_stop
; Description ...: stops playing a specific audio
; Syntax ........: _Audio_init_stop($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Audio_init_stop($MusicHandle)
_BASS_StreamFree($MusicHandle)
_BASS_Free()
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _Set_url
; Description ...: set a URL as a sound to load to BASS
; Syntax ........: _Set_url($file)
; Parameters ....: $file                - A floating point number value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Set_url($file)
If FileExists($file) Then
$MusicHandle = _BASS_StreamCreateFile(False, $file, 0, 0, 0)
Else
$MusicHandle = _BASS_StreamCreateURL($file, 0, 1)
EndIf
If @error Then
Return SetError(1)
EndIf
Return $MusicHandle
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _Get_pos
; Description ...: get the position of a song
; Syntax ........: _Get_pos($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Get_pos($MusicHandle)
$current = _BASS_ChannelGetPosition($MusicHandle, $BASS_POS_BYTE)
Return Round(_Bass_ChannelBytes2Seconds($MusicHandle, $current))
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _Get_len
; Description ...: get the lenght of a song
; Syntax ........: _Get_len($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Get_len($MusicHandle)
$current = _BASS_ChannelGetLength($MusicHandle, $BASS_POS_BYTE)
Return Round(_Bass_ChannelBytes2Seconds($MusicHandle, $current))
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _Set_pos
; Description ...: Set's the lenght of a song
; Syntax ........: _Set_pos($MusicHandle, $seconds)
; Parameters ....: $MusicHandle         - An unknown value.
;                  $seconds             - A string value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Set_pos($MusicHandle, $seconds)
_BASS_ChannelSetPosition($MusicHandle, _BASS_ChannelSeconds2Bytes($MusicHandle, $seconds), $BASS_POS_BYTE)
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _Set_volume
; Description ...: Set's the volume of a song
; Syntax ........: _Set_volume($volume)
; Parameters ....: $volume              - A variant value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Set_volume($volume)
_BASS_SetConfig($BASS_CONFIG_GVOL_STREAM, $volume * 100)
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _Get_volume
; Description ...: Gets the volume of a song
; Syntax ........: _Get_volume()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Get_volume()
Return _BASS_GetConfig($BASS_CONFIG_GVOL_STREAM) / 100
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _Get_bitrate
; Description ...: get the bit rate of an audio
; Syntax ........: _Get_bitrate($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Get_bitrate($MusicHandle)
$a = Round(_Bass_ChannelBytes2Seconds($MusicHandle, _BASS_ChannelGetLength($MusicHandle, $BASS_POS_BYTE)))
$return = Round(_BASS_StreamGetFilePosition($MusicHandle, $BASS_FILEPOS_END) * 8/ $a/ 1000)
If StringInStr($return, "-") Then
$return = _BASS_StreamGetFilePosition($MusicHandle, $BASS_FILEPOS_END) * 8 / _BASS_GetConfig($BASS_CONFIG_NET_BUFFER)
EndIf
Return $return
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _Get_playstate
; Description ...: Get the playback status of a song
; Syntax ........: _Get_playstate($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Get_playstate($MusicHandle)
Switch _BASS_ChannelIsActive($MusicHandle)
Case $BASS_ACTIVE_STOPPED
$returnstate = 1
Case $BASS_ACTIVE_PLAYING
$returnstate = 2
Case $BASS_ACTIVE_PAUSED
$returnstate = 3
Case $BASS_ACTIVE_STALLED
$returnstate = 4
EndSwitch
Return $returnstate
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: _Get_streamtitle
; Description ...: get the name of the song
; Syntax ........: _Get_streamtitle($MusicHandle)
; Parameters ....: $MusicHandle         - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Get_streamtitle($MusicHandle)
$pPtr = _BASS_ChannelGetTags($MusicHandle, $BASS_TAG_META)
$sStr = _BASS_PtrStringRead($pPtr)
If StringInStr($sStr, ";") Then
$infosplit = StringSplit($sStr, ";")
$infosplit[1] = StringReplace($infosplit[1], "'", "")
$infosplit[1] = StringReplace($infosplit[1], "StreamTitle=", "")
If StringInStr($infosplit[1], "-") Then
Return $infosplit[1]
EndIf
EndIf
EndFunc