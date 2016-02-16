OSB_REGISTER=$(( `axp209-read-address 0x31` & 7 ))
echo "($OSB_REGISTER * 0.1) + 2.6" | bc -lq
