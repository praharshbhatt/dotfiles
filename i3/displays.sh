#!/bin/bash

# Display Setup Script
# This script configures display settings using xrandr, dynamically adapting to different hardware setups.

# Usage:
# ./display_setup.sh <main_monitor_index> [--rate <refresh_rate>] [--scale <scaling>] [--res <resolution>]
# - main_monitor_index: The index of the primary monitor (1 for the first detected monitor).
# - --rate <refresh_rate>: Desired refresh rate (optional, defaults to max available).
# - --scale <scaling>: Desired scaling factor (optional, defaults to 1x).
# - --res <resolution>: Desired resolution (optional, defaults to max available).

# Function to get the maximum resolution and refresh rate for a given monitor
get_max_res_refresh() {
    local monitor_name=$1
    xrandr --verbose | grep -A 10 "^$monitor_name connected" | grep -Eo '[0-9]{3,4}x[0-9]{3,4}[^+]*[0-9.]+Hz' | sort -rn -k3 | head -n1
}

# Query all connected monitors and store them in an array
monitor_list=($(xrandr --listmonitors | grep -oP '\s\+\*\K\S+'))

# Ensure the user provided a valid monitor index
if [ -z "$1" ] || [ "$1" -gt "${#monitor_list[@]}" ] || [ "$1" -lt 1 ]; then
    echo "Invalid monitor index. Please provide a valid monitor index (1-${#monitor_list[@]})."
    exit 1
fi

# Set the main monitor based on the provided index
main_monitor=${monitor_list[$1-1]}
shift # Shift past the monitor index argument

# Default values
scaling=1
resolution=""
refresh_rate=""

# Parse optional arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --rate)
            refresh_rate="$2"
            shift 2
            ;;
        --scale)
            scaling="$2"
            shift 2
            ;;
        --res)
            resolution="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Get maximum resolution and refresh rate for the main monitor if not provided
if [[ -z "$resolution" || -z "$refresh_rate" ]]; then
    max_res_refresh=$(get_max_res_refresh $main_monitor)
    max_res=$(echo $max_res_refresh | awk '{print $1}')
    max_refresh_rate=$(echo $max_res_refresh | awk '{print $2}' | tr -d 'Hz')
fi

# Apply defaults if not provided by the user
resolution=${resolution:-$max_res}
refresh_rate=${refresh_rate:-$max_refresh_rate}

# Run the xrandr command to set the display parameters
xrandr --output $main_monitor --mode $resolution --rate $refresh_rate --scale ${scaling}x${scaling}

# Output the applied settings
echo "Monitors: ${monitor_list[@]}"
echo "Main Monitor: $main_monitor"
echo "Resolution: $resolution"
echo "Refresh Rate: $refresh_rate Hz"
echo "Scaling: ${scaling}x${scaling}"
