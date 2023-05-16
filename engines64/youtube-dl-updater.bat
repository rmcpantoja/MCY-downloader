
@echo off
echo Waiting for file handle to be closed ...
ping 127.0.0.1 -n 5 -w 1000 > NUL
move /Y "C:\Users\angel\Documents\My Swite\programs\MCY downloader0.9\Comp\engines64\youtube-dl-.exe.new" "C:\Users\angel\Documents\My Swite\programs\MCY downloader0.9\Comp\engines64\youtube-dl-.exe" > NUL
echo Updated youtube-dl to version 2021.06.06.
start /b "" cmd /c del "%~f0"&exit /b"
                
