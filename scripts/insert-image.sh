#!/bin/bash
# Insert image into a file at a specified marker position
# Usage: ./insert-image.sh --file <file_path> --marker <marker_name> --image <image_path> [--description "description"]

FILE=""
MARKER=""
IMAGE_PATH=""
DESCRIPTION=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --file)
            FILE="$2"
            shift 2
            ;;
        --marker)
            MARKER="$2"
            shift 2
            ;;
        --image)
            IMAGE_PATH="$2"
            shift 2
            ;;
        --description)
            DESCRIPTION="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ -z "$FILE" ]] || [[ -z "$MARKER" ]] || [[ -z "$IMAGE_PATH" ]]; then
    echo "Usage: ./insert-image.sh --file <file> --marker <marker> --image <image_path>"
    exit 1
fi

if [[ ! -f "$FILE" ]]; then
    echo "Error: File not found: $FILE"
    exit 1
fi

if [[ ! -f "$IMAGE_PATH" ]]; then
    echo "Error: Image not found: $IMAGE_PATH"
    exit 1
fi

# Get absolute path for image
IMAGE_ABS=$(realpath "$IMAGE_PATH")

# If no description provided, use filename
if [[ -z "$DESCRIPTION" ]]; then
    DESCRIPTION=$(basename "$IMAGE_PATH" | sed 's/\.[^.]*$//')
fi

# Create markdown image tag
MARKDOWN="![$DESCRIPTION]($IMAGE_ABS)"

# Insert at marker position
# Look for <!-- marker:start --> or similar pattern
if grep -q "<!--.*$MARKER.*-->" "$FILE"; then
    # Insert after the marker line
    sed -i.tmp "/<!--.*$MARKER.*-->/a\\
$MARKDOWN\\
" "$FILE"
    rm -f "$FILE.tmp"
    echo "Inserted image after <!-- $MARKER --> marker"
else
    # Append to end of file
    echo "" >> "$FILE"
    echo "$MARKDOWN" >> "$FILE"
    echo "Added image to end of file (no marker found)"
fi

echo "Done: $MARKDOWN"
