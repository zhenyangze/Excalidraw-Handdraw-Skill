#!/bin/bash
# Export only the Excalidraw canvas area (without UI buttons)
# Usage: ./export-canvas.sh [--output path]
# Requires: Playwright Python

OUTPUT="${1:-/tmp/excalidraw-diagram.png}"
CANVAS_URL="${EXPRESS_SERVER_URL:-http://localhost:3000}"

python3 << EOF
from playwright.sync_api import sync_playwright

canvas_url = "$CANVAS_URL"
output_path = "$OUTPUT"

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    page.set_viewport_size({"width": 1920, "height": 1080})

    print(f"Navigating to {canvas_url}...")
    page.goto(canvas_url, wait_until="networkidle", timeout=30000)
    page.wait_for_timeout(3000)

    # Hide UI elements using specific selectors
    page.evaluate("""
    () => {
        // Hide header bar
        document.querySelectorAll('.header').forEach(el => el.style.display = 'none');
        // Hide top menu bar
        document.querySelectorAll('.App-menu_top').forEach(el => el.style.display = 'none');
        // Hide left side toolbar
        document.querySelectorAll('.FixedSideContainer_side_top').forEach(el => el.style.display = 'none');
        // Hide bottom bar
        document.querySelectorAll('.App-bottom-bar').forEach(el => el.style.display = 'none');
        // Hide layer UI wrapper footer elements
        document.querySelectorAll('.layer-ui__wrapper__footer-left, .layer-ui__wrapper__footer-right').forEach(el => el.style.display = 'none');
    }
    """)

    page.wait_for_timeout(500)

    # Take screenshot with clip to capture only canvas area (y=52 to y=1000)
    print("Taking screenshot...")
    page.screenshot(
        path=output_path,
        full_page=False,
        clip={"x": 0, "y": 52, "width": 1920, "height": 948}
    )

    browser.close()
    print(f"Saved to: {output_path}")
EOF

ls -la "$OUTPUT"
