@echo off
setlocal enabledelayedexpansion

:: Initialize variables
set driveType=Unknown
set serialNumber=Unknown

:: Check if NVMe
wmic diskdrive where "PNPDeviceID like 'NVME%%'" get PNPDeviceID | find "NVME" >nul
if errorlevel 1 (
    set driveType=SATA
) else (
    set driveType=NVMe
)
echo.
:: Get Serial Number
for /f "skip=1" %%i in ('wmic diskdrive get SerialNumber') do (
    set serialNumber=%%i
    goto displayResult
)

:displayResult
:: Use PowerShell to echo drive type in green, serial number in red, and the instruction in blue
powershell -command "[Console]::ForegroundColor = 'Green'; write-host 'Drive Type Detected: !driveType!' -NoNewline; [Console]::ForegroundColor = 'Red'; write-host ' Serial Number: !serialNumber!'; [Console]::ForegroundColor = 'Blue'; write-host 'COPY AND PASTE SATA/NVME AND SERIALNUMBER IN THE TICKET'; [Console]::ResetColor()"
echo.
endlocal
pause
exit
