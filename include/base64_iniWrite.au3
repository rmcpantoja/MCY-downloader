#include <base64.au3>
func _IniEncript($sFile, $sSection, $sKey, $sValue)
if $sFile = "" then
msgBox(16, "Error", "you need to enter a file name.")
return -1
elseif $sSection = "" then
msgBox(16, "Error", "You need to enter a section name.")
return -2
elseif $sKey = "" then
MSGBox(16, "Error", "You need to enter a key name")
return -3
elseif $sValue = "" then
MSGBox(16, "Error", "you need to enter a value")
return -4
endIf
$result = IniWrite($sFile, _Base64Encode($sSection), _Base64Encode($sKey), _Base64Encode($sValue))
return $result
;endfunc
;func _IniDecript($sFile, $sSection, $sKey, $sDefault)
$decode = IniRead($sFile, $sSection, $sKey, $sDefault)
if $decode = "" then
msgBox(16, "Error", "This value is blank")
return -1
EndIf
$final = BinaryToString(_Base64Decode($decode))
return $final
endfunc