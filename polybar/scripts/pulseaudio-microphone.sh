#!/bin/sh

# Get the default non-monitor source index
get_default_source() {
  pacmd list-sources |
    awk '
      /^\*/ {in_default=1; next}
      in_default && /^$/ {in_default=0}
      in_default {print}
    ' |
    grep -v "monitor of" |
    awk '/index:/{print $3; exit}'
}

status() {
  MUTED=$(pacmd list-sources |
    awk '/\*/,EOF {print}' |
    grep -v "monitor of" |
    awk '/muted/ {print $2; exit}')

  if [ "$MUTED" = "yes" ]; then
    echo "muted"
  else
    pacmd list-sources |
      grep "\* index:" -A 7 |
      grep -v "monitor of" |
      grep volume |
      awk -F/ '{print $2}' |
      tr -d ' '
  fi
}

listen() {
  status
  LANG=EN pactl subscribe | while read -r event; do
    if echo "$event" | grep -q "source" || echo "$event" | grep -q "server"; then
      status
    fi
  done
}

toggle() {
  MUTED=$(pacmd list-sources |
    awk '/\*/,EOF {print}' |
    grep -v "monitor of" |
    awk '/muted/ {print $2; exit}')

  if [ "$MUTED" = "yes" ]; then
    pactl set-source-mute @DEFAULT_SOURCE@ 0
  else
    pactl set-source-mute @DEFAULT_SOURCE@ 1
  fi
}

increase() {
  pactl set-source-volume @DEFAULT_SOURCE@ +5%
}

decrease() {
  pactl set-source-volume @DEFAULT_SOURCE@ -5%
}

case "$1" in
  --toggle)
    toggle
    ;;
  --increase)
    increase
    ;;
  --decrease)
    decrease
    ;;
  *)
    listen
    ;;
esac

