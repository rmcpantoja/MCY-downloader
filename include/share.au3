;This is a small UDF that will allow us to share something to different social networks.
;Note: This works only if the OnEventMode is enabled and if a GUI is in progress with a while loop.
;Author: Mateo Cedillo.
#include <GuiConstantsEx.au3>
#include "translator.au3"
#include-once
Local $sTextToSend = "", $sUrlToShare = ""
Local $CloseDialog = 0
Func share($textToSend, $UrlToShare, $sLang)
	$shmessage = translate($sLang, "Share on") & " "
	Global $shareGui = GUICreate(translate($sLang, "Share with..."))
	$iOldOpt = Opt("GUIOnEventMode", 1)
	Global $idWhatsapp = GUICtrlCreateButton($shmessage & "WhatsApp", 50, 50, 50, 25)
	GUICtrlSetOnEvent(-1, "ShareHanddler")
	Global $idFacebook = GUICtrlCreateButton($shmessage & "Facebook", 120, 50, 50, 25)
	GUICtrlSetOnEvent(-1, "ShareHanddler")
	Global $idSkype = GUICtrlCreateButton($shmessage & "Skype", 155, 50, 50, 25)
	GUICtrlSetOnEvent(-1, "ShareHanddler")
	Global $idBack = GUICtrlCreateButton(translate($sLang, "Back"), 200, 50, 70, 25)
	GUICtrlSetOnEvent(-1, "ShareHanddler")
	GUISetState(@SW_SHOW)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseShDialog")
	While 1
		If $CloseDialog = 1 Then
			CloseShDialog()
			Opt("GUIOnEventMode", $iOldOpt)
			ExitLoop
		EndIf
		Sleep(1)
	WEnd
EndFunc   ;==>share
Func ShareHanddler()
	Select
		Case @GUI_CtrlId = $idWhatsapp
			ShellExecute("https://api.whatsapp.com/send?text= " & $sTextToSend & @CRLF & $sUrlToShare)
			If @error Then
				Return 0
			EndIf
		Case @GUI_CtrlId = $idFacebook
			ShellExecute("https://www.facebook.com/sharer.php?u=" & $sUrlToShare & "&t=" & $sTextToSend)
			If @error Then
				Return 0
			EndIf
		Case @GUI_CtrlId = $idSkype
			ShellExecute("https://web.skype.com/share?url=" & $sUrlToShare & "&lang=en-US=&source=jetpack")
			If @error Then
				Return 0
			EndIf
			;Case @GUI_CtrlId = $idBack
			;CloseShDialog()
	EndSelect
	$CloseDialog = 1
EndFunc   ;==>ShareHanddler
Func CloseShDialog()
	GUIDelete($shareGui)
	$CloseDialog = 0
EndFunc   ;==>CloseShDialog
