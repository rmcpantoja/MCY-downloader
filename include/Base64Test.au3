#include "base64.au3"

$Encrypt = _Base64Encode("The quick brown fox jumps over the lazy dog")
MsgBox(0, 'encripted', $Encrypt)

$Decrypt = _Base64Decode($Encrypt)
MsgBox(0, 'decripted', $Decrypt)

MsgBox(0, 'result', BinaryToString($Decrypt))
