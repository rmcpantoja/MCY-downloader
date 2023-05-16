#include <fileConstants.au3>
#include <new\mergefiles_utf16le_v2.au3>
ReOrganizar("*.mkv")
Func ReOrganizar($Extension)
	$config = IniRead("Config\config.st", "general settings", "destination folder", "")
	Select
		Case $config = ""
			$config = "C:\MCY\Download\audio\"
	EndSelect
	;$txtfile = FileOpen ("audio list.txt", $FC_OVERWRITE  + $FC_CREATEPATH)
	FileMove($config & $Extension, $config & "\Video\", $FC_OVERWRITE + $FC_CREATEPATH)
	;FileWrite ($txtfile, $listaudios[$i] &@crlf)
	;FileClose ($txtfile)
	;Next
EndFunc   ;==>ReOrganizar
