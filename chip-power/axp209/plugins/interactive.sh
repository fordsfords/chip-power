while read -e -p "axp209> " LINE
do
        test "$LINE" = 'quit' -o "$LINE" = 'exit' \
	&& break
	$0 --$LINE
done
