@echo off
title Launching Q-NEXUS Platform
echo ========================================================
echo               Q-NEXUS PLATFORM LAUNCHER
echo ========================================================
echo.

:: Check if port 5173 is open (Vite Dev Server)
netstat -ano | findstr /R ":5173.*LISTENING" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Vite Dev Server detected on port 5173. Opening dev environment...
    start msedge "http://127.0.0.1:5173" 2>nul || start "" "http://127.0.0.1:5173"
    echo Opened http://127.0.0.1:5173
    exit /b 0
)

:: Check if port 8000 is open (Unified Backend + Static SPA)
netstat -ano | findstr /R ":8000.*LISTENING" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Q-NEXUS Backend and Web UI detected on port 8000. Opening platform...
    start msedge "http://127.0.0.1:8000" 2>nul || start "" "http://127.0.0.1:8000"
    echo Opened http://127.0.0.1:8000
    exit /b 0
)

echo [!] Neither Port 5173 nor Port 8000 is currently active.
echo Starting Q-NEXUS Backend server (serving UI + API)...
cd /d "%~dp0backend"
start "Q-NEXUS Backend" cmd /k "python -m uvicorn app.main:app --host 0.0.0.0 --port 8000"

echo Waiting for server initialization...
timeout /t 4 /nobreak >nul
start msedge "http://127.0.0.1:8000" 2>nul || start "" "http://127.0.0.1:8000"
echo Q-NEXUS running at http://127.0.0.1:8000
