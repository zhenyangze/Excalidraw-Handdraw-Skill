#!/bin/bash
# Start Excalidraw Canvas Server via Docker
# Usage: ./start-canvas.sh [--port 3000]

PORT="${1:-3000}"

# Check if container already exists
if docker ps | grep -q "mcp_excalidraw-canvas"; then
    echo "Canvas container already running"
    exit 0
fi

# Check if container exists but is stopped
if docker ps -a | grep -q "mcp_excalidraw-canvas"; then
    echo "Starting existing container..."
    docker start mcp_excalidraw-canvas
else
    echo "Creating and starting new canvas container..."
    docker run -d \
        --name mcp_excalidraw-canvas \
        -p ${PORT}:3000 \
        --restart unless-stopped \
        ghcr.io/yctimlin/mcp_excalidraw-canvas:latest
fi

# Wait for health check
echo "Waiting for canvas to be ready..."
for i in {1..30}; do
    if curl -s http://localhost:${PORT}/health > /dev/null 2>&1; then
        echo "Canvas is ready at http://localhost:${PORT}"
        exit 0
    fi
    sleep 1
done

echo "Warning: Canvas may not be fully ready. Check manually at http://localhost:${PORT}"
exit 0
