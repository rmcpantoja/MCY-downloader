#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=../compiled/MCY.exe
;#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Description=Music YouTube Downloader
#AutoIt3Wrapper_Res_Comment=This is a software that allows you to download multimedia content, as well as enjoy your favorite music by listening to our radios or plcing your prefferences.
#AutoIt3Wrapper_Res_Fileversion=1.0.0.29
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_ProductName=Music YouTube Downloader
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.0
#AutoIt3Wrapper_Res_CompanyName=MT Programs
#AutoIt3Wrapper_Res_LegalCopyright=© 2018-2025 MT Programs, All rights reserved
#AutoIt3Wrapper_Run_Before="build.bat"
;#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;Including program scripts:
#include "include\audio.au3"
#include "include\MCY\config.au3"
#include "Include\MCY\globals.au3"
OnAutoItExitRegister("_exitpersonaliced")
#include "misc.au3"
#include "include\MCY\UI.au3"

; Start program:

AutoItWinSetTitle($sProgramname & " by Mateo C")
_Singleton('MCYDownloader')
$welcome = $device.opensound("sounds/open.ogg", 0)
$welcome.play
_config_start($sConfigFolder, $sConfigPath)
Menuprogram()