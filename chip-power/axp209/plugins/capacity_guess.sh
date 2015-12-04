if test `$0 --battery_connected` -eq 0
then
	echo "n/a"
	exit 2
fi

VOLTAGE_NOW=`$0 --battery_voltage | sed -e 's,[\. ].*,,'`

IS_DISCHARGING=`$0 --discharge_current | sed -e 's,[\. ].*,,'`
if test "$IS_DISCHARGING" -gt 0
then
	CAPACITY_TYPE="discharge"
else
	CAPACITY_TYPE="charge"
fi

for CAPACITY_CURVE in \
	"$AXP209_HOME/capacity_curves/$BATTERY_TYPE-$CAPACITY_TYPE.txt" \
	"$AXP209_ETC/capacity_curves/$BATTERY_TYPE-$CAPACITY_TYPE.txt"
do
	test -f $CAPACITY_CURVE \
	&& break
done

cat "$CAPACITY_CURVE" \
| (
	NOT_FOUND=1
	while read CAPACITY VOLTAGE_LIMIT
	do
	if test "$VOLTAGE_NOW" -ge "$VOLTAGE_LIMIT"
	then
		echo "$CAPACITY %"
		NOT_FOUND=0
		break
	fi
	done
	exit $NOT_FOUND
)
NOT_FOUND=$?

if test "$NOT_FOUND" -eq 1
then
	echo "0"
fi
