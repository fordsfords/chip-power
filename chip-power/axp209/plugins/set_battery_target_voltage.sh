VOLTAGE="$1"
shift
case $VOLTAGE in
	4.1)  VALUE=0 ;;
	4.15) VALUE=32 ;;
	4.2)  VALUE=64 ;;
	4.36) VALUE=96 ;;
	*)
		echo "Error: Voltage '$VOLTAGE' out of range. See --usage."
		exit 2
esac
OSB_REGISTER=$(( (`axp209_read_address 0x33` & 159) | $VALUE ))
axp209_write_address 0x33 `printf '0x%X' $OSB_REGISTER`
