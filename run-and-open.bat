@echo off
REM Start servers in a new window and open the app in browser
cd /d "%~dp0"
REM Start servers in a new cmd window so this script can continue
start "QuickShow Dev" cmd /k "cd /d "%~dp0" && npm.cmd run install-all && npm.cmd run dev"
REM Give servers a moment to boot, then open the browser
timeout /t 3 /nobreak >nul
start "" "http://localhost:5173/"
