VALUE=`$0 "--$1"`
REFERENCE="$2"
shift 2
if test "$VALUE" = "$REFERENCE"
then
	echo "$VALUE"
	exit 0
else
	exit 1
fi
