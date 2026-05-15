#!/usr/bin/env bash

MODE="${MODE:-main}"

case "$MODE" in
  main)
    sketchybar --set "$NAME" drawing=off
    ;;
  service)
    sketchybar --set "$NAME" \
      label="$MODE" \
      drawing=on \
      icon.color=0xffff5555 \
      label.color=0xffff5555 \
      background.color=0x33ff5555
    ;;
  *)
    sketchybar --set "$NAME" \
      label="$MODE" \
      drawing=on \
      icon.color=0xffffaa00 \
      label.color=0xffffaa00 \
      background.color=0x33ffaa00
    ;;
esac
