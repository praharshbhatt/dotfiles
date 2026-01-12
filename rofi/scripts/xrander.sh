#!/bin/bash
# Get the connected display
DISPLAY_NAME=$(xrandr --query | grep " connected" | awk '{print $1}' | rofi -dmenu -p "Select Display")

# Exit if no display is selected
if [ -z "$DISPLAY_NAME" ]; then
    echo "No display selected."
    exit 1
fi

# Display Rofi menu and get user selection
selection=$(echo -e "Scale 0.4x0.4\nScale 0.5x0.5\nScale 0.6x0.6\nScale 0.8x0.8\nScale 0.9x0.9\nScale 1x1\nScale 1.2x1.2" | rofi -dmenu -p "Change the Display Scale")

# Exit if no selection is made
if [ -z "$selection" ]; then
    echo "No valid selection made."
    exit 1
fi

# Define base xrandr command
BASE_XRANDR_COMMAND="xrandr --output $DISPLAY_NAME --scale"

# Apply scaling based on user selection
case "$selection" in
    "Scale 0.4x0.4")
        $BASE_XRANDR_COMMAND 0.4x0.4
        ;;
    "Scale 0.5x0.5")
        $BASE_XRANDR_COMMAND 0.5x0.5
        ;;
    "Scale 0.6x0.6")
        $BASE_XRANDR_COMMAND 0.6x0.6
        ;;
    "Scale 0.8x0.8")
        $BASE_XRANDR_COMMAND 0.8x0.8
        ;;
    "Scale 0.9x0.9")
        $BASE_XRANDR_COMMAND 0.9x0.9
        ;;
    "Scale 1x1")
        $BASE_XRANDR_COMMAND 1x1
        ;;
    "Scale 1.2x1.2")
        $BASE_XRANDR_COMMAND 1.2x1.2
        ;;
    *)
        echo "Invalid selection."
        exit 1
        ;;
esac

# Refresh nitrogen wallpaper after scaling change
nitrogen --restore

