@echo off
REM One-click launcher for development (Windows)
cd /d "%~dp0"
REM Install dependencies for server and client if missing (first run)
npm run install-all
REM Start server and client concurrently
npm run dev
pause
