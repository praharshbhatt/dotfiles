#!/bin/bash

# Rofi and Piper Text-to-Speech Script
# Description: Allows input of text in Rofi, which is then synthesized and spoken using Piper.
# Author: Praharsh Bhatt

# Set defaults
DEFAULT_MODEL="$HOME/.config/piper/jarvis-high.onnx"
DEFAULT_RATE=22050
DEFAULT_FORMAT="S16_LE"

# Temporary file for raw audio
TMP_AUDIO=$(mktemp --suffix=.raw)

# Ensure cleanup of temporary file
cleanup() {
    rm -f "$TMP_AUDIO"
}
trap cleanup EXIT

# Check if the Piper model exists
if [ ! -f "$DEFAULT_MODEL" ]; then
    echo "Error: Voice model not found at $DEFAULT_MODEL"
    exit 2
fi

# Show Rofi input prompt
TEXT=$(rofi -dmenu -p "Enter text to synthesize:" -theme-str 'window {width: 40%;}')
if [ -z "$TEXT" ]; then
    echo "No text entered. Exiting."
    exit 0
fi

# Synthesize the text into temporary raw audio file
echo "$TEXT" | piper --length_scale 0.8 --model "$DEFAULT_MODEL" --cuda > "$TMP_AUDIO"

# Play the raw audio using aplay
aplay -r "$DEFAULT_RATE" -f "$DEFAULT_FORMAT" -t raw "$TMP_AUDIO"

