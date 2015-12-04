NAME="$2"
shift

PROFILE_CFG="$AXP209_ETC/profile/$1.cfg"
if test -f "$PROFILE_CFG"
then
	while read LINE < "$PROFILE_CFG"
	do
		$0 $LINE
	done
else
	echo "Profile '$PROFILE_CFG' doesn't exist."
	exit 2
fi
