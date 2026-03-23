# Excalidraw Handdraw Skill

Hand-drawn style diagram generation tool based on Excalidraw Canvas server and Playwright.

## Features

- Generate hand-drawn style architecture diagrams, flowcharts, ER diagrams, etc.
- Support for Chinese handwritten fonts
- Export clean diagram images (no UI elements)
- Docker-deployed Canvas server
- Support PNG/SVG format export

## Quick Start

### 1. Start Canvas Server

```bash
./scripts/start-canvas.sh
```

### 2. Check Service Status

```bash
curl -s http://localhost:3000/health
```

### 3. Create Diagram

Create elements via REST API:

```bash
curl -X POST http://localhost:3000/api/elements/batch \
  -H "Content-Type: application/json" \
  -d '{
    "elements": [
      {"id": "box1", "type": "rectangle", "x": 100, "y": 100, "width": 160, "height": 60, "label": {"text": "Service A"}},
      {"id": "box2", "type": "rectangle", "x": 400, "y": 100, "width": 160, "height": 60, "label": {"text": "Service B"}},
      {"type": "arrow", "x": 0, "y": 0, "start": {"id": "box1"}, "end": {"id": "box2"}}
    ]
  }'
```

### 4. Export Image

```bash
./scripts/export-canvas.sh /tmp/diagram.png
```

Exported image contains only canvas content, no top/bottom toolbars.

### 5. Save to Directory

```bash
./scripts/save-to-file.sh --source /tmp/diagram.png --dest docs/diagram.png
```

## Directory Structure

```
.
├── README.md                  # English documentation
├── README_zh.md              # Chinese documentation
├── SKILL.md                  # Skill documentation
├── excalidraw-handdraw.skill # Skill package file
├── scripts/
│   ├── start-canvas.sh        # Start Canvas server
│   ├── stop-canvas.sh         # Stop Canvas server
│   ├── export-canvas.sh      # Export canvas image (no UI)
│   ├── save-to-file.sh        # Save image to directory
│   ├── insert-image.sh        # Insert image into file
│   └── replace-image.sh       # Replace image in file
└── references/
    └── cheatsheet.md          # API cheat sheet
```

## Common Commands

| Operation | Command |
|-----------|---------|
| Start Canvas | `./scripts/start-canvas.sh` |
| Stop Canvas | `./scripts/stop-canvas.sh` |
| Export Image | `./scripts/export-canvas.sh /tmp/diagram.png` |
| Save to Directory | `./scripts/save-to-file.sh --source /tmp/d.png --dest docs/d.png` |
| Insert into File | `./scripts/insert-image.sh --file README.md --marker "diagram" --image d.png` |
| Replace Image | `./scripts/replace-image.sh --file README.md --old old.png --new new.png` |

## Coordinate System

- Origin (0,0) at top-left
- x increases rightward, y increases downward
- Element width: `max(160, labelCharCount * 9)`
- Element height: single line 60px, double line 80px
- Vertical spacing: 80-120px
- Horizontal spacing: 40-60px

## Element Types

| Type | Description |
|------|-------------|
| `rectangle` | Rectangle |
| `ellipse` | Ellipse |
| `diamond` | Diamond |
| `text` | Text |
| `arrow` | Arrow |
| `line` | Line |

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check |
| GET | `/api/elements` | Get all elements |
| POST | `/api/elements/batch` | Batch create elements |
| DELETE | `/api/elements/clear` | Clear canvas |
| POST | `/api/export/image` | Export image |

## Docker

Canvas server uses Docker image: `ghcr.io/yctimlin/mcp_excalidraw-canvas:latest`

Container port: 3000

## Troubleshooting

- **Canvas connection failed**: Check if Docker container is running `docker ps | grep mcp_excalidraw-canvas`
- **Export failed**: Ensure browser can access http://localhost:3000
- **Permission error**: Ensure user has write permission to target directory
