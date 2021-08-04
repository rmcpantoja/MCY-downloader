$Say_UDfversion="0.4"
global $say="0"
$keyenter = 0
$key0 = 0
$key1 = 0
$key2 = 0
$key3 = 0
$key4 = 0
$key5 = 0
$key6 = 0
$key7 = 0
$key8 = 0
$key9 = 0
$keyspace = 0
$keyescape = 0
$keydelete = 0
$keymove = 0
$keyup = 0
$keydown = 0
$keyleft = 0
$keyright = 0
$keypgu = 0
$keypgd = 0
$keyhome = 0
$keyend = 0
$keya = 0
$keyb = 0
$keyc = 0
$keyd = 0
$keye = 0
$keyf = 0
$keyg = 0
$keyh = 0
$keyi = 0
$keyj = 0
$keyk = 0
$keyl = 0
$keym = 0
$keyn = 0
$keyo = 0
$keyp = 0
$keyq = 0
$keyr = 0
$key_s = 0
$keyt = 0
$keyu = 0
$keyv = 0
$keyx = 0
$keyy = 0
$keyz = 0
$keynumber = 0
$keyundo = 0
$keycut = 0
$keycopy = 0
$keypaste = 0
$keyselectall = 0
$keyredo = 1
func NVDA_SayCharacters()
$Lang = iniRead ("config\config.st", "General settings", "language", "")
While $say = 1
If _ispressed($shift) and _ispressed($f2) Then
select
case $lang ="es"
speaking("Hablar mientras escribes desactivado")
case $lang ="eng"
speaking("speak while typing off")
endselect
$say = 0
continueLoop
EndIf
If _ispressed($shift) AND _ispressed($f3) Then
select
case $lang ="es"
speaking("Hablar mientras escribes activado")
case $lang ="eng"
speaking("speak while typing on")
endselect
$say = 1
continueLoop
EndIf
;wend
If NOT _ispressed($enter) Then $keyenter = 0
If _ispressed($enter) AND $keyenter = 0 Then
$keyenter = 1
speaking("enter")
EndIf
If NOT _ispressed($spacebar) Then $keyspace = 0
If _ispressed($spacebar) AND $keyspace = 0 Then
$keyspace = 1
select
case $lang ="es"
speaking("Espacio")
case $lang ="eng"
speaking("Space")
endselect
EndIf
If NOT _ispressed($escape) Then $keyescape = 0
If _ispressed($escape) AND $keyescape = 0 Then
$keyescape = 1
speaking("escape")
EndIf
If NOT _ispressed($delete) OR _ispressed($backspace) Then $keydelete = 0
If _ispressed($delete) OR _ispressed($backspace) AND $keydelete = 0 Then
$keydelete = 1
select
case $lang ="es"
speaking("Borrar")
case $lang ="eng"
speaking("Delete")
endselect
EndIf
If NOT _ispressed($up) Then $keyup = 0
If NOT _ispressed($down) Then $keydown = 0
If NOT _ispressed($left) Then $keyleft = 0
If NOT _ispressed($right) Then $keyright = 0
If NOT _ispressed($home) Then $keyhome = 0
If NOT _ispressed($end) Then $keyend = 0
If NOT _ispressed($page_up) Then $keypgu = 0
If NOT _ispressed($page_down) Then $keypgd = 0
If _ispressed($up) AND $keyup = 0 Then
$keyup = 1
select
case $lang ="es"
speaking("Flecha arriba")
case $lang ="eng"
speaking("Up")
endselect
EndIf
If _ispressed($down) AND $keydown = 0 Then
$keydown = 1
select
case $lang ="es"
speaking("Flecha abajo")
case $lang ="eng"
speaking("Down")
endselect
EndIf
If _ispressed($left) AND $keyleft = 0 Then
$keyleft = 1
select
case $lang ="es"
speaking("Flecha izquierda")
case $lang ="eng"
speaking("left")
endselect
EndIf
If _ispressed($right) AND $keyright = 0 Then
$keyright = 1
select
case $lang ="es"
speaking("Flecha derecha")
case $lang ="eng"
speaking("Right")
endselect
EndIf
If _ispressed($page_up) AND $keypgu = 0 Then
$keypgu = 1
select
case $lang ="es"
speaking("Avance de página")
case $lang ="eng"
speaking("page up")
endselect
EndIf
If _ispressed($page_down) AND $keypgd = 0 Then
$keypgd = 1
select
case $lang ="es"
speaking("Retroceso de página")
case $lang ="eng"
speaking("page down")
endselect
EndIf
If _ispressed($home) AND $keyhome = 0 Then
$keyhome = 1
select
case $lang ="es"
speaking("Inicio")
case $lang ="eng"
speaking("home")
endselect
EndIf
If _ispressed($end) AND $keyend = 0 Then
$keyend = 1
select
case $lang ="es"
speaking("Fin")
case $lang ="eng"
speaking("end")
endselect
EndIf
If NOT _ispressed($a) Then $keya = 0
If NOT _ispressed($b) Then $keyb = 0
If NOT _ispressed($c) Then $keyc = 0
If NOT _ispressed($d) Then $keyd = 0
If NOT _ispressed($e) Then $keye = 0
If NOT _ispressed($f) Then $keyf = 0
If NOT _ispressed($g) Then $keyg = 0
If NOT _ispressed($h) Then $keyh = 0
If NOT _ispressed($i) Then $keyi = 0
If NOT _ispressed($j) Then $keyj = 0
If NOT _ispressed($k) Then $keyk = 0
If NOT _ispressed($l) Then $keyl = 0
If NOT _ispressed($m) Then $keym = 0
If NOT _ispressed($n) Then $keyn = 0
If NOT _ispressed($o) Then $keyo = 0
If NOT _ispressed($p) Then $keyp = 0
If NOT _ispressed($q) Then $keyq = 0
If NOT _ispressed($r) Then $keyr = 0
If NOT _ispressed($s) Then $key_s = 0
If NOT _ispressed($t) Then $keyt = 0
If NOT _ispressed($u) Then $keyu = 0
If NOT _ispressed($v) Then $keyv = 0
If NOT _ispressed($w) Then $keyw = 0
If NOT _ispressed($x) Then $keyx = 0
If NOT _ispressed($y) Then $keyy = 0
If NOT _ispressed($z) Then $keyz = 0
If _ispressed($a) AND $keya = 0 Then
$keya = 1
speaking("a")
EndIf
If _ispressed($b) AND $keyb = 0 Then
$keyb = 1
speaking("b")
EndIf
If _ispressed($c) AND $keyc = 0 Then
$keyc = 1
speaking("c")
EndIf
If _ispressed($d) AND $keyd = 0 Then
$keyd = 1
speaking("d")
EndIf
If _ispressed($e) AND $keye = 0 Then
$keye = 1
speaking("e")
EndIf
If _ispressed($f) AND $keyf = 0 Then
$keyf = 1
speaking("f")
EndIf
If _ispressed($g) AND $keyg = 0 Then
$keyg = 1
speaking("g")
EndIf
If _ispressed($h) AND $keyh = 0 Then
$keyh = 1
speaking("h")
EndIf
If _ispressed($i) AND $keyi = 0 Then
$keyi = 1
speaking("i")
EndIf
If _ispressed($j) AND $keyj = 0 Then
$keyj = 1
speaking("j")
EndIf
If _ispressed($k) AND $keyk = 0 Then
$keyk = 1
speaking("k")
EndIf
If _ispressed($l) AND $keyl = 0 Then
$keyl = 1
speaking("l")
EndIf
If _ispressed($m) AND $keym = 0 Then
$keym = 1
speaking("m")
EndIf
If _ispressed($n) AND $keyn = 0 Then
$keyn = 1
speaking("n")
EndIf
If _ispressed($o) AND $keyo = 0 Then
$keyo = 1
speaking("o")
EndIf
If _ispressed($p) AND $keyp = 0 Then
$keyp = 1
speaking("p")
EndIf
If _ispressed($q) AND $keyq = 0 Then
$keyq = 1
speaking("q")
EndIf
If _ispressed($r) AND $keyr = 0 Then
$keyr = 1
speaking("r")
EndIf
If _ispressed($s) AND $key_s = 0 Then
$key_s = 1
speaking("s")
EndIf
If _ispressed($t) AND $keyt = 0 Then
$keyt = 1
speaking("t")
EndIf
If _ispressed($u) AND $keyu = 0 Then
$keyu = 1
speaking("u")
EndIf
If _ispressed($v) AND $keyv = 0 Then
$keyv = 1
speaking("v")
EndIf
If _ispressed($w) AND $keyw = 0 Then
$keyw = 1
speaking("w")
EndIf
If _ispressed($x) AND $keyx = 0 Then
$keyx = 1
speaking("x")
EndIf
If _ispressed($y) AND $keyy = 0 Then
$keyy = 1
speaking("y")
EndIf
If _ispressed($z) AND $keyz = 0 Then
$keyz = 1
speaking("z")
EndIf
If NOT _ispressed($t1) Then $key1 = 0
If NOT _ispressed($t2) Then $key2 = 0
If NOT _ispressed($t3) Then $key3 = 0
If NOT _ispressed($t4) Then $key4 = 0
If NOT _ispressed($t5) Then $key5 = 0
If NOT _ispressed($t6) Then $key6 = 0
If NOT _ispressed($t7) Then $key7 = 0
If NOT _ispressed($t8) Then $keyt8 = 0
If NOT _ispressed($t9) Then $key9 = 0
If _ispressed($t1) AND $key1 = 0 Then
$key1 = 1
speaking("1")
EndIf
If _ispressed($t2) AND $key2 = 0 Then
$key2 = 1
speaking("2")
EndIf
If _ispressed($t3) AND $key3 = 0 Then
$key3 = 1
speaking("3")
EndIf
If _ispressed($t4) AND $key4 = 0 Then
$key4 = 1
speaking("4")
EndIf
If _ispressed($t5) AND $key5 = 0 Then
$key5 = 1
speaking("5")
EndIf
If _ispressed($t6) AND $key6 = 0 Then
$key6 = 1
speaking("6")
EndIf
If _ispressed($t7) AND $key7 = 0 Then
$key7 = 1
speaking("7")
EndIf
If _ispressed($t8) AND $key8 = 0 Then
$key8 = 1
speaking("8")
EndIf
If _ispressed($t9) AND $key9 = 0 Then
$key9 = 1
speaking("9")
EndIf
If _ispressed($t0) AND $key0 = 0 Then
$key0 = 1
speaking("0")
EndIf
If _ispressed($n1) OR _ispressed($n2) OR _ispressed($n3) OR _ispressed($n4) OR _ispressed($n5) OR _ispressed($n6) OR _ispressed($n7) OR _ispressed($n8) OR _ispressed($n9) OR _ispressed($n0) AND $keynumber = 0 Then
$keynumber = 1
select
case $lang ="es"
speaking("Teclado numérico")
case $lang ="eng"
speaking("numpad")
endselect
EndIf
If not _ispressed($control) AND _ispressed($z) Then $keyundo = 0
If not _ispressed($control) AND _ispressed($x) then $keycut = 0
If not _ispressed($control) AND _ispressed($c) Then $keycopy = 0
If not _ispressed($control) AND _ispressed($v) Then $keypaste = 0
If not _ispressed($control) AND _ispressed($a) Then $keyselectall = 0
If not _ispressed($control) AND _ispressed($y) Then $keyredo = 0
If _ispressed($control) AND _ispressed($z) AND $keyundo = 0 Then
$keyundo = 1
sleep(100)
select
case $lang ="es"
speaking("Deshacer")
case $lang ="eng"
speaking("undo")
endselect
EndIf
If _ispressed($control) AND _ispressed($x) AND $keycut = 0 Then
$keycut = 1
sleep(100)
Local $Clipdata1 = ClipGet()
select
case $lang ="es"
speaking("Se ha cortado " &$Clipdata1& " desde el portapapeles.")
case $lang ="eng"
speaking(&$clipdata1 &"it has been cut trom clipboard.")
endselect
EndIf
If _ispressed($control) AND _ispressed($c) AND $keycopy = 0 Then
$keycopy = 1
sleep(100)
Local $Clipdata2 = ClipGet()
select
case $lang ="es"
speaking("Se copió " &$Clipdata2& " al portapapeles")
case $lang ="eng"
speaking($Clipdata2 &"Copied to clipboard.")
endselect
EndIf
If _ispressed($control) AND _ispressed($v) AND $keypaste = 0 Then
$keypaste = 1
sleep(100)
Local $Clipdata3 = ClipGet()
select
case $lang ="es"
speaking($Clipdata3 &"pegado al campo de texto")
case $lang ="eng"
speaking($Clipdata3 &"Pasted into text box")
endselect
EndIf
If _ispressed($control) AND _ispressed($a) AND $keyselectall = 0 Then
$keyselectall = 1
sleep(100)
select
case $lang ="es"
speaking("Seleccionar todo")
case $lang ="eng"
speaking("Select all")
endselect
EndIf
If _ispressed($control) AND _ispressed($y) AND $keyredo = 0 Then
$keyredo = 1
sleep(100)
select
case $lang ="es"
speaking("Rehacer")
case $lang ="eng"
speaking("Redo")
endselect
EndIf
;Sleep(5)
WEnd
endfunc