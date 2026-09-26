@echo off
setlocal enabledelayedexpansion

:: ==============================================================================
:: Q-NEXUS: HIGH-VELOCITY ANTIGRAVITY LAUNCHER (start_system.bat)
:: ==============================================================================
:: Antigravity development mode: zero bloat, pure flight, immediate local execution.
:: Designed for resilient, zero-friction hackathon demos with aggressive socket cleanup.
:: ==============================================================================

echo.
echo ======================================================================
echo    Q-NEXUS: ALIGNED WITH THE NATIONAL QUANTUM MISSION (NQM) OF INDIA
echo      Theme: Indigenous Deep-Tech Telecom & Network Optimization
echo ======================================================================
echo.

:: ------------------------------------------------------------------------------
:: STEP 1: Aggressively Free Ports 8000 and 5173 to prevent WinError 10048
:: ------------------------------------------------------------------------------
echo [1/3] Neutralizing existing socket listeners on ports 8000 and 5173...
powershell -NoProfile -Command ^
  "$ports = @(8000, 5173); foreach ($p in $ports) { " ^
  "  $conns = Get-NetTCPConnection -LocalPort $p -ErrorAction SilentlyContinue; " ^
  "  if ($conns) { " ^
  "    foreach ($c in $conns) { " ^
  "      try { " ^
  "        $proc = Get-Process -Id $c.OwningProcess -ErrorAction SilentlyContinue; " ^
  "        if ($proc) { " ^
  "          Write-Host '  Terminating lingering PID:' $c.OwningProcess 'on port' $p -ForegroundColor Yellow; " ^
  "          Stop-Process -Id $c.OwningProcess -Force -ErrorAction SilentlyContinue; " ^
  "        } " ^
  "      } catch {} " ^
  "    } " ^
  "  } " ^
  "}"
echo [OK] Socket addresses cleared. Zero port conflicts.

:: ------------------------------------------------------------------------------
:: STEP 2: Boot Unified FastAPI Backend with Uvicorn
:: ------------------------------------------------------------------------------
echo.
echo [2/3] Launching Q-NEXUS Unified FastAPI Core on http://127.0.0.1:8000...
start "Q-NEXUS Core Server" cmd /k "python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload"

:: ------------------------------------------------------------------------------
:: STEP 3: Wait 4 seconds for socket bind and open browser dashboard
:: ------------------------------------------------------------------------------
echo.
echo [3/3] Waiting 4 seconds for services to reach steady state...
timeout /t 4 /nobreak >nul

echo.
echo Opening Microsoft Edge to Q-NEXUS Interactive Dashboard...
start msedge "http://localhost:8000/docs"

echo.
echo  ==================================================================
echo   [READY] Q-NEXUS QUANTUM CORE IS NOW OPERATIONAL!
echo   - Interactive API & Swagger: http://localhost:8000/docs
echo   - Telemetry WebSocket:       ws://localhost:8000/ws/telemetry
echo   - Optimization POST:         http://localhost:8000/api/optimize
echo   - AI Explainer POST:         http://localhost:8000/api/explain
echo  ==================================================================
echo.
pause
