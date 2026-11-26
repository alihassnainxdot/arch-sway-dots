#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Start daemon and wait until socket is ready if not running
if ! awww query >/dev/null 2>&1; then
    awww-daemon >/dev/null 2>&1 &
    until awww query >/dev/null 2>&1; do
        sleep 0.1
    done
fi

# Grid layout overrides on top of your default Rofi theme
GRID_OVERRIDE='
window { width: 1100px; }
listview { columns: 4; lines: 2; }
element { orientation: vertical; }
element-icon { size: 220px; horizontal-align: 0.5; }
element-text { horizontal-align: 0.5; }
'

# Find images and pass filename + icon path to Rofi
SELECTED=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) | sort | while IFS= read -r img; do
    printf "%s\0icon\x1f%s\n" "$(basename "$img")" "$img"
done | rofi -dmenu -i -show-icons -p "Wallpaper" -theme-str "$GRID_OVERRIDE")

# Apply wallpaper with a random transition
if [ -n "$SELECTED" ]; then
    FULL_PATH=$(find "$WALLPAPER_DIR" -type f | grep -F "/$SELECTED" | head -n 1)
    awww img "$FULL_PATH" \
        --transition-type random \
        --transition-step 90 \
        --transition-fps 60
fi
