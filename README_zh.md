# Excalidraw Handdraw Skill

手绘风格图表生成工具，基于 Excalidraw Canvas 服务器和 Playwright。

## 功能特性

- 生成手绘风格架构图、流程图、ER 图等
- 支持中文手写字体
- 导出干净的图表图片（无 UI 元素）
- Docker 部署 Canvas 服务器
- 支持 PNG/SVG 格式导出

## 快速开始

### 1. 启动 Canvas 服务器

```bash
./scripts/start-canvas.sh
```

### 2. 检查服务状态

```bash
curl -s http://localhost:3000/health
```

### 3. 创建图表

通过 REST API 创建元素：

```bash
curl -X POST http://localhost:3000/api/elements/batch \
  -H "Content-Type: application/json" \
  -d '{
    "elements": [
      {"id": "box1", "type": "rectangle", "x": 100, "y": 100, "width": 160, "height": 60, "label": {"text": "服务 A"}},
      {"id": "box2", "type": "rectangle", "x": 400, "y": 100, "width": 160, "height": 60, "label": {"text": "服务 B"}},
      {"type": "arrow", "x": 0, "y": 0, "start": {"id": "box1"}, "end": {"id": "box2"}}
    ]
  }'
```

### 4. 导出图片

```bash
./scripts/export-canvas.sh /tmp/diagram.png
```

导出的图片只包含画布内容，无顶部/底部工具栏。

### 5. 保存到指定目录

```bash
./scripts/save-to-file.sh --source /tmp/diagram.png --dest docs/diagram.png
```

## 目录结构

```
.
├── SKILL.md                 # Skill 说明文档
├── README.md                # 本文件
├── excalidraw-handdraw.skill  # Skill 打包文件
├── scripts/
│   ├── start-canvas.sh      # 启动 Canvas 服务器
│   ├── stop-canvas.sh       # 停止 Canvas 服务器
│   ├── export-canvas.sh     # 导出画布图片（无 UI）
│   ├── save-to-file.sh      # 保存图片到指定目录
│   ├── insert-image.sh      # 插入图片到文件
│   └── replace-image.sh     # 替换文件中的图片
└── references/
    └── cheatsheet.md        # API 速查表
```

## 常用命令

| 操作 | 命令 |
|------|------|
| 启动 Canvas | `./scripts/start-canvas.sh` |
| 停止 Canvas | `./scripts/stop-canvas.sh` |
| 导出图片 | `./scripts/export-canvas.sh /tmp/diagram.png` |
| 保存到目录 | `./scripts/save-to-file.sh --source /tmp/d.png --dest docs/d.png` |
| 插入到文件 | `./scripts/insert-image.sh --file README.md --marker "diagram" --image d.png` |
| 替换图片 | `./scripts/replace-image.sh --file README.md --old old.png --new new.png` |

## 坐标系统

- 原点 (0,0) 在左上角
- x 向右增加，y 向下增加
- 元素宽度：`max(160, labelCharCount * 9)`
- 元素高度：单行 60px，双行 80px
- 垂直间距：80-120px
- 水平间距：40-60px

## 元素类型

| 类型 | 说明 |
|------|------|
| `rectangle` | 矩形 |
| `ellipse` | 椭圆 |
| `diamond` | 菱形 |
| `text` | 文字 |
| `arrow` | 箭头 |
| `line` | 直线 |

## API 端点

| 方法 | 端点 | 说明 |
|------|------|------|
| GET | `/health` | 健康检查 |
| GET | `/api/elements` | 获取所有元素 |
| POST | `/api/elements/batch` | 批量创建元素 |
| DELETE | `/api/elements/clear` | 清空画布 |
| POST | `/api/export/image` | 导出图片 |

## Docker

Canvas 服务器使用 Docker 镜像：`ghcr.io/yctimlin/mcp_excalidraw-canvas:latest`

容器端口：3000

## 故障排除

- **Canvas 无法连接**：检查 Docker 容器是否运行 `docker ps | grep mcp_excalidraw-canvas`
- **导出失败**：确保浏览器可访问 http://localhost:3000
- **权限错误**：确保用户对目标目录有写权限
