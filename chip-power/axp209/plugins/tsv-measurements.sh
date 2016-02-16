(date '+%s%t'; \
$0 --temperature \
	--battery_voltage \
	--charge_current \
	--discharge_current) \
| sed -e 's, .*,,' \
| tr '\n' '\t'
echo ''
