#!/bin/bash
#
# axp209.sh - monitoring AC power and lipo battery state with the AXP209
#
# Copyright (C) 2015 Winfried Trümper <pub+axp209@wt.tuxomania.net>
#
# No warranties. Use at your own risk.

AXP209_ETC="/etc/axp209"
AXP209_HOME=~/.axp209
export AXP209_ETC AXP209_HOME

test -f "$AXP209_ETC/config.sh" \
&& source "$AXP209_ETC/config.sh"

test -f "$AXP209_HOME/config.sh" \
&& source "AXP209_HOME/config.sh"


axp209_read_address() {
	i2cget -f -y 0 0x34 $@
}

axp209_write_address() {
	i2cset -f -y 0 0x34 $@
}

axp209_2byte_register_value() {
	MSB_REGISTER=$(( `axp209_read_address $1` ))
	LSB_REGISTER=$(( `axp209_read_address $2` ))
	LBIT_MASK=$(( 1 << $3 ))
	VALUE=$(( ($MSB_REGISTER * $LBIT_MASK) | (($LSB_REGISTER & 240) / $LBIT_MASK) ))
	RESULT=`printf "$5\n" "$VALUE" | bc -lq`
	echo "$RESULT $4"
}

axp209_bit_register_value() {
	OSB_REGISTER=$(( `axp209_read_address $1` ))
	BIT_MASK=$(( 1 << $2 ))
	echo $(( ($OSB_REGISTER & $BIT_MASK) / $BIT_MASK ))
}

axp209_events_base() {
	test -d $AXP209_HOME \
	|| mkdir --mode 2750 $AXP209_HOME \
	|| exit 2
}


VERBOSE=0
RC_EXIT=0
while test "$#" -gt 0
do
	SETTING="$1"
	shift
	test $VERBOSE -gt 0 && printf '%-23s = ' "$SETTING"

	case $SETTING in
		--temperature)
			axp209_2byte_register_value 0x5E 0x5F 4 oC '%d * 0.1 - 144.7'
			;;
		--ac_voltage)
			axp209_2byte_register_value 0x56 0x57 4 mV '%d * 1.7'
			;;
		--vbus_power)
			axp209_read_address 0x30
			;;
		--blink)
			for i in `seq 1 10`;
			do
				axp209_write_address 0x93 0x01
				sleep .5
				axp209_write_address 0x93 0x00
				sleep .5
			done
			;;
		--no_limit)
			axp209_write_address 0x30 0x03
			;;
		--fuel_gauge)
			axp209_read_address 0xB9
			;;
		--shutdown_voltage)
			axp209_read_address 0x46
			;;
		--read_shutdown)
			axp209_read_address 0x32
			;;
		--shutdown)
			axp209_write_address 0x32 0xC6
			;;
		--set_500ma)
			axp209_write_address 0x30 0x61
			;;
		--no_voltage_drop)
			axp209_write_address 0x30 0x35
			;;
		--ac_current)
			axp209_2byte_register_value 0x58 0x59 4 mA '%d * 0.625'
			;;
		--battery_voltage)
			axp209_2byte_register_value 0x78 0x79 4 mV '%d * 1.1'
			;;
		--charge_current)
			axp209_2byte_register_value 0x7A 0x7B 4 mA '%d * 0.5'
			;;
		--discharge_current)
			axp209_2byte_register_value 0x7C 0x7D 5 mA '%d * 0.5'
			;;

		--ac_present)
			axp209_bit_register_value 0x00 7
			;;
		--reg_0x00_bit2)
			axp209_bit_register_value 0x00 2
			;;
		--battery_charging)
			axp209_bit_register_value 0x01 6
			;;
		--battery_connected)
			axp209_bit_register_value 0x01 5
			;;

		--verbose)
			VERBOSE="1"
			;;

		--version)
			VERSION="1.2"
			echo "$VERSION"
			;;
		--help)
			echo "Monitor AC power and lipo battery state with the AXP209."
			echo "No warranties. Use at your own risk"
			echo "For usage see $0 --usage"

			if ! hash -t i2cget
			then
				echo "Error: it seems you need to run 'apt-get install i2c-tools'"
				exit 2
			fi
			;;

		start|stop|restart)
			exec $0 --events-all $SETTING
			;;

		--*)
			FOUND="0"
			for PLUGIN in \
				"$AXP209_ETC/plugins/${SETTING:2}.sh" \
				"$AXP209_HOME/plugins/${SETTING:2}.sh"
			do
				test -f "$PLUGIN" || continue
				source "$PLUGIN" \
				|| RC_EXIT="$?"
				FOUND="1"
				break
			done

			if test "$FOUND" -ne 1
			then
				echo "Error: cannot find the plugin ${SETTING:2}.sh in $AXP209_ETC/plugins"
				echo "or in $AXP209_HOME/plugins"
				exit 2
			fi
			;;
		*)
			echo "Invalid setting '$SETTING'"
			RC_EXIT=2
			;;
	esac
done
exit $RC_EXIT

# History:
# 2015-02-23 1.0 Initial public version
# 2015-02-24 1.1 trigger_command.sh was replaced with edge_trigger.sh (incompatible)
#                added --g/set_battery_target_voltage
#                added --capacity_guess
#                added --boot
# 2015-02-25 1.2 removed --boot
#                added --apply_profile
#                added plugin system
#                added --capacity_guess
