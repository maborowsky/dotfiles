#!/usr/bin/env bash

LAYOUT="$(aerospace list-windows --focused --format '%{window-layout}' 2>/dev/null)"

if [[ -z "$LAYOUT" ]]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

case "$LAYOUT" in
  h_tiles)     LABEL="HT" ;;
  v_tiles)     LABEL="VT" ;;
  h_accordion) LABEL="HA" ;;
  v_accordion) LABEL="VA" ;;
  floating)    LABEL="F"  ;;
  *)           LABEL="?"  ;;
esac

sketchybar --set "$NAME" \
  drawing=on \
  label="$LABEL"
