#!/bin/bash
# Save exported image to specified directory
# Usage: ./save-to-file.sh --source <source_path> --dest <dest_path>

SOURCE=""
DEST=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --source)
            SOURCE="$2"
            shift 2
            ;;
        --dest)
            DEST="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ -z "$SOURCE" ]] || [[ -z "$DEST" ]]; then
    echo "Usage: ./save-to-file.sh --source <source_path> --dest <dest_path>"
    exit 1
fi

if [[ ! -f "$SOURCE" ]]; then
    echo "Error: Source file not found: $SOURCE"
    exit 1
fi

# Create destination directory if needed
DEST_DIR=$(dirname "$DEST")
mkdir -p "$DEST_DIR"

# Copy file
cp "$SOURCE" "$DEST"
echo "Saved to $DEST"
ls -la "$DEST"
