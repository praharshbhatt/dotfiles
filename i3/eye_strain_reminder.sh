#!/bin/bash

# Trap signals for clean exit
trap "echo 'Stopping reminder'; exit" SIGINT SIGTERM

# Default configurations
INTERVAL=${1:-1200}
MESSAGE=${2:-"Please rest your eyes. 😭"}
ICON=${3:-"face-sleeping"}
URGENCY=${4:-"low"}
DURATION=${5:-5000}

# Help flag
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $0 [INTERVAL] [MESSAGE] [ICON] [URGENCY] [DURATION]"
    echo
    echo "Arguments:"
    echo "  INTERVAL    Time interval between reminders in seconds (default: 1200)"
    echo "  MESSAGE     Notification message (default: 'Please rest your eyes. 😭')"
    echo "  ICON        Icon for the notification (default: 'face-sleeping')"
    echo "  URGENCY     Notification urgency (low, normal, critical; default: low)"
    echo "  DURATION    Duration of the notification in milliseconds (default: 5000)"
    exit 0
fi

# Validate inputs
if ! [[ "$INTERVAL" =~ ^[0-9]+$ ]]; then
    echo "Error: INTERVAL must be a positive integer."
    exit 1
fi

if ! [[ "$DURATION" =~ ^[0-9]+$ ]]; then
    echo "Error: DURATION must be a positive integer."
    exit 1
fi

if ! [[ "$URGENCY" =~ ^(low|normal|critical)$ ]]; then
    echo "Error: URGENCY must be one of 'low', 'normal', or 'critical'."
    exit 1
fi

# Check for notify-send
if ! command -v notify-send &> /dev/null; then
    echo "Error: 'notify-send' command not found. Please install it and try again."
    exit 1
fi

# Notify user the script is running
echo "Reminder script is running. Press Ctrl+C to stop."

# Main loop
while true; do
    sleep "$INTERVAL"

    # Send notification
    notify-send -i "$ICON" -u "$URGENCY" -t "$DURATION" "$MESSAGE"

    # Check for errors in notify-send
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to send notification. Exiting."
        exit 1
    fi
done

