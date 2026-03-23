#!/bin/bash
# Replace an existing image in a file with a new one
# Usage: ./replace-image.sh --file <file_path> --old <old_image_path> --new <new_image_path>

FILE=""
OLD_IMAGE=""
NEW_IMAGE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --file)
            FILE="$2"
            shift 2
            ;;
        --old)
            OLD_IMAGE="$2"
            shift 2
            ;;
        --new)
            NEW_IMAGE="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ -z "$FILE" ]] || [[ -z "$OLD_IMAGE" ]] || [[ -z "$NEW_IMAGE" ]]; then
    echo "Usage: ./replace-image.sh --file <file> --old <old_image> --new <new_image>"
    exit 1
fi

if [[ ! -f "$FILE" ]]; then
    echo "Error: File not found: $FILE"
    exit 1
fi

if [[ ! -f "$NEW_IMAGE" ]]; then
    echo "Error: New image not found: $NEW_IMAGE"
    exit 1
fi

# Get absolute path for new image
NEW_ABS=$(realpath "$NEW_IMAGE")

# Get the description from old image markdown
OLD_MARKDOWN=$(grep -o "!\[.*\](.*$OLD_IMAGE.*)" "$FILE" 2>/dev/null | head -1)
if [[ -z "$OLD_MARKDOWN" ]]; then
    echo "Error: Could not find old image reference in file"
    exit 1
fi

# Extract description
DESCRIPTION=$(echo "$OLD_MARKDOWN" | sed 's/!\[//;s/\].*//')

# Create new markdown
NEW_MARKDOWN="![$DESCRIPTION]($NEW_ABS)"

# Replace
sed -i.tmp "s|$OLD_MARKDOWN|$NEW_MARKDOWN|g" "$FILE"
rm -f "$FILE.tmp"

echo "Replaced: $OLD_MARKDOWN"
echo "     With: $NEW_MARKDOWN"
