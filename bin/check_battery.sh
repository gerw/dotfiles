#!/bin/bash
 
# Arbitrary but unique message tag
msgTag="mybattery"

IFS=,

while true; do
	BATTERY_INFO=($(acpi | grep -v unavailable))
	BATTERY_POWER=${BATTERY_INFO[1]# }
	BATTERY_POWER=${BATTERY_POWER%\%}

	if [[ "${BATTERY_INFO[0]#*: }" == "Discharging" ]]; then
		unset BATTERY_INFO[0]

		if [[ $BATTERY_POWER -lt 10 ]]; then
			dunstify -a "check_battery.sh" -u critical -h string:x-dunst-stack-tag:$msgTag \
				-h int:value:"$BATTERY_POWER" \
				"Battery critically low" "${BATTERY_INFO[*]}" \
					-i battery-level-20-symbolic
			elif [[ $BATTERY_POWER -lt 15 ]]; then
				dunstify -a "check_battery.sh" -u normal -h string:x-dunst-stack-tag:$msgTag \
					-h int:value:"$BATTERY_POWER" \
					"Battery low" "${BATTERY_INFO[*]}" \
					-i battery-empty-symbolic
		fi
	fi

	sleep 60

done
