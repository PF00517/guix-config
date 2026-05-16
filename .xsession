#!/bin/sh
xset r rate 200 35 &
xrandr -s 1366x768
xwallpaper --zoom ~/walls/train.jpg
picom &
exec qtile start
