# Excalidraw MCP & REST API Cheatsheet

## MCP Tools (26 Total)

| Category | Tools |
|----------|-------|
| **Element CRUD** | `create_element`, `get_element`, `update_element`, `delete_element`, `query_elements`, `batch_create_elements`, `duplicate_elements` |
| **Layout** | `align_elements`, `distribute_elements`, `group_elements`, `ungroup_elements`, `lock_elements`, `unlock_elements` |
| **Scene Awareness** | `describe_scene`, `get_canvas_screenshot` |
| **File I/O** | `export_scene`, `import_scene`, `export_to_image`, `export_to_excalidraw_url`, `create_from_mermaid` |
| **State Management** | `clear_canvas`, `snapshot_scene`, `restore_snapshot` |
| **Viewport** | `set_viewport` |
| **Design Guide** | `read_diagram_guide` |
| **Resources** | `get_resource` |

## REST API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check |
| GET | `/api/elements` | Get all elements |
| GET | `/api/elements/:id` | Get one element |
| POST | `/api/elements/batch` | Batch create elements |
| PUT | `/api/elements/:id` | Update element |
| DELETE | `/api/elements/:id` | Delete element |
| DELETE | `/api/elements/clear` | Clear canvas |
| POST | `/api/elements/sync` | Sync/import elements |
| POST | `/api/export/image` | Export as PNG/SVG |
| POST | `/api/viewport` | Set viewport |
| POST | `/api/snapshots` | Create snapshot |
| GET | `/api/snapshots/:name` | Get snapshot |

## Element Types

- `rectangle` - 矩形
- `ellipse` - 椭圆
- `diamond` - 菱形
- `text` - 文字
- `arrow` - 箭头
- `line` - 直线
- `image` - 图片
- `frame` - 框架

## Element Properties

```json
{
  "id": "unique-id",
  "type": "rectangle",
  "x": 100,
  "y": 100,
  "width": 200,
  "height": 100,
  "text": "Label Text",
  "backgroundColor": "#e3f2fd",
  "strokeColor": "#000000",
  "strokeWidth": 2,
  "fontSize": 16,
  "fontFamily": "1"
}
```

## Arrow Binding (MCP vs REST)

**MCP format:**
```json
{"type": "arrow", "startElementId": "id1", "endElementId": "id2"}
```

**REST format:**
```json
{"type": "arrow", "start": {"id": "id1"}, "end": {"id": "id2"}}
```

## Label/Text (MCP vs REST)

**MCP format:**
```json
{"text": "My Label"}
```

**REST format:**
```json
{"label": {"text": "My Label"}}
```

## Coordinate System

- Origin (0, 0) at top-left
- x increases rightward
- y increases downward
- Shape width: `max(160, labelCharCount * 9)`
- Shape height: 60px single-line, 80px two-line
- Vertical spacing: 80-120px
- Horizontal spacing: 40-60px

## Color Palette

| Name | Hex | Use |
|------|-----|-----|
| Light Blue | `#e3f2fd` | Background zones |
| Light Green | `#e8f5e9` | Success states |
| Light Yellow | `#fff9c4` | Warning states |
| Light Red | `#ffcdd2` | Error states |
| Light Purple | `#f3e5f5` | Special zones |
| Gray | `#f5f5f5` | Neutral elements |

## API Examples

### Health Check
```bash
curl http://localhost:3000/health
```

### Batch Create Elements
```bash
curl -X POST http://localhost:3000/api/elements/batch \
  -H "Content-Type: application/json" \
  -d '{
    "elements": [
      {"id": "svc-a", "type": "rectangle", "x": 100, "y": 100, "width": 160, "height": 60, "label": {"text": "Service A"}},
      {"id": "svc-b", "type": "rectangle", "x": 400, "y": 100, "width": 160, "height": 60, "label": {"text": "Service B"}},
      {"type": "arrow", "start": {"id": "svc-a"}, "end": {"id": "svc-b"}}
    ]
  }'
```

### Export as PNG
```bash
curl -X POST http://localhost:3000/api/export/image \
  -H "Content-Type: application/json" \
  -d '{"format": "png", "exportPadding": 20}'
```

### Clear Canvas
```bash
curl -X DELETE http://localhost:3000/api/elements/clear
```

## Common Issues

1. **Text truncation**: Increase `width` to `max(160, labelCharCount * 9)`
2. **Arrow crossing elements**: Use curved arrows with `points` waypoints
3. **Overlapping labels**: Use free-standing text elements, not bound labels on shapes
4. **Export fails**: Ensure browser is open at http://localhost:3000
