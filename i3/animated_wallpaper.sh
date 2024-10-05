#!/bin/sh

killall xwinwrap

sleep 0.3

xwinwrap -fs -ov -ni -- mpv -wid WID -loop "/home/praharsh/.wallpapers/ThrashRacingWallpaperEngine.mp4"
