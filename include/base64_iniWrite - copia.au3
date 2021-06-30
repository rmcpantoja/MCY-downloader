#include <base64.au3>
IniEncode()
func IniEncode()
$Category = _Base64Encode("general")
$Section = _Base64Encode("Section")
$Value = _Base64Encode("Value")
IniWrite("config\config.st", $category, $section, $value)
MsgBox(0, "Done", "Test 1 completed correctly!.")
endfunc
IniDecode()
func IniDecode()

$dCategory = _Base64decode("Z2VuZXJhbA==")
$dSection = _Base64decode("U2VjdGlvbg==")
$dValue = _Base64decode("VmFsdWU=")
IniWrite("config\config.st", $dcategory, $dsection, $dvalue)
$final = IniRead("config\config.st", $dcategory, $dsection, $dvalue)
MsgBox(0, "Test 2 completed correctly!", $final)
endfunc