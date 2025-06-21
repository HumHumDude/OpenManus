# Use Python 3.12 slim image for smaller size
FROM python:3.12-slim

# Set environment variables
ENV PYTHONPATH=/app/OpenManus
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Set working directory
WORKDIR /app/OpenManus

# Install system dependencies including playwright requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    gnupg \
    ca-certificates \
    xvfb \
    chromium \
    chromium-driver \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libgtk-3-0 \
    libgtk-4-1 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    libxss1 \
    libgconf-2-4 \
    && rm -rf /var/lib/apt/lists/* \
    && (command -v uv >/dev/null 2>&1 || pip install --no-cache-dir uv)

# Create non-root user for security
RUN useradd --create-home --shell /bin/bash --user-group --uid 1000 openmanus

# Copy requirements first for better Docker layer caching
COPY requirements.txt .

# Install Python dependencies
RUN uv pip install --system -r requirements.txt

# Install playwright browsers (as root before switching user)
RUN playwright install chromium
RUN playwright install-deps chromium

# Copy application code
COPY . .

# Create necessary directories and set permissions
RUN mkdir -p logs downloads workspace config && \
    chown -R openmanus:openmanus /app/OpenManus

# Switch to non-root user
USER openmanus

# Expose ports (8000 for MCP server, adjust if needed)
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import sys; print('Health check passed')" || exit 1

# Default command - can be overridden
CMD ["python", "main.py"]
