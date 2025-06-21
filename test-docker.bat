@echo off
REM Docker Setup Test Script for Windows
REM This script tests the Docker setup for OpenManus

echo 🐳 Testing OpenManus Docker Setup
echo ==================================

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed or not in PATH
    exit /b 1
)

REM Check if Docker Compose is installed
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose is not installed or not in PATH
    exit /b 1
)

REM Check if Docker daemon is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker daemon is not running
    echo Please start Docker Desktop
    exit /b 1
)

echo ✅ Docker is installed and running
echo ✅ Docker Compose is available

REM Test build
echo.
echo 🔨 Testing Docker build...
docker-compose build --quiet openmanus
if %errorlevel% neq 0 (
    echo ❌ Docker build failed
    exit /b 1
)
echo ✅ Docker build successful

REM Test basic functionality
echo.
echo 🧪 Testing basic container functionality...
docker-compose run --rm openmanus python -c "print('Container test successful!')"
if %errorlevel% neq 0 (
    echo ❌ Container test failed
    exit /b 1
)
echo ✅ Container test successful

echo.
echo 🎉 All tests passed! OpenManus Docker setup is ready.
echo.
echo Next steps:
echo   - Run: docker-run.bat up
echo   - Access: http://localhost:8000
echo   - Interactive: docker-run.bat mcp
