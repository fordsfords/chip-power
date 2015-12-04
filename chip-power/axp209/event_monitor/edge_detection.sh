#! /bin/bash

RUN_LOOP=1
SLEEP_PID=''
terminate_detection_loop() {
	RUN_LOOP=0
	test -n "$SLEEP_PID" \
	&& kill -TERM "$SLEEP_PID"
}
trap - SIGHUP
trap terminate_detection_loop SIGTERM

QUICK_FOR=""
INTERVAL='60s'
source "$1" || exit 1

echo "$BASHPID"
echo "monitor-raising - $AXP209_SH"

while test "$RUN_LOOP" -eq 1
do
	for LINE_NO
	do
		VALUE=$( $AXP209_SH --${VALUE_NAME[$LINE_NO]} )
		VALUE="${VALUE% *}"
		VALUE="${VALUE%.*}"
		if test "$VALUE" != "${FORMER_VALUE[$LINE_NO]}"
		then
			if test "$VALUE" -lt "${THRESHOLD[$LINE_NO]}"
			then
				EDGE_TYPE='falling'
			else
				EDGE_TYPE='raising'
			fi
#			echo "$( date ) $MONITOR_SH ${VALUE_NAME[$LINE_NO]}-$EDGE $VALUE $AXP209_SH"
			echo "${VALUE_NAME[$LINE_NO]}-$EDGE_TYPE" "$VALUE" "$AXP209_SH"
			FORMER_VALUE[$LINE_NO]="$VALUE"
		fi
	done
	sleep $INTERVAL &
	SLEEP_PID=$!
	wait
	SLEEP_PID=''
done
echo "monitor-falling - $AXP209_SH"
exit 0
