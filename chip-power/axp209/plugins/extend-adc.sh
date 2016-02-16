# measurements in the AXP209 consume more electrical power
OSB_REGISTER=$(( `axp209-read-address 0x82` | 112))
EXTEND_ADC=`printf '0x%X' $OSB_REGISTER`
axp209-write-address 0x82 $EXTEND_ADC
echo "More ADC measurements were enabled with --extend-adc"
