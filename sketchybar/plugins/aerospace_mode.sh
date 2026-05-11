#!/usr/bin/env bash

# Triggered by aerospace_mode_change. Receives MODE env var.
# Shows a colored indicator when not in main mode.

MODE="${MODE:-main}"

case "$MODE" in
    service)
        sketchybar --set "$NAME" \
            drawing=on \
            label="SERVICE" \
            label.color=0xffff5555 \
            background.drawing=on \
            background.color=0x33ff5555
        ;;
    *)
        sketchybar --set "$NAME" drawing=off
        ;;
esac
