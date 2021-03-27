#include <fileConstants.au3>
#include <new\mergefiles_utf16le_v2.au3>
ReOrganizar()
Func ReOrganizar()
$VideoExtension = "mp4"
$config = iniRead("Config\config.st", "general settings", "destination folder", "")
select
case $config =""
$config="C:\MCY\Download\Audio"
endSelect
$listaudios =  _GetFilesFolder_Rekursiv($config, $VIDEOExtension, 0, 0)
For $i = 1 to $listaudioS[0]
$txtfile = FileOpen ("audio list.txt", $FC_OVERWRITE  + $FC_CREATEPATH)
FileWrite ($txtfile, $listaudios[$i] &@crlf)
FileClose ($txtfile)
Next
endfunc