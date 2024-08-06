!/bin/bash
# Terminal command variable
TERMINAL="kitty"
# TERMINAL="konsole -e"
# TERMINAL="alacritty -e"

# Display Rofi menu and get user selection
selection=$(echo "Chat to AI (conversational)\nSummarize (clipboard)\nExtract Wisdom (clipboard)\nExtract Wisdom (YouTube)" | rofi -dmenu -p "Select AI Commands")

# Speak Using Piper TTS
speak_text="piper --model ~/.config/piper/en_GB-alan-medium.onnx --output-raw | aplay -r 22050 -f S16_LE -t raw"

# Render Markdown in terminal
markdown_renderer="glow"

case "$selection" in
    "Chat to AI (conversational)")
        # Run the command for chatting to AI
        $TERMINAL bash -c "ollama run llama3.1:8b; exec bash"
        ;;
    "Summarize (clipboard)")
        # Run the command for summarizing clipboard
        $TERMINAL bash -c "xclip -selection clipboard -o | fabric -sp summarize | tee >( $markdown_renderer ) | tee >( $speak_text ); exec bash"
        ;;
    "Extract Wisdom (clipboard)")
        # Run the command for extracting wisdom from clipboard
        $TERMINAL bash -c "xclip -selection clipboard -o | fabric -sp extract_wisdom | tee >( $markdown_renderer ) | tee >( $speak_text ); exec bash"
        ;;
    "Extract Wisdom (YouTube)")
        # Run the command for extracting wisdom from a YouTube transcript
        $TERMINAL bash -c 'yt --transcript "$(xclip -selection clipboard -o)" | fabric --stream --pattern extract_wisdom; exec bash'
        ;;
    *)
        echo "No valid selection made."
        ;;
esac
