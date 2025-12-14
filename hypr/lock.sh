#!/bin/bash

LOCK_STMP=$(date +"%s")
export HOUR_LOCK=$(date +"%H:%M:%S")

echo "$LOCK_STMP" > "/tmp/unlock.txt"

#export HOUR_LOCK="Test"

hyprlock
