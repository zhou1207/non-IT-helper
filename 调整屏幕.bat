@echo off
REM 编码选择ANSI或者UTF-8 without BOM 这样echo中文不会显示乱码，下面这行这里是让它UTF-8
chcp 65001 >nul
setlocal

REM 读取当前 LogPixels 数值
for /f "tokens=3" %%A in ('reg query "HKCU\Control Panel\Desktop" /v LogPixels 2^>nul ^| find "LogPixels"') do set DPI=%%A

echo 当前DPI数值是: %DPI%
echo.

REM 判断当前值来调整屏幕大小
if /I "%DPI%"=="0xa8" (
    REM 0xa8 = 168 = 175%
    echo Switching to 200%%...
    REG ADD "HKCU\Control Panel\Desktop" /v LogPixels /t REG_DWORD /d 192 /f >nul
    REG ADD "HKCU\Control Panel\Desktop" /v Win8DpiScaling /t REG_DWORD /d 1 /f >nul
) else if /I "%DPI%"=="0xc0" (
    REM 0xc0 = 192 = 200%
    echo Switching to 175%%...
    REG ADD "HKCU\Control Panel\Desktop" /v LogPixels /t REG_DWORD /d 168 /f >nul
    REG ADD "HKCU\Control Panel\Desktop" /v Win8DpiScaling /t REG_DWORD /d 1 /f >nul
) else (
    echo Current DPI is not 175%% or 200%%.
    timeout /t 5
    exit /b
)

echo.
timeout /t 5
shutdown -l
