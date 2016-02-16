ACTION="$1"
shift
ALL_EVENTS=`ls $AXP209_HOME`
for NAME in $ALL_EVENTS
do
	test -f "$AXP209_HOME/$NAME.sh" || continue
	NAME=`echo "$NAME" | sed -e 's,^.*/,,'`
	$0 --event-monitor "$ACTION" "$NAME"
done
