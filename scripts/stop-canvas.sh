#!/bin/bash
# Stop Excalidraw Canvas Server
# Usage: ./stop-canvas.sh

if docker ps | grep -q "mcp_excalidraw-canvas"; then
    echo "Stopping canvas container..."
    docker stop mcp_excalidraw-canvas
    docker rm mcp_excalidraw-canvas
    echo "Canvas stopped and removed"
else
    echo "No running canvas container found"
fi
