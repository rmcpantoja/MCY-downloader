#include-once
;this file has been modified to use sapi instead of audio files for use in games that ;require sapi in its entirety.
#include "sapi.au3"
Func create_sapi_menu($description, $options)
	If $description = "" Then Return 0
	If $options = "" Then Return 0
	$selection = 0
	$items = StringSplit($options, ",")
	If @error Then Return 0
	$menu_length = $items[0]
	speak($description, 3)
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
			speak($file_to_open, 3)

		EndIf
		If $menu_key = "down arrow" Then
			$selection = $selection + 1
			$limit = $menu_length + 1
			If $selection = $limit Then
				$selection = 1
			EndIf
			$file_to_open = $items[$selection]
			speak($file_to_open, 3)
		EndIf
		Sleep(10)
	WEnd
EndFunc   ;==>create_sapi_menu
