#! /bin/bash

AC_PRESENT=1
VOLTAGE_LOW=0
process_edge() {
	case $1 in
	        battery-connected-raising)
			logger "$0: Battery connected."
	                ;;
	        battery-connected-falling)
			logger "$0: Battery disconnected."
	                ;;
	        ac-present-raising)
	                AC_PRESENT=1
			test "$VOLTAGE_LOW" -eq 1 \
			&& shutdown -c "AC is back, battery will probably charge."
	                ;;
	        ac_present-falling)
	                AC_PRESENT=0
			test "$VOLTAGE_LOW" -eq 1 \
			&& shutdown -h now "AC gone and battery already low."
	                ;;
	        battery-voltage-raising)
			test "$AC_PRESENT" -eq 1 \
	                && shutdown -c "Battery voltage went up (probably due to charging)."
	                VOLTAGE_LOW=0
	                ;;
	        battery-voltage-falling)
	                VOLTAGE_LOW=1
			test "$AC_PRESENT" -eq 0 \
			&& shutdown -h now "Battery low and AC not back yet."
	                ;;
	        monitor-raising)
	                ;;
	        monitor-falling)
			exit 0
	                ;;
	        *)
	                echo "Unknown edge '$1'"
	                ;;
	esac
}

source "$AXP209_ETC/event-monitor/parameters.sh"
