OSB_REGISTER=$(( `axp209-read-address 0x33` & 96 ))
echo "($OSB_REGISTER /32 * 0.05) + 4.1" | bc -lq
