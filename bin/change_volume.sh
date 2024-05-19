#!/bin/bash

# Arbitrary but unique message tag
msgTag="myvolume"

update_i3status="killall -SIGUSR1 i3status"

if [[ $1 == "toggle_mute" ]]; then
	pactl set-sink-mute @DEFAULT_SINK@ toggle && $update_i3status
else
	pactl set-sink-volume @DEFAULT_SINK@ $1 && $update_i3status
fi

# Query amixer for the current volume and whether or not the speaker is muted
volume="$(pactl get-sink-volume @DEFAULT_SINK@ | awk '/^Vol/{print $5}' | sed 's/[^0-9]*//g')"
mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

if [[ $volume == 0 || "$mute" == "yes" ]]; then
	# Show the sound muted notification
	dunstify -a "change_volume.sh" -u low -i audio-volume-muted-symbolic -h string:x-dunst-stack-tag:$msgTag "Volume muted" 
else
	if [[ $volume -lt 34 ]]; then
		I=low
	elif [[ $volume -lt 67 ]]; then
		I=medium
	else
		I=high
	fi
	# Show the volume notification
	dunstify -a "change_volume.sh" -u low -i audio-volume-$I-symbolic -h string:x-dunst-stack-tag:$msgTag \
		-h int:value:"$volume" "Volume: ${volume}%"
fi
