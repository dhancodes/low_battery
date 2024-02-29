#!/bin/bash

low=25
critical=15
max=90
battery="/sys/class/power_supply/BAT0"

[[ -d battery ]] && exit 1

value="NONE"
while true; do
    capacity=$(cat $battery/capacity)
    status=$(cat $battery/status)

	if [ "$status" = "Discharging" ]; then
		if [ "$capacity" -le $critical ] && [ $last != "CRITICAL" ]; then
			notify-send -u critical "Battery Level Critical" "Please charge your device to aviod powering off"
			last=CRITICAL
		elif [ "$last" != "CRITICAL"] && [ "$last" != "LOW" ] && [ $capacity -le $low ]; then
			notify-send "Attention: Low Battery" "Battery is at $capacity%"
			last=LOW
		fi
	elif [ "$last" != "FULL" ] && [ "$capacity" -ge $max ]; then
		notify-send "Battery Fully Charged" "Unplug your device to conserve energy."
		last="FULL"
	elif [ "$status" = "Charging" ]; then
		last=NONE
	fi
	sleep 300
done
