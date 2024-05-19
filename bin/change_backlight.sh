#!/bin/bash

# Arbitrary but unique message tag
msgTag="mybacklight"

# p="-perceived"

xbacklight $p $@

backlight=$(xbacklight $p -get)

# Show the volume notification
dunstify -a "change_volume.sh" -u low -h string:x-dunst-stack-tag:$msgTag \
	-h int:value:"$backlight" "Backlight: ${backlight}%" -i display-brightness-symbolic
