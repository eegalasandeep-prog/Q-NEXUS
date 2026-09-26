@echo off
setlocal
echo ======================================================================
echo   Q-NEXUS: PUSH REPOSITORY TO GITHUB
echo   National Quantum Mission (NQM) - Deep-Tech Telecom & 5G/6G Optimization
echo ======================================================================
echo.

set "GIT_CMD=C:\Users\user\AppData\Local\Programs\MinGit\cmd\git.exe"
if not exist "%GIT_CMD%" set "GIT_CMD=git"

echo Checking Git status...
"%GIT_CMD%" status --short

echo.
echo Please create a new empty repository on https://github.com/new
echo.
set /p REPO_URL="Enter your GitHub Repository URL (e.g. https://github.com/username/q-nexus.git): "

if "%REPO_URL%"=="" (
    echo [ERROR] No URL entered. Aborting.
    pause
    exit /b 1
)

echo.
echo Adding remote origin: %REPO_URL%
"%GIT_CMD%" remote remove origin 2>nul
"%GIT_CMD%" remote add origin %REPO_URL%

echo Renaming branch to main...
"%GIT_CMD%" branch -M main

echo.
echo Pushing to GitHub...
"%GIT_CMD%" push -u origin main

if %ERRORLEVEL% equ 0 (
    echo.
    echo ======================================================================
    echo [SUCCESS] Q-NEXUS repository pushed successfully to GitHub!
    echo.
    echo Next Steps:
    echo 1. Open Render (https://render.com) or Railway (https://railway.app)
    echo 2. Connect your GitHub repo for instant 1-click cloud deployment.
    echo 3. The included render.yaml and Dockerfile will deploy the whole app!
    echo ======================================================================
) else (
    echo.
    echo [NOTE] If GitHub asked for authentication, sign in with your GitHub
    echo account or Personal Access Token (PAT).
)

echo.
pause
