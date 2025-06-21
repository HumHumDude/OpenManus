#!/bin/bash

# OpenManus Docker Startup Script
# This script provides easy commands to manage the OpenManus Docker containers

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_usage() {
    echo -e "${BLUE}OpenManus Docker Management Script${NC}"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  build     Build the Docker images"
    echo "  up        Start all services"
    echo "  down      Stop all services"
    echo "  restart   Restart all services"
    echo "  logs      View logs from all services"
    echo "  shell     Open a shell in the main container"
    echo "  mcp       Run MCP agent interactively"
    echo "  clean     Remove all containers and images"
    echo "  status    Show status of all services"
    echo ""
}

build_images() {
    echo -e "${YELLOW}Building OpenManus Docker images...${NC}"
    docker-compose build
    echo -e "${GREEN}Build completed!${NC}"
}

start_services() {
    echo -e "${YELLOW}Starting OpenManus services...${NC}"
    docker-compose up -d
    echo -e "${GREEN}Services started!${NC}"
    echo ""
    echo -e "${BLUE}Access points:${NC}"
    echo "  - Main service: http://localhost:8000"
    echo "  - MCP Server: http://localhost:8001"
    echo "  - Flow service: http://localhost:8002"
}

stop_services() {
    echo -e "${YELLOW}Stopping OpenManus services...${NC}"
    docker-compose down
    echo -e "${GREEN}Services stopped!${NC}"
}

restart_services() {
    echo -e "${YELLOW}Restarting OpenManus services...${NC}"
    docker-compose restart
    echo -e "${GREEN}Services restarted!${NC}"
}

view_logs() {
    echo -e "${YELLOW}Showing OpenManus logs...${NC}"
    docker-compose logs -f
}

open_shell() {
    echo -e "${YELLOW}Opening shell in OpenManus container...${NC}"
    docker-compose exec openmanus bash
}

run_mcp_interactive() {
    echo -e "${YELLOW}Running MCP agent interactively...${NC}"
    docker-compose exec openmanus python run_mcp.py --interactive
}

clean_all() {
    echo -e "${YELLOW}Cleaning up OpenManus containers and images...${NC}"
    docker-compose down --rmi all --volumes --remove-orphans
    echo -e "${GREEN}Cleanup completed!${NC}"
}

show_status() {
    echo -e "${BLUE}OpenManus Services Status:${NC}"
    docker-compose ps
}

# Main script logic
case "${1:-}" in
    build)
        build_images
        ;;
    up|start)
        start_services
        ;;
    down|stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    logs)
        view_logs
        ;;
    shell|bash)
        open_shell
        ;;
    mcp)
        run_mcp_interactive
        ;;
    clean)
        clean_all
        ;;
    status)
        show_status
        ;;
    ""|-h|--help|help)
        print_usage
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        echo ""
        print_usage
        exit 1
        ;;
esac
