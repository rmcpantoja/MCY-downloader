#include "INCLUDE\Progress.au3"
#include <fileConstants.au3>
#include <Include\mergefiles_utf16le_v2.au3>
ReOrganizar()
Func ReOrganizar()
	$VideoExtension = "mp3"
	$config = IniRead("Config\config.st", "general settings", "destination folder", "")
	Select
		Case $config = ""
			$config = "C:\MCY\Download\Audio"
	EndSelect
	$listaudios = _GetFilesFolder_Rekursiv($config, $VideoExtension, 0, 0)
	$freq = "1"
	For $i = 1 To $listaudios[0]
		$txtfile = FileOpen("audio list.txt", $FC_OVERWRITE + $FC_CREATEPATH)
		FileWrite($txtfile, $listaudios[$i] & @CRLF)
		$freq = $freq + 9
		CreateAudioProgress($freq)
		FileClose($txtfile)
	Next
EndFunc   ;==>ReOrganizar
