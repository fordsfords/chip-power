#! /bin/sh

EDGE="$1"
case $EDGE in
        --criteria)
		echo "--battery-connected 0"
                ;;
        --interval)
                echo "60s"
                ;;
        battery-connected-raising)
        	echo 'All details in the subject' \
		| mail -s "$@" root
                ;;
        battery-voltage-falling)
        	echo 'All details in the subject' \
		| mail -s "$@" root
                ;;
        *)
                echo "Unknown edge $@"
                ;;
esac
