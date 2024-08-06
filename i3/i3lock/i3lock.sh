#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to revert changes
revert() {
  rm /tmp/*screen*.png
  if [ "$TURN_OFF_DISPLAY" = "true" ]; then
    xset dpms 0 0 0  # Revert DPMS settings
  fi
}

# Trap signals to ensure the revert function is called
trap revert HUP INT TERM

# Default value for TURN_OFF_DISPLAY flag
TURN_OFF_DISPLAY=false

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --turn-off-display)
      TURN_OFF_DISPLAY=true
      shift
      ;;
    *)
      echo "Usage: $0 [--turn-off-display]"
      exit 1
      ;;
  esac
done

# Kill Rofi if it's running
# This is because in a lot of instances when rofi is running for whatever reason
# i3lock will fail
pkill rofi

# Sleep to ensure Rofi has time to terminate
sleep 0.5


# Configure DPMS settings if flag is set
if [ "$TURN_OFF_DISPLAY" = "true" ]; then
  xset +dpms dpms 0 0 5  # Turn off display after 5 seconds of inactivity
fi

# Capture the current screen
scrot /tmp/locking_screen.png

# Apply a blur effect to the screenshot
convert -blur 0x8 /tmp/locking_screen.png /tmp/screen_blur.png

# Composite the lock image onto the blurred screenshot
convert -composite /tmp/screen_blur.png "$SCRIPT_DIR/rick_and_morty.png" -gravity South -geometry -20x1200 /tmp/screen.png

# Lock the screen using i3lock
i3lock -i /tmp/screen.png

# Call revert function to clean up temporary files and reset settings
revert
