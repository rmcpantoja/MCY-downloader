; #pragma compile(Icon, C:\Program Files\AutoIt3\Icons\au3.ico)
#pragma compile(ExecLevel, Lowestavailable)
#pragma compile(UPX, False)
#pragma compile(FileDescription, Bug Reporter)
#pragma compile(ProductName, Bug reporter)
#pragma compile(ProductVersion, 1.3.0.0)
#pragma compile(FileVersion, 1.3.0.0, 1.3.0.0)
#pragma compile(LegalCopyright, © 2018-2020 MT Programs, All rights reserved)
#pragma compile(CompanyName, 'MT Programs')
;Include
;FileInstall("nvdaControllerClient32.dll", "nvdaControllerClient32.dll")
#include <MsgBoxConstants.au3>
#include <NVDAControllerClient.au3>
#include <StringConstants.au3>
If _StringInArray($CmdLine, 'sendError') Or _StringInArray($CmdLine, '/report') Or _StringInArray($CmdLine, '/RunBgr') Then
$mainlanguage = iniRead ("config\config.st", "General settings", "language", "")
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
	Else
		MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR, "Error", "MCY Downloader is not currently running. Exiting...")
exit
	EndIf
Func _StringInArray($a_Array, $s_String)
	Local $i_ArrayLen = UBound($a_Array) - 1
	For $i = 0 To $i_ArrayLen
		If $a_Array[$i] = $s_String Then
			Return $i
		EndIf
	Next
	SetError(1)
	Return 0
EndFunc
select
case $mainlanguage ="es"
$mensaje=InputBox("Reportar un error...", "Cuéntanos en este cuadro qué es lo que deseas reportar o sugerirnos:", "", " M2000")
if $mensaje="" then
$mensaje="Este mensaje está en blanco..."
endif
$yourname=InputBox("tu nombre", "escribe tu nombre en este campo a continuación:", "")
if $yourname="" then
$yourname="Alguien sin identificarse"
endif
$combo=InputBox("Correo Electrónico, opcional", "Escribe tu correo electrónico en caso de que necesitemos ponernos en contacto contigo.", "")
if $combo="" then
$combo="No se ha especificado."
endif
$correo="Correo electrónico: " (&$combo)
case $mainlanguage ="eng"
$mensaje=InputBox("Report a bug...", "Tell us in this box what you want to report or suggest:", "")
if $mensaje="" then
$mensaje="This message is blank ..."
endif
$yourname=InputBox("Your name", "write your name in this field below:", "", " M2000")
if $yourname="" then
$yourname="Someone unidentified"
endif
$correo="Email: " (&$combo)
$combo=InputBox("Email, optional", "Write your email in case we need to contact you.", "")
if $combo="" then
$combo="Not specified."
endif
endselect
$program="MCY Downloader, "
;##################################
; Include
;##################################
#Include<file.au3>
;##################################
; Variables
;##################################
$SmtpServer = "smtp.gmail.com"              ; address for the smtp-server to use - REQUIRED
select
case $mainlanguage ="es"
$FromName = "Reportero de errores"                      ; name from who the email was sent
case $mainlanguage ="eng"
$FromName = "Bug reporter"                      ; name from who the email was sent
endselect
$FromAddress = "reporterodeerrores@gmail.com" ; address from where the mail should come
$ToAddress = "angelitomateocedillo@gmail.com"   ; destination address of the email - REQUIRED
select
case $mainlanguage ="es"
$Su1=" nos ha enbiado un reporte de error"
$Subject = ($program &$yourname &$su1)                   ; subject from the email - can be anything you want it to be
case $mainlanguage ="eng"
$Su1=" You have sent us an error report"
$Subject = ($program &$yourname &$su1)                   ; subject from the email - can be anything you want it to be
endselect
select
case $mainlanguage ="es"
$gr="Gracias, el reportero de errores."
$Body = ($mensaje &@crlf &$correo &@crlf &$gr)                             ; the messagebody from the mail - can be left blank but then you get a blank mail
case $mainlanguage ="eng"
$gr="Thanks, the bug reporter."
$Body = ($mensaje &@crlf &$correo &@crlf &$gr)                              ; the messagebody from the mail - can be left blank but then you get a blank mail
endselect
$AttachFiles = ""                       ; the file(s) you want to attach seperated with a ; (Semicolon) - leave blank if not needed
$CcAddress = ""       ; address for cc - leave blank if not needed
$BccAddress = ""     ; address for bcc - leave blank if not needed
$Importance = "High"                  ; Send message priority: "High", "Normal", "Low"
$Username = "Reporterodeerrores"                    ; username for the account used from where the mail gets sent - REQUIRED
$Password = "superpollo1234567890"                  ; password for the account used from where the mail gets sent - REQUIRED
$IPPort = 465                            ; port used for sending the mail
$ssl = 1                                ; enables/disables secure socket layer sending - put to 1 if using httpS
;~ $IPPort=465                          ; GMAIL port used for sending the mail
;~ $ssl=1                               ; GMAILenables/disables secure socket layer sending - put to 1 if using httpS

