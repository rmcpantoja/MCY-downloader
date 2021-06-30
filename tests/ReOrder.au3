#include <fileConstants.au3>
#include <new\mergefiles_utf16le_v2.au3>
ReOrganizar("*.mkv")
Func ReOrganizar($Extension)
$config = iniRead("Config\config.st", "general settings", "destination folder", "")
select
case $config =""
$config="C:\MCY\Download\audio\"
endSelect
;$txtfile = FileOpen ("audio list.txt", $FC_OVERWRITE  + $FC_CREATEPATH)
FileMove($config &$extension, $config &"\Video\", $FC_OVERWRITE + $FC_CREATEPATH)
;FileWrite ($txtfile, $listaudios[$i] &@crlf)
;FileClose ($txtfile)
;Next
endfunc