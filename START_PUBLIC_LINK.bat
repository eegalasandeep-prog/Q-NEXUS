@echo off
title Q-NEXUS Public Live Tunnel
echo ======================================================================
echo   Q-NEXUS: STARTING PERSISTENT PUBLIC TUNNEL
echo   National Quantum Mission (NQM) - Grade 9.5 Quantum Platform
echo ======================================================================
echo.
echo Your Public Link will be: https://qnexus-platform.loca.lt/preview
echo If prompted for an IP password, your IP is: 157.50.231.157
echo.
:loop
echo Connecting tunnel...
call npx --yes localtunnel --port 8000 --subdomain qnexus-platform
echo Tunnel disconnected. Reconnecting in 3 seconds...
timeout /t 3 /nobreak >nul
goto loop
