#include "KEYINPUT.AU3"
#include-once
; This file contains a function to generate a custom audio menu. It uses functions from the ; audio and key libraries, so those need to be initialized first before this function can ; be used.

Func create_audio_menu($description, $options)
	If $description = "" Then Return 0
	If $options = "" Then Return 0
	$selection = 0
	$items = StringSplit($options, ",")
	If @error Then Return 0
	$menu_length = $items[0]
	$menu = $device.OpenSound($description, True)
	$menu.Play()
	While 1
		$active_window = WinGetProcess("")
		If $active_window = @AutoItPID Then
		Else
			Sleep(10)
			ContinueLoop
		EndIf
		$menu_key = ""
		$capt = check_key("26", 2)
		If $capt = 1 Then
			$menu_key = "up arrow"
		EndIf
		$capt = check_key("28", 3)
		If $capt = 1 Then
			$menu_key = "down arrow"
		EndIf
		$capt = check_key("0D", 5)
		If $capt = 1 Then
			$menu_key = "enter"
		EndIf
		If $menu_key = "" Then
			Sleep(10)
			ContinueLoop
		EndIf
		If $menu_key = "enter" Then
			If $selection > 0 Then
				$menu = ""
				Return $selection
			EndIf
		EndIf
		If $menu_key = "up arrow" Then
			$selection = $selection - 1
			If $selection < 1 Then
				$selection = $menu_length
			EndIf
			$file_to_open = $items[$selection]
			$menu = $device.OpenSound($file_to_open, True)
			$scroll = $device.opensound("sounds/soundsdata.dat/scroll.ogg", 0)
			$scroll.play()
			$menu.Play()
		EndIf
		If $menu_key = "down arrow" Then
			$selection = $selection + 1
			$limit = $menu_length + 1
			If $selection = $limit Then
				$selection = 1
			EndIf
			$file_to_open = $items[$selection]
			$menu = $device.OpenSound($file_to_open, True)
			$scroll = $device.opensound("sounds\soundsdata.dat\scroll.ogg", 0)
			$scroll.play()
			$menu.Play()
		EndIf
		Sleep(10)
	WEnd
EndFunc   ;==>create_audio_menu
