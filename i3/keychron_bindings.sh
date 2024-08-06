#!/bin/sh

# Binds Keychron keyboard's function keys to the proper keys.

echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode

