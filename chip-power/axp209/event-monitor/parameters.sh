WRITER_PID=''
terminate_writer() {
	test -n "$WRITER_PID" \
	&& kill -TERM "$WRITER_PID"
	exit 0
}
trap terminate_writer SIGTERM

case $1 in
        --dynamic-loop-vars)
		BASE_DIR="${0%.sh}"
		if test "$BASE_DIR/event-monitor.cfg" -nt "$BASE_DIR/dynamic-loop-vars.sh"
		then
			cat "$BASE_DIR/event-monitor.cfg" \
			| $AXP209_ETC/event-monitor/compile-dynamic-loop-vars.sh "$2" \
			> "$BASE_DIR/dynamic-loop-vars.sh" \
			|| exit $?
		fi
		echo "$BASE_DIR/dynamic-loop-vars.sh"
                ;;
        --process-edges)
		read WRITER_PID

                while read EDGE_TYPE EDGE_VALUE MAIN_SCRIPT
                do
                	process-edge "$EDGE_TYPE" "$EDGE_VALUE" "$MAIN_SCRIPT"
                done
                ;;
        *)
                echo "Error: unknown parameter '$1'."
                exit 2
                ;;
esac
