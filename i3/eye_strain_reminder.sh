#!/bin/bash

# Kill all the previous instances of this process first
# kill -9 $(pgrep -f ${BASH_SOURCE[0]} | grep -v $$)
sleep 100

# Trap signals for clean exit
trap "echo 'Stopping reminder'; exit" SIGINT SIGTERM

INTERVAL=${1:-1200}
MESSAGE=${2:-"Please rest your eyes. 😭"}

# Customize notification parameters
ICON=${3:-"face-sleeping"}  # Use an appropriate icon from your system or specify a path to a custom icon
URGENCY=${4:-"low"}      # Urgency can be low, normal, or critical
DURATION=${5:-5000}         # Duration in milliseconds (for how long the notification is displayed)

while true; do
    sleep "$INTERVAL"
    notify-send -i "$ICON" -u "$URGENCY" -t "$DURATION" "$MESSAGE"
done
