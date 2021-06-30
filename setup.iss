; Installer script for MCY Downloader, program to download multimedia from YouTube.
; Created by Mateo Cedillo (from MT programs)
;Defining variables and attributes of the application.
#define MyAppName "MCY Downloader"
#define MyAppVersion "0.9 beta"
#define MyAppPublisher "Mt Programs"
#define MyAppURL "http://mateocedillo.260mb.net"
#define MyAppExeName "MCY.exe"
;Adding and configuring the installer and its settings.
[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{C27B6F0C-B672-4C2D-BE2E-BE3B8F399B88}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersixon}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName=C:\MCY
DefaultGroupName={#MyAppName}
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=C:\Users\angel\Documents\My Swite\Programs\MCY downloader0.9\Source code
OutputBaseFilename=MCY_setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
UserInfoPage=yes
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
;Name: quicklaunchicon; Description: "Create a &Quick Launch icon"; GroupDescription: "Additional icons:"; Components: main; Flags: unchecked

[Files]
Source: "C:\Users\angel\Documents\My Swite\Programs\MCY downloader0.9\Comp\MCY.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\angel\Documents\My Swite\Programs\MCY downloader0.9\Comp\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