;##################################
; Script
;##################################
Func _SednMail ($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
	Global $oMyRet[2]
	Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
	$rc = _INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
	If @error Then
		MsgBox(0, "Error sending message", "Error code:" & @error & "  Description:" & $rc)
	EndIf
endfunc
;
; The UDF
_SednMail ($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
Func _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $as_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = "", $s_Importance="Normal", $s_Username = "", $s_Password = "", $IPPort = 465, $ssl = 1)
    Local $objEmail = ObjCreate("CDO.Message")
    $objEmail.From = '"' & $s_FromName & '" <' & $s_FromAddress & '>'
    $objEmail.To = $s_ToAddress
    Local $i_Error = 0
    Local $i_Error_desciption = ""
    If $s_CcAddress <> "" Then $objEmail.Cc = $s_CcAddress
    If $s_BccAddress <> "" Then $objEmail.Bcc = $s_BccAddress
    $objEmail.Subject = $s_Subject
    If StringInStr($as_Body, "<") And StringInStr($as_Body, ">") Then
        $objEmail.HTMLBody = $as_Body
    Else
        $objEmail.Textbody = $as_Body & @CRLF
    EndIf
    If $s_AttachFiles <> "" Then
        Local $S_Files2Attach = StringSplit($s_AttachFiles, ";")
        For $x = 1 To $S_Files2Attach[0]
            $S_Files2Attach[$x] = _PathFull($S_Files2Attach[$x])
;~          ConsoleWrite('@@ Debug : $S_Files2Attach[$x] = ' & $S_Files2Attach[$x] & @LF & '>Error code: ' & @error & @LF) ;### Debug Console
            If FileExists($S_Files2Attach[$x]) Then
                ConsoleWrite('+> File attachment added: ' & $S_Files2Attach[$x] & @LF)
                $objEmail.AddAttachment($S_Files2Attach[$x])
            Else
                ConsoleWrite('!> File not found to attach: ' & $S_Files2Attach[$x] & @LF)
                SetError(1)
                Return 0
            EndIf
        Next
    EndIf
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
    If Number($IPPort) = 0 then $IPPort = 25
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort
    ;Authenticated SMTP
    If $s_Username <> "" Then
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
    EndIf
    If $ssl Then
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
    EndIf
    ;Update settings
    $objEmail.Configuration.Fields.Update
    ; Set Email Importance
    Switch $s_Importance
        Case "High"
            $objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "High"
        Case "Normal"
            $objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "Normal"
        Case "Low"
            $objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "Low"
    EndSwitch
    $objEmail.Fields.Update
    ; Sent the Message
    $objEmail.Send
    If @error Then
        SetError(2)
        Return $oMyRet[1]
    EndIf
    $objEmail=""
EndFunc   ;==>_INetSmtpMailCom
;
;
; Com Error Handler
Func MyErrFunc()
    $HexNumber = Hex($oMyError.number, 8)
    $oMyRet[0] = $HexNumber
    $oMyRet[1] = StringStripWS($oMyError.description, 3)
    ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $oMyError.scriptline & "   Description:" & $oMyRet[1] & @LF)
    SetError(1); something to check for when this function returns
    Return
EndFunc   ;==>MyErrFunc