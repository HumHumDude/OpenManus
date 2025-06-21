# OpenManus Docker Setup

This directory contains Docker configuration files to containerize and run the OpenManus project.

## Prerequisites

- Docker Engine 20.10+ 
- Docker Compose 2.0+
- At least 4GB free disk space
- 2GB RAM minimum (4GB recommended)

## Quick Start

### Method 1: Using the Management Scripts

#### On Linux/macOS:
```bash
# Make the script executable
chmod +x docker-run.sh

# Build the images
./docker-run.sh build

# Start all services
./docker-run.sh up

# View logs
./docker-run.sh logs

# Run MCP agent interactively
./docker-run.sh mcp
```

#### On Windows:
```cmd
# Build the images
docker-run.bat build

# Start all services  
docker-run.bat up

# View logs
docker-run.bat logs

# Run MCP agent interactively
docker-run.bat mcp
```

### Method 2: Using Docker Compose Directly

```bash
# Build images
docker-compose build

# Start services in background
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## Services

The Docker setup includes three main services:

1. **openmanus** (Port 8000) - Main OpenManus agent
2. **openmanus-mcp-server** (Port 8001) - MCP server
3. **openmanus-flow** (Port 8002) - Flow service

## Configuration

### Environment Variables

The following environment variables are set in the containers:
- `PYTHONPATH=/app/OpenManus`
- `PYTHONUNBUFFERED=1`
- `PYTHONDONTWRITEBYTECODE=1`

### Volume Mounts

The following directories are mounted as volumes for persistence:
- `./config` → `/app/OpenManus/config` (read-only)
- `./logs` → `/app/OpenManus/logs`
- `./downloads` → `/app/OpenManus/downloads` 
- `./workspace` → `/app/OpenManus/workspace`

### Docker Socket

The Docker socket is mounted to enable sandbox functionality:
- `/var/run/docker.sock:/var/run/docker.sock`

## Usage Examples

### Interactive MCP Agent
```bash
# Using management script
./docker-run.sh mcp

# Or directly with docker-compose
docker-compose exec openmanus python run_mcp.py --interactive
```

### Running with Custom Prompt
```bash
docker-compose exec openmanus python run_mcp.py --prompt "Search for cat pictures and download them"
```

### Running Main Agent
```bash
docker-compose exec openmanus python main.py --prompt "Your prompt here"
```

### Accessing Container Shell
```bash
# Using management script
./docker-run.sh shell

# Or directly
docker-compose exec openmanus bash
```

## Troubleshooting

### Permission Issues
If you encounter permission issues with mounted volumes:
```bash
# Fix ownership (Linux/macOS)
sudo chown -R $USER:$USER logs downloads workspace

# Or run with user mapping
docker-compose exec --user root openmanus chown -R openmanus:openmanus /app/OpenManus
```

### Browser/Playwright Issues
The container includes Chromium and necessary dependencies for browser automation. If you encounter issues:
```bash
# Reinstall playwright browsers
docker-compose exec openmanus playwright install chromium
```

### Memory Issues
If containers are killed due to memory:
- Increase Docker memory limit to 4GB+
- Monitor usage: `docker stats`

### Port Conflicts
If ports are already in use, modify the ports in `docker-compose.yml`:
```yaml
ports:
  - "8080:8000"  # Change 8000 to 8080 or any free port
```

## Development

### Building with Cache
```bash
# Build without cache
docker-compose build --no-cache

# Pull latest base images
docker-compose build --pull
```

### Debugging
```bash
# View service logs
docker-compose logs openmanus

# Follow logs in real-time
docker-compose logs -f openmanus

# Check container status
docker-compose ps
```

### Cleanup
```bash
# Stop and remove containers
./docker-run.sh clean

# Or manually
docker-compose down --rmi all --volumes --remove-orphans
```

## Security Notes

- The container runs as a non-root user `openmanus` (UID 1000)
- Sensitive configuration should be mounted as read-only volumes
- The Docker socket mount is required for sandbox functionality but increases privileges
- Consider using Docker secrets for sensitive data in production

## Production Deployment

For production deployment:

1. Use environment-specific compose files:
   ```bash
   docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
   ```

2. Use proper secrets management
3. Set resource limits
4. Configure proper logging drivers
5. Use health checks and restart policies

## Support

If you encounter issues:
1. Check the logs: `./docker-run.sh logs`
2. Verify all prerequisites are installed
3. Ensure ports are not in use by other services
4. Check available disk space and memory
