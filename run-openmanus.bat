@echo off
REM Quick execution script for OpenManus
setlocal

echo Starting OpenManus...
echo.

REM Set Python path
set PYTHONPATH=D:\laragon\www\market\OpenManus

REM Check if argument provided
if "%~1"=="" (
    echo Usage: %~nx0 "your prompt here"
    echo Example: %~nx0 "search for cat pictures"
    echo.
    echo Or run interactively:
    python "%PYTHONPATH%\main.py"
) else (
    echo Running: %~1
    echo.
    python "%PYTHONPATH%\main.py" --prompt "%~1"
)

pause
