VOLTAGE="$1"
shift
case $VOLTAGE in
	2.6) VALUE=0 ;;
	2.7) VALUE=1 ;;
	2.8) VALUE=2 ;;
	2.9) VALUE=3 ;;
	3.0) VALUE=4 ;;
	3.1) VALUE=5 ;;
	3.2) VALUE=6 ;;
	3.3) VALUE=7 ;;
	*)
		echo "Error: Voltage '$VOLTAGE' out of range. See --usage."
		exit 2
		;;
esac
axp209_write_address 0x31 0x0$VALUE
