#include <base64.au3>
IniEncode()
Func IniEncode()
	$Category = _Base64Encode("general")
	$Section = _Base64Encode("Section")
	$Value = _Base64Encode("Value")
	IniWrite("config\config.st", $Category, $Section, $Value)
	MsgBox(0, "Done", "Test 1 completed correctly!.")
EndFunc
IniDecode()
Func IniDecode()

	$dCategory = _Base64decode("Z2VuZXJhbA==")
	$dSection = _Base64decode("U2VjdGlvbg==")
	$dValue = _Base64decode("VmFsdWU=")
	IniWrite("config\config.st", $dCategory, $dSection, $dValue)
	$final = IniRead("config\config.st", $dCategory, $dSection, $dValue)
	MsgBox(0, "Test 2 completed correctly!", $final)
EndFunc