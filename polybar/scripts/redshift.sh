#!/bin/sh

checkIfRunning() {
  if pgrep -f redshift > /dev/null; then
    return 0
  else
    return 1
  fi
}

changeModeToggle() {
  if checkIfRunning; then
    pkill -f redshift
  else
    redshift -P -O 4000 -b 0.6 &
  fi
}

case $1 in 
  toggle)
    changeModeToggle
    ;;
  temperature)
    if checkIfRunning; then
      CURRENT_TEMP=$(redshift -p 2>/dev/null | grep "Color temperature" | sed 's/.*: //')
      echo "$CURRENT_TEMP"
    else
      echo "off"
    fi
    ;;
esac

