VALUE=`$0 "--$1" | sed -e 's,[^0-9].*,,'`
THRESHOLD="$2"
shift 2
if test "$VALUE" -lt "$THRESHOLD"
then
	echo "$VALUE"
	exit 0
else
	exit 1
fi
