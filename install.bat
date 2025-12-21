@echo off
REM ============================================================================
REM libconfig Extension Installer for Zed Editor (Windows)
REM ============================================================================
REM This script installs the libconfig extension for Zed Editor on Windows
REM by creating a symbolic link to the extension directory.
REM
REM Requirements: Administrator privileges
REM ============================================================================

echo.
echo ============================================================================
echo  libconfig Extension Installer for Zed Editor
echo ============================================================================
echo.

REM Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] This script requires administrator privileges.
    echo Please right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

REM Get the directory where this script is located
set SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

REM Set Zed extensions directory
set ZED_EXT_DIR=%LOCALAPPDATA%\Zed\extensions\installed
set TARGET_DIR=%ZED_EXT_DIR%\libconfig

echo Script directory: %SCRIPT_DIR%
echo Target directory: %TARGET_DIR%
echo.

REM Create Zed extensions directory if it doesn't exist
if not exist "%ZED_EXT_DIR%" (
    echo Creating Zed extensions directory...
    mkdir "%ZED_EXT_DIR%"
    if %errorLevel% neq 0 (
        echo [ERROR] Failed to create directory: %ZED_EXT_DIR%
        pause
        exit /b 1
    )
)

REM Check if extension already exists
if exist "%TARGET_DIR%" (
    echo [WARNING] Extension directory already exists: %TARGET_DIR%
    echo.
    choice /C YN /M "Do you want to remove it and reinstall"
    if errorlevel 2 (
        echo Installation cancelled.
        pause
        exit /b 0
    )

    echo Removing existing installation...
    rmdir "%TARGET_DIR%"
    if %errorLevel% neq 0 (
        echo [ERROR] Failed to remove existing directory
        pause
        exit /b 1
    )
)

REM Create symbolic link
echo Creating symbolic link...
mklink /D "%TARGET_DIR%" "%SCRIPT_DIR%"

if %errorLevel% neq 0 (
    echo.
    echo [ERROR] Failed to create symbolic link.
    echo.
    echo Falling back to copying files...
    xcopy /E /I /Y "%SCRIPT_DIR%" "%TARGET_DIR%"
    if %errorLevel% neq 0 (
        echo [ERROR] Failed to copy files
        pause
        exit /b 1
    )
    echo Files copied successfully.
    set INSTALL_METHOD=copy
) else (
    echo Symbolic link created successfully.
    set INSTALL_METHOD=symlink
)

echo.
echo ============================================================================
echo  Installation Complete!
echo ============================================================================
echo.
echo Installation method: %INSTALL_METHOD%
echo Extension location: %TARGET_DIR%
echo.
echo Next steps:
echo   1. Restart Zed Editor (if running)
echo   2. Or open Command Palette (Ctrl+Shift+P) and run:
echo      "zed: reload extensions"
echo   3. Open any .conf file to see syntax highlighting
echo.
echo To verify installation:
echo   - Open a .conf file in Zed
echo   - Check the language indicator (bottom-right corner)
echo   - It should show "libconfig"
echo.
echo Example files to test:
echo   - %SCRIPT_DIR%\example.conf
echo.
echo ============================================================================

pause
