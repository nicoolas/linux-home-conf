#!/bin/dash

clementine_auto_play="false"

line_unplug="jack/headphone HEADPHONE unplug"
line_plug="jack/headphone HEADPHONE plug"

f_is_running() {
	pgrep "$1" >/dev/null 2>&1
}
f_log() {
	echo "$(date) - $*"
}

f_action() {
	while read line
	do
		case "$line" in
			$line_unplug)
				if f_is_running 'clementine$'
				then
					clementine --pause
					f_log "Clementine: Pause"
					clementine_auto_play="true"
				fi
				;;
			$line_plug)
				if f_is_running 'clementine$'
				then
					if [ "$clementine_auto_play" = "true" ]
					then
						clementine --play
						f_log "Clementine: Play"
					fi
				fi
				clementine_auto_play=false
				;;
		esac
	done
}

acpi_listen | f_action
