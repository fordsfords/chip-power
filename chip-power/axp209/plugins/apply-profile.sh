NAME="$1"
shift

PROFILE_CFG="$AXP209_ETC/profiles/$NAME.cfg"
if test -f "$PROFILE_CFG"
then
	cat "$PROFILE_CFG" \
	| while read LINE
	do
		$0 $LINE
	done
else
	echo "Profile '$PROFILE_CFG' doesn't exist."
	exit 2
fi
