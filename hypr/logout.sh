#!/bin/bash

LOCK_HOUR=$(cat "/tmp/unlock.txt")
unlock_time=$((LOCK_HOUR + 30))
time=$(date +"%s")

if [ $time -ge $unlock_time ] 
then
	echo "$time et $unlock_time"
	echo "Temps écoulé"
	hyprctl dispatch exit
	exit
else
	echo "Trop tôt"
fi

