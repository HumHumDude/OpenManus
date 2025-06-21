@echo off
REM OpenManus Docker Management Script for Windows
setlocal enabledelayedexpansion

if "%~1"=="" goto :usage
if "%~1"=="help" goto :usage
if "%~1"=="-h" goto :usage
if "%~1"=="--help" goto :usage

if "%~1"=="build" goto :build
if "%~1"=="up" goto :up
if "%~1"=="start" goto :up
if "%~1"=="down" goto :down
if "%~1"=="stop" goto :down
if "%~1"=="restart" goto :restart
if "%~1"=="logs" goto :logs
if "%~1"=="shell" goto :shell
if "%~1"=="bash" goto :shell
if "%~1"=="mcp" goto :mcp
if "%~1"=="clean" goto :clean
if "%~1"=="status" goto :status

echo Unknown command: %~1
echo.
goto :usage

:usage
echo OpenManus Docker Management Script
echo.
echo Usage: %~nx0 [COMMAND]
echo.
echo Commands:
echo   build     Build the Docker images
echo   up        Start all services
echo   down      Stop all services
echo   restart   Restart all services
echo   logs      View logs from all services
echo   shell     Open a shell in the main container
echo   mcp       Run MCP agent interactively
echo   clean     Remove all containers and images
echo   status    Show status of all services
echo.
goto :end

:build
echo Building OpenManus Docker images...
docker-compose build
echo Build completed!
goto :end

:up
echo Starting OpenManus services...
docker-compose up -d
echo Services started!
echo.
echo Access points:
echo   - Main service: http://localhost:8000
echo   - MCP Server: http://localhost:8001
echo   - Flow service: http://localhost:8002
goto :end

:down
echo Stopping OpenManus services...
docker-compose down
echo Services stopped!
goto :end

:restart
echo Restarting OpenManus services...
docker-compose restart
echo Services restarted!
goto :end

:logs
echo Showing OpenManus logs...
docker-compose logs -f
goto :end

:shell
echo Opening shell in OpenManus container...
docker-compose exec openmanus bash
goto :end

:mcp
echo Running MCP agent interactively...
docker-compose exec openmanus python run_mcp.py --interactive
goto :end

:clean
echo Cleaning up OpenManus containers and images...
docker-compose down --rmi all --volumes --remove-orphans
echo Cleanup completed!
goto :end

:status
echo OpenManus Services Status:
docker-compose ps
goto :end

:end
endlocal
