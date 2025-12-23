@echo off
echo ===================================================
echo     KamKaj App Launcher ^& Network Fixer
echo ===================================================
echo [!] This script solves the "No route to host" error.
echo [!] It uses the "Magic USB Fix" (ADB Reverse).
echo.

echo [1/4] Setting up ADB Connection Tunnel...
"C:\Users\kanwal rai\AppData\Local\Android\Sdk\platform-tools\adb.exe" reverse tcp:5000 tcp:5000

if %errorlevel% neq 0 (
    echo [ERROR] ADB Tunnel Failed! 
    echo 1. Ensure your phone is connected via USB.
    echo 2. Enable "USB Debugging" in Developer Options.
    echo 3. Accept the "Allow USB Debugging" prompt on your phone.
    pause
    exit /b
)
echo [SUCCESS] ADB Tunnel Established (Phone 5000 -^> PC 5000)

echo [2/4] Verifying Backend Server...
netstat -ano | findstr :5000 >nul
if %errorlevel% neq 0 (
    echo [ERROR] Backend Server is NOT running!
    echo Please open a new terminal in 'd:\FYP\Kamkaj\backend' and run 'npm run dev'.
    pause
    exit /b
)
echo [SUCCESS] Backend server is online.

echo [3/4] Cleaning Old Build Cache (Vital step)...
cd kamkaj_app
call flutter clean
echo [SUCCESS] Cache cleaned.

echo [4/4] Building and Launching App...
echo [NOTE] This first build will take 2-3 minutes. Please wait...
call flutter run

pause
