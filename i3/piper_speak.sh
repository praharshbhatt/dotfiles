#!/bin/bash

# Script: synthesize_and_play.sh
# Purpose: Synthesize speech using Piper and play it using aplay.
# Author: [Your Name]
# Usage: ./synthesize_and_play.sh "text to synthesize" [path/to/model.onnx] [sample_rate] [audio_format]

# Set defaults
DEFAULT_MODEL="$HOME/.config/piper/en_GB-alan-medium.onnx"
DEFAULT_RATE=22050
DEFAULT_FORMAT="S16_LE"

# Check for required clipboard utility (xclip or xsel)
if ! command -v xclip &> /dev/null && ! command -v xsel &> /dev/null; then
    echo "Error: Neither 'xclip' nor 'xsel' found. Install one to use clipboard fallback."
    exit 3
fi

# Function to get clipboard contents
get_clipboard() {
    if command -v xclip &> /dev/null; then
        xclip -o
    elif command -v xsel &> /dev/null; then
        xsel --clipboard --output
    else
        echo "Error: Unable to access clipboard."
        exit 3
    fi
}

# Check if input text is provided
if [ -z "$1" ]; then
    echo "No text provided as input. Falling back to clipboard contents..."
    TEXT=$(get_clipboard)
    if [ -z "$TEXT" ]; then
        echo "Error: Clipboard is empty. Provide text as input or copy text to clipboard."
        exit 4
    fi
else
    TEXT="$1"
fi

# Assign variables from input or defaults
MODEL="${2:-$DEFAULT_MODEL}"       # Use second argument or default model
SAMPLE_RATE="${3:-$DEFAULT_RATE}" # Use third argument or default rate
AUDIO_FORMAT="${4:-$DEFAULT_FORMAT}" # Use fourth argument or default format

# Check if the specified model exists
if [ ! -f "$MODEL" ]; then
    echo "Error: Voice model not found at $MODEL"
    exit 2
fi

# Temporary file for raw audio
TMP_AUDIO=$(mktemp --suffix=.raw)

# Ensure cleanup of temporary file
cleanup() {
    rm -f "$TMP_AUDIO"
}
trap cleanup EXIT

# Synthesize to temporary raw audio file
echo "$TEXT" | piper --model "$MODEL" --cuda > "$TMP_AUDIO"

# Play the raw audio using aplay
aplay -r "$SAMPLE_RATE" -f "$AUDIO_FORMAT" -t raw "$TMP_AUDIO"

