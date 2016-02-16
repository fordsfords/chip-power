ACTION="$1"
NAME="$2"
shift 2

axp209_events_base

case $ACTION in
	install)
		if test -f "$AXP209_HOME/$NAME.sh"
		then
			echo "Error: $AXP209_HOME/$NAME.sh already exists."
		else
			mkdir --mode 2750 "$AXP209_HOME/$NAME"
			echo "Created directory $AXP209_HOME/$NAME"
			touch "$AXP209_HOME/$NAME.sh"
			chmod 750 "$AXP209_HOME/$NAME.sh"
			echo "Created empty script $AXP209_HOME/$NAME.sh"
			echo "See /etc/axp209/events for examples."
		fi
		;;

	list)
		echo "$NAME"
		"$AXP209_HOME/$NAME.sh" --print-edges
		;;

	remove)
		if ! test -d "$AXP209_HOME/$NAME"
		then
			echo "Error: $AXP209_HOME/$NAME does not exists."
			exit 2
		fi
		echo -n "Are you sure to remove event '$NAME' and all of its files? (y/n) "
		read CONFIRMATION

		if test "$CONFIRMATION" = 'y' -o "$CONFIRMATION" = 'Y'
		then
			$0 --event stop "$NAME"
			rm -f "$AXP209_HOME/$NAME"/{event_monitor.pid,stdxxx.txt}
			rm -f "$AXP209_HOME/$NAME"/*~
			rmdir "$AXP209_HOME/$NAME"
			rm "$AXP209_HOME/$NAME.sh"
			echo "Removed event '$NAME'."
		else
			echo "Not removing event '$NAME'."
		fi
		;;

	status)
		PID_FILE="$AXP209_HOME/$NAME/event-monitor.pid"
		PID='-'
		if test -f  "$PID_FILE"
		then
			read PID < "$PID_FILE"
			if ! kill -0 "$PID"
			then
				PID='-'
			fi
		fi
		echo "$PID $NAME"
		;;

	start)
		PID_FILE="$AXP209_HOME/$NAME/event-monitor.pid"
		if test -f  "$PID_FILE"
		then
			read PID < "$PID_FILE"
			if kill -0 "$PID"
			then
				echo "Event '$NAME' already running as pid '$PID'."
				exit 2
			else
				rm -f "$PID_FILE"
			fi
		fi

		MONITOR_SH="$AXP209_HOME/$NAME.sh"
		COMMAND_SH="$AXP209_HOME/$NAME/trigger-command.sh"
		if test -f "$COMMAND_SH"
		then
			echo "Error: the trigger file '$COMMAND_SH' is no longer supported."
			echo "The new file name is $MONITOR_SH"
			echo "Calling parameters are: edge-type, trigger value, event name, calling script."
			exit 2
		fi
		if ! test -s "$MONITOR_SH"
		then
			echo "Error: edge trigger file '$MONITOR_SH' missing or empty."
			echo "Put the commands to be triggered on the edges into that file."
			exit 2
		fi

		(
			SUBCHILD_PID=''
			terminate_edge_pipe() {
				test -n "$SUBCHILD_PID" \
				&& kill -TERM "$SUBCHILD_PID"
			}

			exec 1< /dev/null
			exec >> "$AXP209_HOME/$NAME/stdxxx.txt" 2>&1

			trap "" SIGHUP
			trap terminate_edge_pipe SIGTERM

			echo "$( date ) Entering event loop '$NAME'"

			"$AXP209_ETC/event-monitor/edge-detection.sh" \
				$( "$MONITOR_SH" --dynamic-loop-vars "$0" ) \
			| "$MONITOR_SH" --process-edges &

			SUBCHILD_PID=$!
			wait
			echo "$( date ) Left event loop '$NAME'"
		) &

		CHILD_PID=$!
		echo "Event '$NAME' started as pid '$CHILD_PID'."
		if ! echo "$CHILD_PID" > "$PID_FILE"
		then
			echo "Error: could not create pid file '$PID_FILE'"
		fi
		;;

	stop)
		PID_FILE="$AXP209_HOME/$NAME/event-monitor.pid"
		if test -f  "$PID_FILE"
		then
			read PID < "$PID_FILE"
			echo "Sending SIGTERM to pid '$PID' of event '$NAME'."
			kill -TERM "$PID"
			rm -f "$PID_FILE"
		else
			echo "Event name '$NAME' not running."
			RC_EXIT=2
		fi
		;;

	*)
		echo "Unknown event action '$ACTION'."
		;;
esac
