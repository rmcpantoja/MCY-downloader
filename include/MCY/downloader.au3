#include "ButtonConstants.au3"
#include "config.au3"
#include "globals.au3"
#include "GuiButton.au3"
#include "GuiComboBox.au3"
#include "../Progress.au3"
#include "TrayConstants.au3"

; #FUNCTION# ====================================================================================================================
; Name ..........: Imputdownload
; Description ...: the main function of the program
; Syntax ........: Imputdownload()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Imputdownload()
	$dmain = GUICreate(translate($sLang, "MCY Downloader: Download multimedia"), 500, 500)
	$ReadAccs = IniRead($sConfigPath, "Accessibility", "Enable enanced accessibility", "")
	$showtip = IniRead($sConfigPath, "misc", "Show tips", "")
	$sayProgresses = IniRead($sConfigPath, "Accessibility", "Read download progress bar", "")
	$sayTime = IniRead($sConfigPath, "Accessibility", "Read download remaining time", "")
	$BeepProgresses = IniRead($sConfigPath, "Accessibility", "Beep for progress bars", "")
	Select
		Case $sayProgresses = ""
			IniWrite($sConfigPath, "Accessibility", "Read download progress bar", "Yes")
	EndSelect
	Select
		Case $sayTime = ""
			IniWrite($sConfigPath, "Accessibility", "Read download remaining time", "No")
	EndSelect
	Select
		Case $BeepProgresses = ""
			IniWrite($sConfigPath, "Accessibility", "Beep for progress bars", "Yes")
	EndSelect
	If @OSArch = "x64" Then
		Global $MAIN = " engines64\yt-dlp "
		Global $ffmpeg = " engines64\ffmpeg.exe"
		Global $MSVCR100_PATH = "engines64\msvcr100.dll"
		Global $CMD_VIDEO = 'engines64\yt-dlp.exe -o "'
	EndIf
	If @OSArch = "x86" Then
		Global $MAIN = " engines\yt-dlp_x86 "
		Global $ffmpeg = " engines\ffmpeg.exe"
		Global $MSVCR100_PATH = "engines\msvcr100.dll"
		Global $CMD_VIDEO = 'engines\yt-dlp.exe -o "'
	EndIf
	Global $EN_INTERRUPT_MESSAGE = "~ interrupt!"
	Global $EN_MISSING_URL_MESSAGE = "Missing URL!"
	Global $EXTRACT_AUDIO = " --extract-audio "
	Global $AUDIO_FORMAT = " --audio-format "
	Global $audioQual = IniRead($sConfigPath, "accessibility", "Audio Quality", "")
	If $audioQual = "128k" Or $audioQual = "160k" Or $audioQual = "192k" Or $audioQual = "224k" Or $audioQual = "256k" Or $audioQual = "320k" Or $audioQual = "384k" Then
		Global $audioQuality = " --audio-quality " & $audioQual & " "
	Else
		Global $audioQuality = " --audio-quality 320k "
	EndIf
	Global $OUTPUT = " --output "
	Global $OUTPUT_TEMPLATE = "%%(title)s.%%(ext)s"
	Global $YES_PLAYLIST = " --yes-playlist "
	Global $NO_PLAYLIST = " --no-playlist "
	Global $PLAYLIST_START = " --playlist-start "
	Global $PLAYLIST_END = " --playlist-end "
	Global $PLAYLIST_Ignore_errors = ""
	Global $WRITE_SUB = " --write-sub "
	Global $WRITE_AUTO_SUB = " --write-auto-sub "
	Global $SUB_FORMAT = " --sub-format "
	Global $SUB_LANG = " --sub-lang "
	Global $SKIP_VIDEO = " --skip-download "
	Global $NOP_MILLIS = 10000
	Global $EMPTY_STRING = ""
	Global $SPACE = " "
	Global $DOWNLOAD_TAG = "[download]"
	Global $iPID = -1
	Local $count = 0
	$idLabel1 = GUICtrlCreateLabel(translate($sLang, "Enter a &URL, Insert here the link, playlist or channel of the video to download:"), 10, 10, 200, 20)
	Local $sData = ClipGet()
	$input_url = GUICtrlCreateInput($sData, 18, 30, 497, 20)
	$chkbox_isSingle = GUICtrlCreateCheckbox(translate($sLang, "Download only &video"), 8, 80, 145, 17)
	If $showtip = "1" Then GUICtrlSetTip(-1, translate($sLang, "Check only this checkbox to download the original video, in case of YouTube."))
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkbox_isMP3 = GUICtrlCreateCheckbox(translate($sLang, "Download as &audio"), 8, 104, 145, 17)
	If $showtip = "1" Then GUICtrlSetTip(-1, translate($sLang, "Check this checkbox to convert this downloaded video to an audio format like mp3."))
	$chkbox_sub = GUICtrlCreateCheckbox(translate($sLang, "Download &subtittles"), 8, 190, 145, 17)
	If $showtip = "1" Then GUICtrlSetTip(-1, translate($sLang, "You can download subtitles, if the video supports them."))
	$idFolder = GUICtrlCreateLabel(Translate($sLang, "Destination folder"), 8, 240, 150, 17)
	$input_dir = GUICtrlCreateInput($sDest_folder, 8, 250, 190, 17)
	$btn_dir = GUICtrlCreateButton(translate($sLang, "Choose &Folder"), 8, 270, 190, 17)
	If $showtip = "1" Then GUICtrlSetTip(-1, translate($sLang, "The download folder where your files will be saved."))
	$btn_generate = GUICtrlCreateButton(translate($sLang, "&Download"), 8, 280, 145, 17)
	If $showtip = "1" Then GUICtrlSetTip(-1, translate($sLang, "Starts download of the selected link"))
	$btn_share = GUICtrlCreateButton(translate($sLang, "&Share link"), 8, 320, 145, 17)
	If $showtip = "1" Then GUICtrlSetTip(-1, translate($sLang, "Share URLs through social networks."))
	$btn_prev = GUICtrlCreateButton(translate($sLang, "&Preview"), 8, 380, 145, 17)
	If $showtip = "1" Then GUICtrlSetTip(-1, translate($sLang, "Plays a preview of the selected link."))
	$idLabel1 = GUICtrlCreateLabel(translate($sLang, "Download video from:"), 100, 100, 200, 21)
	$input_start = GUICtrlCreateInput("", 160, 80, 41, 21)
	GUICtrlSetState(-1, $GUI_HIDE)
	$idLabel1 = GUICtrlCreateLabel(translate($sLang, "Download to:"), 130, 115, 200, 21)
	$input_end = GUICtrlCreateInput("", 224, 80, 41, 21)
	GUICtrlSetState(-1, $GUI_HIDE)
	$Label1 = GUICtrlCreateLabel(translate($sLang, "Select subtitle download method:"), 208, 83, 16, 17)
	GUICtrlSetState(-1, $GUI_HIDE)
	$combo_sublist = GUICtrlCreateCombo("Auto sub", 160, 152, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetState(-1, $GUI_HIDE)
	$chkbox_onlysub = GUICtrlCreateCheckbox(translate($sLang, "Only down sub"), 312, 152, 97, 17)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUISetState(@SW_SHOW)
	Global $isSingle = False
	Global $url
	Global $dir
	Global $sublang
	Local $DOWNLOADLINE = $EMPTY_STRING
	While 1
		$url = GUICtrlRead($input_url)
		$sublang = GUICtrlRead($combo_sublist)
		;check if the input url is a playlist url
		If Not (StringInStr($url, "list")) And GUICtrlRead($chkbox_isSingle) == $GUI_UNCHECKED Then
			GUICtrlSetState($chkbox_isSingle, $GUI_CHECKED)
			Select
				Case $ReadAccs = "yes"
					speaking(translate($sLang, "The link was marked as a playlist."))
				Case $ReadAccs = "no"
					ToolTip(translate($sLang, "The link was marked as a playlist."))
					ToolTip("")
			EndSelect
		EndIf
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Menuprogram()
			Case $btn_dir
				Local $path = FileSelectFolder(translate($sLang, "Choose Folder..."), $input_dir)
				GUICtrlSetData($input_dir, $path)
				_CustomLog("Folder selected: " & $path)
				$sDest_folder = $path
				IniWrite($sConfigPath, "General settings", "Destination folder", $sDest_folder)
				_create_folders($sDest_folder)
			Case $btn_generate
				$sound_downloading = $device.opensound("sounds/update_downloading.ogg", 0)
				$sound_downloading.play
				MsgBox(0, translate($sLang, "Downloading"), translate($sLang, "Wait a moment, we're looking for the video. Press OK to start."))
				$say = "0"
				_CustomLog("Downloading Multimedia.")
				Local $command = $MAIN
				Local $isSingle = GUICtrlRead($chkbox_isSingle) == $GUI_CHECKED
				Local $start = Number(GUICtrlRead($input_start))
				Local $end = Number(GUICtrlRead($input_end))
				Local $isMP3 = GUICtrlRead($chkbox_isMP3) == $GUI_CHECKED
				Local $isSub = GUICtrlRead($chkbox_sub) == $GUI_CHECKED
				Local $isOnlySub = GUICtrlRead($chkbox_onlysub) == $GUI_CHECKED
				Local $dir = GUICtrlRead($input_dir)
				;Local $isExec = GUICtrlRead($chkbox_exec) == $GUI_CHECKED
				$exitcmd = @CRLF & "exit"
				If $isMP3 Then
					_CustomLog("Downloading as audio")
					$command &= $EXTRACT_AUDIO & $AUDIO_FORMAT & "mp3" & $audioQuality
				EndIf
				If $isSub Then
					If $sublang <> "Auto sub" Then
						_CustomLog("Downloading subtitles ...")
						$command &= $WRITE_SUB & $SUB_LANG & $sublang
					Else
						_CustomLog("Autosub")
						$command &= $WRITE_AUTO_SUB
					EndIf
					If $isOnlySub Then
						$command &= $SKIP_VIDEO
					EndIf
				EndIf
				If $isSingle Then
					$command &= $NO_PLAYLIST
				Else
					$command &= $YES_PLAYLIST & $PLAYLIST_Ignore_errors
					If $start <> 0 Then $command &= $PLAYLIST_START & $start
					If $end <> 0 Then $command &= $PLAYLIST_END & $end
				EndIf
				If $dir <> "" Then
					$command &= $OUTPUT & '"' & $dir & '\audio\' & $OUTPUT_TEMPLATE & '" '
				EndIf
				$command &= ' "' & GUICtrlRead($input_url) & '"'
				$command &= (@CRLF & $exitcmd)
				Local $file = FileOpen("generated.bat", $FO_OVERWRITE + $FO_CREATEPATH)
				FileWrite($file, $command)
				FileClose($file)
				GUISetState(@SW_HIDE, $dmain)
				Global $downloading = GUICreate(translate($sLang, "Downloading"))
				$edit_out = GUICtrlCreateEdit($EMPTY_STRING, 8, 152, 325, 17, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY))
				Local $idProgressbar = GUICtrlCreateProgress(200, 50, 325, 17)
				GUICtrlSetColor(-1, 32250)
				GUISetState(@SW_SHOW)
				_CustomLog("Starting process...")
				Local $iSavPos = 0
				Local $runcmd = Run(@ComSpec & " /C" & "generated.bat", @ScriptDir, @SW_HIDE, 6)
				GUICtrlSetData($edit_out, $EMPTY_STRING)
				_CustomLog("downloading " & GUICtrlRead($input_url))
				ProgressOn(translate($sLang, "Downloading"), translate($sLang, "Please wait."), "0%", 100, 20)
				Local $DOWNLOADLINE
				While 1
					Switch GUIGetMsg()
						Case $GUI_EVENT_CLOSE
							If BitAND(WinGetState($downloading), $WIN_STATE_ACTIVE) Then
								If ProcessExists("yt-dlp.exe") Or ProcessExists("yt-dlp_x86.exe") <> 0 Then
									Dim $iMsgBoxAnswer
									$iMsgBoxAnswer = MsgBox(5244324, translate($sLang, "question"), translate($sLang, "Your download has not finished yet. Are you sure you really want to get out of here?"))
									Select
										Case $iMsgBoxAnswer = 6
											ProcessClose($DOWNLOADLINE)
											GUICtrlSetData($edit_out, $EN_INTERRUPT_MESSAGE)
											Sleep(25)
											menuprogram()
										Case $iMsgBoxAnswer = 7
									EndSelect
								EndIf
							EndIf
					EndSwitch
					Local $randomwait = Random(3000, 10000, 1)
					Local $DOWNLOADLINE = StdoutRead($runcmd)
					If @error Then ExitLoop
					If $DOWNLOADLINE <> $EMPTY_STRING Then
						If StringInStr($DOWNLOADLINE, $DOWNLOAD_TAG) > 1 Then
							GUICtrlSetData($edit_out, $DOWNLOADLINE)
							$split1 = StringRight($DOWNLOADLINE, 5)
							$split2 = StringLeft($DOWNLOADLINE, 18)
							$split3 = Int(StringRight($split2, 6))
							$split4 = StringRight($split2, 3)
							$iSavPos = $split3
							GUICtrlSetData($idProgressbar, $split3)
							Select
								Case $ReadAccs = "yes"
									If $sayProgresses = "yes" Then
										Speaking($split3)
									EndIf
									If $BeepProgresses = "yes" Then
										CreateAudioProgress($split3)
									EndIf
									If $sayTime = "yes" Then
										Speaking(translate($sLang, "Estimated time remaining:") & $split1)
									EndIf
							EndSelect
							_CustomLog($DOWNLOADLINE)
						Else
							GUICtrlSetData($edit_out, GUICtrlRead($edit_out) & $DOWNLOADLINE)
						EndIf
					EndIf
					$DOWNLOADLINE = StderrRead($runcmd)
					If @error Then ExitLoop
					If $DOWNLOADLINE <> $EMPTY_STRING Then GUICtrlSetData($edit_out, GUICtrlRead($edit_out) & $DOWNLOADLINE)
				WEnd
				ProgressOff()
				$downloaded = $device.opensound("sounds/downloaded.ogg", 0)
				$downloaded.play
				Sleep(100)
				FileDelete("generated.bat")
				TrayTip(translate($sLang, "Download complete"), translate($sLang, "Your link") & $url & translate($sLang, "Has been processed and uploaded correctly!"), 0, $TIP_ICONASTERISK)
				$Dialog_Complete = MsgBox(4, translate($sLang, "Download complete"), translate($sLang, "Do you want to open the download folder currently in use?"))
				If $Dialog_Complete = 6 Then
					ShellExecute($sDest_folder)
					If @error Then
						MsgBox(16, translate($sLang, "Error"), translate($sLang, 'Unable to open folder') & '"' & $sDest_folder & '".' & @CRLF & @CRLF & @extended)
						_CustomLog("Unable to open folder " & $sDest_folder & '".' & @CRLF & @CRLF & @extended)
					Else
						_CustomLog("video Downloaded. Open Folder=yes. Opening: " & $sDest_folder)
					EndIf
				Else
					_CustomLog("video Downloaded. Open Folder=no")
				EndIf
				GUIDelete($downloading)
				GUISetState(@SW_SHOW, $dmain)
			Case $btn_share
				Global $URLData = $url
				If StringInStr($URLData, "http") Then
					shareLink()
				Else
					MsgBox(16, translate($sLang, "Error"), translate($sLang, 'The link entered in the edit box is not correct. Please put a link in the edit box "enter a URL" and try again.'))
				EndIf
			Case $btn_prev
				;Escuchavistaprevia()
			Case $chkbox_isSingle
				If BitAND(GUICtrlRead($chkbox_isSingle), $BN_CLICKED) = $BN_CLICKED Then
					If _GUICtrlButton_GetCheck($chkbox_isSingle) Then
						Select
							Case $ReadAccs = "yes"
								speaking(translate($sLang, "The link was marked as video."))
							Case $ReadAccs = "no"
								ToolTip(translate($sLang, "The link was marked as video."))
								ToolTip("")
						EndSelect
						GUICtrlSetData($chkbox_isSingle, translate($sLang, "Download &video"))
						GUICtrlSetState($input_start, $GUI_HIDE)
						GUICtrlSetState($input_end, $GUI_HIDE)
						GUICtrlSetState($Label1, $GUI_HIDE)
					Else
						Select
							Case $ReadAccs = "yes"
								speaking(translate($sLang, "link was marked as playlist."))
							Case $ReadAccs = "no"
								ToolTip(translate($sLang, "link was marked as playlist"))
						EndSelect
						ToolTip("")
						GUICtrlSetData($chkbox_isSingle, "Download &playlist")
						GUICtrlSetState($input_start, $GUI_SHOW)
						GUICtrlSetState($input_end, $GUI_SHOW)
						GUICtrlSetState($Label1, $GUI_SHOW)
					EndIf
				EndIf

			Case $chkbox_sub
				If BitAND(GUICtrlRead($chkbox_sub), $BN_CLICKED) = $BN_CLICKED Then
					If _GUICtrlButton_GetCheck($chkbox_sub) Then
						If (StringLen($url) > 0) Then
							_GUICtrlComboBox_InsertString($combo_sublist, GetSubLang($url), 0)
							;MsgBox(0,"",GUICtrlRead($combo_sublist))
						EndIf
						GUICtrlSetState($combo_sublist, $GUI_SHOW)
						GUICtrlSetState($chkbox_onlysub, $GUI_SHOW)
					Else
						ConsoleWrite("Checkbox unchecked... " & @CRLF)
						_GUICtrlComboBox_ResetContent($combo_sublist)
						_GUICtrlComboBox_AddString($combo_sublist, "Auto sub")
						GUICtrlSetState($combo_sublist, $GUI_HIDE)
						GUICtrlSetState($chkbox_onlysub, $GUI_HIDE)
					EndIf
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>Imputdownload
; #FUNCTION# ====================================================================================================================
; Name ..........: GetSubLang
; Description ...: Get subtitles of the URL
; Syntax ........: GetSubLang($url)
; Parameters ....: $url                 - An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func GetSubLang($url)
	Local $a_sublist
	Local $command = $MAIN & " --list-subs " & $url
	Local $cmdline = Run(@ComSpec & " /C " & $command, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	If @error Then
		MsgBox(16, translate($sLang, "Error"), translate($sLang, "The operation cannot be performed because the Yt-dlp.exe file cannot be found."))
	EndIf
	ProcessWaitClose($cmdline)
	Local $return = StdoutRead($cmdline)
	$a_sublist = StringSplit($return, @LF)
	Return StringLeft($a_sublist[UBound($a_sublist) - 2], 2)
EndFunc   ;==>GetSubLang
; #FUNCTION# ====================================================================================================================
; Name ..........: shareLink
; Description ...: Share multimedia link
; Syntax ........: shareLink()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func shareLink()
	$ReadAccs = IniRead($sConfigPath, "Accessibility", "Enable enanced accessibility", "")
	$Rpositioning = IniRead($sConfigPath, "Accessibility", "Announce position", "")
	$shareGui = GUICreate(translate($sLang, "Share with..."))
	GUISetState(@SW_SHOW)
	Select
		Case $ReadAccs = "yes"
			$shareMenu = Reader_Create_Menu(translate($sLang, "Share with..."), "Whatsapp|Facebook|Skype|" & translate($sLang, "Back"), $Rpositioning, translate($sLang, "Of"))
			Select
				Case $shareMenu = 1
					ShellExecute("https://api.whatsapp.com/send?text= " & translate($sLang, "I share this link with you: This link has been shared through MCY Downloader. Link:") & @CRLF & $URLData)
					If @error Then MsgBox(16, translate($sLang, "Error"), translate($sLang, "Cannot run browser. It is likely that you have to add an association."))
					GUIDelete($shareGui)
				Case $shareMenu = 2
					ShellExecute("https://www.facebook.com/sharer.php?u=" & $URLData & "&t=" & translate($sLang, "I share this link with you: This link has been shared through MCY Downloader. Link: ") & @CRLF & $URLData & @CRLF & translate($sLang, "Shared Link via MCY Downloader"))
					If @error Then MsgBox(16, translate($sLang, "Error"), translate($sLang, "Cannot run browser. It is likely that you have to add an association."))
					GUIDelete($shareGui)
				Case $shareMenu = 3
					ShellExecute("https://web.skype.com/share?url=" & $URLData & "&lang=en-US=&source=jetpack")
					If @error Then MsgBox(16, translate($sLang, "Error"), translate($sLang, "Cannot run browser. It is likely that you have to add an association."))
					GUIDelete($shareGui)
				Case $shareMenu = 4
					GUIDelete($shareGui)
			EndSelect
		Case $ReadAccs = "No"
			$idWhatsapp = GUICtrlCreateButton(translate($sLang, "Share on") & " WhatsApp", 90, 50, 70, 25)
			$idFacebook = GUICtrlCreateButton(translate($sLang, "Share on") & "Facebook", 130, 50, 70, 25)
			$idSkype = GUICtrlCreateButton(translate($sLang, "Share on") & "Skype", 180, 50, 70, 25)
			$idBack = GUICtrlCreateButton(translate($sLang, "Back"), 250, 50, 70, 25)
			; Loop until the user exits.
			While 1
				$idMsg = GUIGetMsg()
				Switch $idMsg
					Case $GUI_EVENT_CLOSE, $idBack
						GUIDelete($shareGui)
						;GUISetState(@SW_SHOW, $dmain)
						ExitLoop
					Case $idWhatsapp
						ShellExecute("https://api.whatsapp.com/send?text= " & translate($sLang, "I share this link with you: This link has been shared through MCY Downloader. Link:") & @CRLF & $URLData)
						If @error Then MsgBox(16, translate($sLang, "Error"), translate($sLang, "Cannot run browser. It is likely that you have to add an association."))
						GUIDelete($shareGui)
						ExitLoop
					Case $idFacebook
						ShellExecute("https://www.facebook.com/sharer.php?u=" & $URLData & "&t=" & translate($sLang, "I share this link with you: This link has been shared through MCY Downloader. Link: ") & @CRLF & $URLData & @CRLF & translate($sLang, "Shared Link via MCY Downloader"))
						If @error Then MsgBox(16, translate($sLang, "Error"), translate($sLang, "Cannot run browser. It is likely that you have to add an association."))
						GUIDelete($shareGui)
						ExitLoop
					Case $idSkype
						ShellExecute("https://web.skype.com/share?url=" & $URLData & "&lang=en-US=&source=jetpack")
						If @error Then MsgBox(16, translate($sLang, "Error"), translate($sLang, "Cannot run browser. It is likely that you have to add an association."))
						GUIDelete($shareGui)
						ExitLoop
				EndSwitch
			WEnd
	EndSelect
EndFunc   ;==>shareLink