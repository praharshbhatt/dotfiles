#!/bin/bash
# chmod +x startup_script.sh

# To enable launching this script without sudo, add the following line by executing `sudo visudo` (this will edit the file located in `/etc/sudoers`):
# # Add the startup script to be executed without sudo
# praharshbhatt ALL=(ALL) NOPASSWD: /home/praharshbhatt/.config/i3/starshup_script.sh


# Connect the monitor
# Check if HDMI-1-0 is connected
#if xrandr | grep "HDMI-1-0 connected"; then
    # If HDMI-1-0 is connected, set up the monitors
    # xrandr --output eDP --mode 1920x1080 --rate 165 --pos 0x0 --output HDMI-1-0 --mode 3840x2160 --pos 1920x-1500
#fi

# Setup Keychron keyboard key bindings
# echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode

