!/bin/bash
# Terminal command variable
TERMINAL="kitty"

# Display Rofi menu and get user selection
selection=$(echo "Scale 0.5\nScale 1\nScale 1.2" | rofi -dmenu -p "Change the Display Scale")

xrandr_command="xrandr --output HDMI-0 --mode 3840x2160 --rate 119.88 --scale"


case "$selection" in
    "Scale 0.5")
        $TERMINAL bash -c "$xrandr_command 0.5x0.5"
        ;;
    "Scale 1")
        $TERMINAL bash -c "$xrandr_command 1x1"
        ;;
    "Scale 1.2")
        $TERMINAL bash -c "$xrandr_command 1.2x1.2"
        ;;
    *)
        echo "No valid selection made."
        ;;
esac
