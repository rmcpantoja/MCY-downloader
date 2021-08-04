#include <Crypt.au3>
Local $ini_Password = "Megustacomer1234567890"
_IniWrite("opciones.ini", "general", "Test", "Test")
Func _IniWrite($file, $title, $section, $text)
	IniWrite($file, StringEncrypt(True, $title, $ini_Password), StringEncrypt(True, $section, $ini_Password), StringEncrypt(True, $text, $ini_Password))
EndFunc   ;==>_IniWrite
$iniData = _IniRead("opciones.ini", "general", "Test", "")
MsgBox(0, "IniData", $iniData)
Func _IniRead($file, $title, $section, $text)
	IniRead($file, StringEncrypt(False, $title, $ini_Password), StringEncrypt(False, $section, $ini_Password), StringEncrypt(False, $text, $ini_Password))
EndFunc   ;==>_IniRead
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
