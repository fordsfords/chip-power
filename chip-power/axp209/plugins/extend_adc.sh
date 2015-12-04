# measurements in the AXP209 consume more electrical power
OSB_REGISTER=$(( `axp209_read_address 0x82` | 112))
EXTEND_ADC=`printf '0x%X' $OSB_REGISTER`
axp209_write_address 0x82 $EXTEND_ADC
echo "More ADC measurements were enabled with --extend_adc"
