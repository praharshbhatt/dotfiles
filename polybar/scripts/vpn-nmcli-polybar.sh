#!/usr/bin/env bash

# Function to display VPN status for Polybar
display_status() {
    ACTIVE_CONNECTION_NAME=$(nmcli -t connection show --active | grep vpn | cut -d ':' -f 1)
    if [ -n "$ACTIVE_CONNECTION_NAME" ]; then
        echo "$ACTIVE_CONNECTION_NAME"
    else
        echo "VPN Off"
    fi
}

# Function to show a rofi menu with VPN options
vpn_menu() {
    # Get a list of all configured VPN connections
    VPN_LIST=$(nmcli -t --fields NAME,TYPE connection | grep ':vpn$' | cut -d':' -f1)

    # Get the name of the currently active VPN connection
    ACTIVE_VPN=$(nmcli -t connection show --active | grep vpn | cut -d ':' -f 1)

    # Build the menu for rofi
    if [ -n "$ACTIVE_VPN" ]; then
        # If a VPN is active, show its name and add a disconnect option
        PROMPT="Active: $ACTIVE_VPN"
        MENU=$(printf "%s\n%s" "$VPN_LIST" "Disconnect")
    else
        PROMPT="Select VPN"
        MENU="$VPN_LIST"
    fi

    # Show rofi and get the user's choice
    CHOICE=$(echo -e "$MENU" | rofi -dmenu -p "$PROMPT")

    # Act on the user's choice
    case "$CHOICE" in
        "Disconnect")
            # Disconnect from the active VPN
            nmcli c d "$ACTIVE_VPN"
            notify-send "VPN" "Disconnected from $ACTIVE_VPN."
            ;; 
        "" )
            # If rofi was cancelled, do nothing
            ;;
        *)
            # If a VPN was selected, connect to it
            # Disconnect from the current VPN if a different one is selected
            if [ -n "$ACTIVE_VPN" ] && [ "$ACTIVE_VPN" != "$CHOICE" ]; then
                nmcli c d "$ACTIVE_VPN"
            fi
            nmcli c u "$CHOICE"
            notify-send "VPN" "Connecting to $CHOICE..."
            ;;
    esac
}

# Main logic: handle arguments from polybar
case "$1" in
    -t|--toggle-connection)
        vpn_menu
        ;;
    *)
        display_status
        ;;
esac