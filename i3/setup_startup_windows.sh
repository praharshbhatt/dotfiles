#!/bin/bash

# Start a background process safely
start_app() {
    local cmd="$1"
    local delay="${2:-2}"  # Default delay of 2 seconds
    if ! $cmd &>/dev/null & then
        printf "Failed to start: %s\n" "$cmd" >&2
    fi
    sleep "$delay"
}

# Move to workspace and start an app
start_in_workspace() {
    local workspace="$1"
    local cmd="$2"
    i3-msg "workspace $workspace"
    start_app "$cmd"
    sleep 2
}

# Open Signal (Flatpak version)
start_signal() {
    if ! flatpak run org.signal.Signal &>/dev/null & then
        printf "Failed to launch Signal via Flatpak\n" >&2
    fi
    sleep 2
}

# Open Obsidian (Flatpak version)
start_obsidian() {
    if ! flatpak run md.obsidian.Obsidian &>/dev/null & then
        printf "Failed to launch Signal via Flatpak\n" >&2
    fi
    sleep 2
}

# Open Android Studio safely
start_android_studio() {
    local studio_cmd="jetbrains-studio"
    if ! command -v "$studio_cmd" &>/dev/null; then
        studio_cmd="/opt/android-studio/bin/studio.sh"  # Adjust if installed elsewhere
    fi
    start_app "$studio_cmd"
}


main() {
    # Open apps in their respective workspaces
    # start_in_workspace "1" "start_signal"
    # start_in_workspace "2" "start_android_studio"

    # Brave
    ./launch_brave_profiles.sh

    # Open Obsidian (assumed to open in scratchpad)
    start_app "start_obsidian"
}

main

