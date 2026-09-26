@echo off
title Q-NEXUS Quick Fix & Start
echo ========================================================
echo       Q-NEXUS SYSTEM RECOVERY & ONE-CLICK START
echo ========================================================
echo.
echo [1/3] Clearing any hung processes on port 8000 and 5173...
powershell -NoProfile -Command "Stop-Process -Id (Get-NetTCPConnection -LocalPort 8000, 5173 -ErrorAction SilentlyContinue).OwningProcess -Force -ErrorAction SilentlyContinue" >nul 2>&1
echo       Done.

echo [2/3] Starting Q-NEXUS Server (FastAPI + React 3D Digital Twin)...
cd /d "%~dp0backend"
start "Q-NEXUS Server" cmd /k "python -m uvicorn app.main:app --host 0.0.0.0 --port 8000"

echo [3/3] Waiting for server initialization...
timeout /t 4 /nobreak >nul

echo Opening Q-NEXUS Platform in Browser...
start msedge "http://127.0.0.1:8000" 2>nul || start "" "http://127.0.0.1:8000"
echo.
echo ========================================================
echo   Platform is running at: http://127.0.0.1:8000
echo   API Docs available at:  http://127.0.0.1:8000/docs
echo ========================================================
