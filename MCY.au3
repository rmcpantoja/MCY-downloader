#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=N
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Change2CUI=N
#AutoIt3Wrapper_Res_Description=Music YouTube Downloader
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
;#AutoIt3Wrapper_Res_Fileversion_First_Increment=y
#AutoIt3Wrapper_Res_ProductName=Music YouTube Downloader
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.0
#AutoIt3Wrapper_Res_CompanyName=MT Programs
#AutoIt3Wrapper_Res_LegalCopyright=© 2018-2022 MT Programs, All rights reserved
;#AutoIt3Wrapper_Res_Language=12298
;#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7 -v1 -v2 -v3
;#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;Begining off script.
;AutoIt3Wrapper
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#Autoit3Wrapper_Testing=n
#AutoIt3Wrapper_ShowProgress=y
#AutoIt3Wrapper_ShowGui=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;pragma:
; #pragma compile(Icon, C:\Program Files\AutoIt3\Icons\au3.ico)
#pragma compile(UPX, False)
;#pragma compile(Compression, 2)
#pragma compile(inputboxres, false)
#pragma compile(FileDescription, Music YouTube Downloader)
#pragma compile(ProductName, Music YouTube Downloader)
#pragma compile(ProductVersion, 1.0.0.0)
#pragma compile(Fileversion, 1.0.0.19)
#pragma compile(InternalName, "mateocedillo.MCY")
#pragma compile(LegalCopyright, © 2018-2022 MT Programs, All rights reserved)
#pragma compile(CompanyName, 'MT Programs')
;Including program scripts:
;#include <Array.au3>;para un futuro
#include "Include\audio.au3"
#include "include\MCY\busqueda.au3"
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <fileConstants.au3>
#include "Include\MCY\functions.au3"
#include "Include\MCY\globals.au3"
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <GuiComboBox.au3>
#include <InetConstants.au3> ;
;#include "Include\mergefiles_utf16le_v2.au3"
#include "Include\MCY\Mp3_converter.au3"
#include "Include\kbc.au3"
#include "include/MCY/language_manager.au3"
#include "Include\log.au3"
#include "Include\menu_nvda.au3"
#include <MsgBoxConstants.au3>
#include "Include\NVDAControllerClient.au3"
#include "Include\MCY\player.au3"
#include "include\progress.au3"
#include <ProgressConstants.au3>
#include "Include\MCY\radio.au3"
#include "Include\reader.au3"
#include "Include\sapi.au3"
#include "Include\say_UDF.au3"
;#include <String.au3>;for a future
#include "include\translator.au3"
#include <TrayConstants.au3>
#include "include\MCY\UI.au3"
#include "updater.au3"
#include <WindowsConstants.au3>
; #FUNCTION# ====================================================================================================================
; Name ..........: Principal
; Description ...: this is... the main core of the program.
; Syntax ........: Principal()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Principal()
	If @Compiled Then FileDelete(@TempDir & "\MCYWeb.dat")
	Opt("GUIOnEventMode", 0)
	$lng = IniRead($sConfigPath, "General settings", "language", "")
	;Show the window.
	AutoItWinSetTitle($programname & " by Mateo C")
	;Play welcome sound.
	$welcome = $device.opensound("sounds/open.ogg", 0)
	$welcome.play
	;Check multimedia folders.
	writeinlog("Checking multimedia folders:")
	Global $d_folder = IniRead($sConfigPath, "General settings", "Destination folder", "")
	Select
		Case $d_folder = ""
			$d_folder = "C:\MCY\Download"
			IniWrite($sConfigPath, "General settings", "Destination folder", $d_folder)
	EndSelect
	Menuprogram()
EndFunc   ;==>Principal
; #FUNCTION# ====================================================================================================================
; Name ..........: multimediafolders
; Description ...: Create multimedia folders.
; Syntax ........: multimediafolders()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func multimediafolders()
	If Not FileExists($d_folder & "\audio") Then DirCreate($d_folder & "\audio")
	If Not FileExists($d_folder & "\video") Then DirCreate($d_folder & "\video")
EndFunc   ;==>multimediafolders
; #FUNCTION# ====================================================================================================================
; Name ..........: Readchanges
; Description ...: Read changes document
; Syntax ........: Readchanges()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Readchanges()
	$viewchanges = GUICreate(translate($lng, "Changes:"))
	GUISetState(@SW_SHOW)
	Sleep(50)
	createTtsDocument(@ScriptDir & "\Documentation\" & $lng & "\changes.txt", "changes")
	GUIDelete($viewchanges)
EndFunc   ;==>Readchanges