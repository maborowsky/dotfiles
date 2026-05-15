#!/bin/bash

# Check if Docker Desktop is running
if pgrep -x "Docker" > /dev/null; then
  # Count running containers
  COUNT=$(docker ps -q | wc -l | xargs)

  # Update SketchyBar with an icon and the count
  # sketchybar --set $NAME icon= label="$COUNT"
  sketchybar --set $NAME icon=
else
  # Docker is off
  sketchybar --set $NAME icon=
fi
