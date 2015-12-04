#! /bin/bash

LINE_NO="-1"
QUICK_FOR=""

echo "AXP209_SH='$1'"
while read WORD1 WORD2
do
	case $WORD1 in
		interval)
			echo "INTERVAL='$WORD2'"
			continue
			;;
	esac

	DUMMY="${WORD2:=1}"
	LINE_NO=$(( LINE_NO+1 ))
	QUICK_FOR="$QUICK_FOR $LINE_NO"
	echo "VALUE_NAME[$LINE_NO]='$WORD1'"
	echo "FORMER_VALUE[$LINE_NO]='$WORD2'"
	echo "THRESHOLD[$LINE_NO]='$WORD2'"
done
echo "set $QUICK_FOR"
