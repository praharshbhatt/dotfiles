#!/bin/bash

# Define available scaling options
options="0.5\n0.7\n1\n1.2\n1.5\n2\n2.2"

# Get user selection from Rofi
selected=$(echo -e "$options" | rofi -dmenu -p "Select Scaling Factor:")

# Check if a valid option was selected
if [[ -z "$selected" ]]; then
  echo "No selection made. Exiting."
  exit 1
fi

# Get all connected outputs
outputs=$(swaymsg -t get_outputs | jq -r '.[] | select(.active==true) | .name')

# Apply the selected scale to each active output
for output in $outputs; do
  swaymsg output "$output" scale "$selected"
done

echo "Scaling factor set to $selected for all outputs."
