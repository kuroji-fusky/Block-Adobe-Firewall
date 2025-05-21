@echo off

net session >nul 2>&1
if %errorlevel% neq 0 (
  echo.
  echo This script is not running with Administrator privilages, please re-run the script with "Run as Administrator".
  echo.
  exit /b
)

powershell -ExecutionPolicy Bypass ^
  -Command "& { Start-Process PowerShell -ArgumentList '-ExecutionPolicy Bypass -File \"%~dp0block.ps1\"' }" ^
  -Verb RunAs
pause >nul