$arreglo = StringSplit("Hola" &@crlf &"Adiós" &@crlf &"Nos vemos",@crlf)
If @Error Then return 0
$selection = $arreglo[3]
msgbox(0, $arreglo, $selection)