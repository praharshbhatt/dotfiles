#!/bin/bash

# Brightness OSD script using xrandr and dunst

# Get the action from command line argument
ACTION="$1"
DISPLAY_NAME="HDMI-0"  # Based on your i3 config

# Get current brightness
CURRENT_BRIGHTNESS=$(xrandr --verbose | grep -A5 "$DISPLAY_NAME" | grep "Brightness:" | cut -f2 -d ' ')

case "$ACTION" in
    "up")
        NEW_BRIGHTNESS=$(echo "$CURRENT_BRIGHTNESS + 0.05" | bc -l)
        # Cap at 1.0
        if (( $(echo "$NEW_BRIGHTNESS > 1.0" | bc -l) )); then
            NEW_BRIGHTNESS=1.0
        fi
        ;;
    "down")
        NEW_BRIGHTNESS=$(echo "$CURRENT_BRIGHTNESS - 0.05" | bc -l)
        # Don't go below 0.1
        if (( $(echo "$NEW_BRIGHTNESS < 0.1" | bc -l) )); then
            NEW_BRIGHTNESS=0.1
        fi
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac

# Set new brightness
xrandr --output "$DISPLAY_NAME" --brightness "$NEW_BRIGHTNESS"

# Convert to percentage for display
PERCENTAGE=$(echo "scale=0; $NEW_BRIGHTNESS * 100 / 1" | bc)

# Create notification
if [ "$PERCENTAGE" -gt 80 ]; then
    ICON="☀️"
elif [ "$PERCENTAGE" -gt 50 ]; then
    ICON="🌤️"
elif [ "$PERCENTAGE" -gt 20 ]; then
    ICON="🌥️"
else
    ICON="🌙"
fi

# Send notification with progress bar
notify-send -u "low" -i "display-brightness" -h "int:value:$PERCENTAGE" -h "string:synchronous:brightness" "$ICON Brightness: ${PERCENTAGE}%"