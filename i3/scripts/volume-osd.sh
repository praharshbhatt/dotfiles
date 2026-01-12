#!/bin/bash

# Volume OSD script using pactl and dunst

# Get the action from command line argument
ACTION="$1"

case "$ACTION" in
    "up")
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        ;;
    "down")
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    "mute")
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
    *)
        echo "Usage: $0 {up|down|mute}"
        exit 1
        ;;
esac

# Get current volume info
VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -1)
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes" && echo "true" || echo "false")

# Create notification
if [ "$MUTED" = "true" ]; then
    ICON="🔇"
    TEXT="Volume: Muted"
    URGENCY="low"
else
    if [ "$VOLUME" -gt 70 ]; then
        ICON="🔊"
    elif [ "$VOLUME" -gt 30 ]; then
        ICON="🔉"
    else
        ICON="🔈"
    fi
    TEXT="Volume: ${VOLUME}%"
    URGENCY="low"
fi

# Send notification with progress bar
notify-send -u "$URGENCY" -i "audio-volume-high" -h "int:value:$VOLUME" -h "string:synchronous:volume" "$ICON $TEXT"