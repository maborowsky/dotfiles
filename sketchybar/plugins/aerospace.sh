#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

WORKSPACE="$1"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"
WINDOW_COUNT=$(aerospace list-windows --workspace "$WORKSPACE" 2>/dev/null | wc -l | tr -d ' ')

if [ "$WORKSPACE" = "$FOCUSED" ]; then
    sketchybar --set "$NAME" drawing=on background.drawing=on
elif [ "$WINDOW_COUNT" -gt 0 ]; then
    sketchybar --set "$NAME" drawing=on background.drawing=off
else
    sketchybar --set "$NAME" drawing=off
fi
