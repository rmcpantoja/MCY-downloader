#include <base64.au3>
IniEncode()
func IniEncode()
$Category = _Base64Encode("general")
$Section = _Base64Encode("Section")
$Value = _Base64Encode("Value")
IniWrite("config\config.st", $category, $section, $value)
MsgBox(0, "Done", "Test 1 completed correctly!.")
;endfunc
;IniDecode()
;func IniDecode()
$decode = IniRead("config\config.st", $Category, $section, $value)
$final = _Base64Decode($decode)
MsgBox(0, "Test 2 completed correctly!", $final)
endfunc