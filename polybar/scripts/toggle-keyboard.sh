#!/bin/bash

# Script to toggle on-screen keyboard for Surface devices
# This script will manage onboard virtual keyboard

# Check if onboard is running
if pgrep -x "onboard" > /dev/null; then
    # Get onboard window id
    ONBOARD_WID=$(xdotool search --class "Onboard" | head -1)
    if [ -n "$ONBOARD_WID" ]; then
        # Check if window is visible (mapped)
        if xwininfo -id "$ONBOARD_WID" | grep -q "IsViewable: Yes"; then
            # Hide the window
            xdotool windowunmap "$ONBOARD_WID"
        else
            # Show the window
            xdotool windowmap "$ONBOARD_WID"
            xdotool windowraise "$ONBOARD_WID"
        fi
    else
        # Onboard is running but no window found, just show it
        pkill -USR1 onboard 2>/dev/null || onboard &
    fi
else
    # Onboard is not running, start it
    onboard &
fi
