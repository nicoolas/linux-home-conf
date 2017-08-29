#!/bin/sh
email=nicoolas.t+server@gmail.com
log_file=/home/saffro/space-disk_check.log

f_K2G() {
	echo "scale=2; $1/1024/1024" | bc 
}

f_log() {
	logger --stderr "$*"
	echo "$(date) - $*" >> $log_file
}

alert_kb=$((2*1024*1024))
total_kb=$(df | grep ' /$' | tr '%' ' ' | awk '{ print $2 }')
free_kb=$(df | grep ' /$' | tr '%' ' ' | awk '{ print $4 }')

alert_gb="$(f_K2G $alert_kb)GB"
total_gb="$(f_K2G $total_kb)GB"
free_gb="$(f_K2G $free_kb)GB"

msg_subject="[$(hostname)] Disk space alert: $free_gb"
msg_contents=$(cat <<-EOS

 Server: $(hostname)
 Date: $(date)
 Disk space available: $free_gb/$total_gb
 Alert below: $alert_gb

EOS
)

printf "$msg_contents\n\n"
f_log "Disk space check: $free_gb/$alert_gb/$total_gb"
if [ $free_kb -lt $alert_kb ]
then
  f_log "Disk space check: $free_gb<$alert_gb -> raising alert"
  [ -n "$email" ] && echo "$msg_contents" | mail -s "$msg_subject" $email
fi

echo

