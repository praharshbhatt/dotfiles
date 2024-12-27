#!/bin/sh

output=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null)
if [ $? -ne 0 ]; then
  echo "No GPU"
else
  echo "$output" | awk '{ print "GPU",""$1"","%"}'
fi