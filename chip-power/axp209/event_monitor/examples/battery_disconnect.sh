#! /bin/sh

EDGE="$1"
case $EDGE in
        --criteria)
		echo "--battery_connected 0"
                ;;
        --intervall)
                echo "60s"
                ;;
        battery_connected-raising)
        	echo 'All details in the subject' \
		| mail -s "$@" root
                ;;
        battery_voltage-falling)
        	echo 'All details in the subject' \
		| mail -s "$@" root
                ;;
        *)
                echo "Unknown edge $@"
                ;;
esac
