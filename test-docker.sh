#!/bin/bash

# Docker Setup Test Script
# This script tests the Docker setup for OpenManus

echo "🐳 Testing OpenManus Docker Setup"
echo "=================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed or not in PATH"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed or not in PATH"
    exit 1
fi

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo "❌ Docker daemon is not running"
    echo "Please start Docker Desktop or Docker daemon"
    exit 1
fi

echo "✅ Docker is installed and running"
echo "✅ Docker Compose is available"

# Test build
echo ""
echo "🔨 Testing Docker build..."
if docker-compose build --quiet openmanus; then
    echo "✅ Docker build successful"
else
    echo "❌ Docker build failed"
    exit 1
fi

# Test basic functionality
echo ""
echo "🧪 Testing basic container functionality..."
if docker-compose run --rm openmanus python -c "print('Container test successful!')"; then
    echo "✅ Container test successful"
else
    echo "❌ Container test failed"
    exit 1
fi

echo ""
echo "🎉 All tests passed! OpenManus Docker setup is ready."
echo ""
echo "Next steps:"
echo "  - Run: ./docker-run.sh up    (or docker-run.bat up on Windows)"
echo "  - Access: http://localhost:8000"
echo "  - Interactive: ./docker-run.sh mcp"
