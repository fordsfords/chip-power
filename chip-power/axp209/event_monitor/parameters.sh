WRITER_PID=''
terminate_writer() {
	test -n "$WRITER_PID" \
	&& kill -TERM "$WRITER_PID"
	exit 0
}
trap terminate_writer SIGTERM

case $1 in
        --dynamic_loop_vars)
		BASE_DIR="${0%.sh}"
		if test "$BASE_DIR/event_monitor.cfg" -nt "$BASE_DIR/dynamic_loop_vars.sh"
		then
			cat "$BASE_DIR/event_monitor.cfg" \
			| $AXP209_ETC/event_monitor/compile_dynamic_loop_vars.sh "$2" \
			> "$BASE_DIR/dynamic_loop_vars.sh" \
			|| exit $?
		fi
		echo "$BASE_DIR/dynamic_loop_vars.sh"
                ;;
        --process_edges)
		read WRITER_PID

                while read EDGE_TYPE EDGE_VALUE MAIN_SCRIPT
                do
                	process_edge "$EDGE_TYPE" "$EDGE_VALUE" "$MAIN_SCRIPT"
                done
                ;;
        *)
                echo "Error: unknown parameter '$1'."
                exit 2
                ;;
esac
