#include <Crypt.au3>
_IniWrite("opciones.ini", "general", "Test", "1")
Func _IniWrite($file, $title, $section, $text)
local $ini_Password = "Megustacomer1234567890"
IniWrite($file, StringEncrypt(True, $title, $ini_password), StringEncrypt(True, $section, $ini_password), StringEncrypt(True, $text, $ini_password))
EndFunc
Func StringEncrypt($bEncrypt, $sData, $sPassword)
	_Crypt_Startup() ; Start the Crypt library.
	Local $vReturn = ''
	If $bEncrypt Then ; If the flag is set to True then encrypt, otherwise decrypt.
		$vReturn = _Crypt_EncryptData($sData, $sPassword, $CALG_RC4)
	Else
		$vReturn = BinaryToString(_Crypt_DecryptData($sData, $sPassword, $CALG_RC4))
	EndIf
	_Crypt_Shutdown() ; Shutdown the Crypt library.
	Return $vReturn
EndFunc   ;==>StringEncrypt
