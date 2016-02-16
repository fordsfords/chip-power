INTERVAL="$1"
COUNT="$2"
shift 2
ITERATOR=0
while test $ITERATOR -lt $COUNT
do
	$0 --tsv-measurements
	sleep $INTERVAL
	ITERATOR=$(( ITERATOR + 1 ))
done
