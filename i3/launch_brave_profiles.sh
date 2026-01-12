#!/usr/bin/env bash
#
# launch_brave_profiles.sh
#
# Purpose:
#   Automatically open specific Brave browser profiles in dedicated i3 workspaces at session startup.
#
# Problem:
#   Brave stores multiple user profiles under opaque directory names (e.g., "Profile 7"), but you want to
#   launch them by your own friendly names (e.g., "Base1") into particular workspaces without hard‑coding
#   directory names that may change.
#
# Solution:
#   1. Read Brave’s JSON “Local State” file to discover the mapping from profile directory to profile name.
#   2. Define a PROFILE_MAP of your friendly profile names → desired i3 workspace numbers.
#   3. Look up each friendly name in the JSON-derived map to find its actual directory.
#   4. Issue an i3-msg command to switch to the workspace and exec Brave with the correct --profile-directory.
#   5. Sleep 2 seconds after each launch to give Brave time to start before moving on.
#
# Usage:
#   1. Place this script in ~/launch_brave_profiles.sh
#   2. Make it executable: chmod +x ~/launch_brave_profiles.sh
#   3. Add to your i3 config or ~/.xprofile: exec --no-startup-id ~/launch_brave_profiles.sh
set -euo pipefail

declare -A PROFILE_MAP=(
  ["praharsh"]=2
  ["JCI"]=3
  ["Base1"]=4
)

LOCAL_STATE="$HOME/.config/BraveSoftware/Brave-Browser/Local State"
INFO_CACHE_PATH='.profile.info_cache'

declare -A NAME_TO_DIR

# Get mapping of internal directory -> user-facing name
mapfile -t profiles < <(jq -r "$INFO_CACHE_PATH | to_entries[] | \"\(.key)::\(.value.name)\"" "$LOCAL_STATE")

for entry in "${profiles[@]}"; do
  dir="${entry%%::*}"
  name="${entry##*::}"
  NAME_TO_DIR["$name"]="$dir"
done

# Launch each desired profile into its workspace
for profile_name in "${!PROFILE_MAP[@]}"; do
  workspace="${PROFILE_MAP[$profile_name]}"
  profile_dir="${NAME_TO_DIR[$profile_name]:-}"

  if [[ -z "$profile_dir" ]]; then
    echo "Warning: Could not find profile dir for '$profile_name'" >&2
    continue
  fi

  i3-msg "workspace $workspace; exec brave-browser --profile-directory=\"$profile_dir\""
  sleep 2
done

