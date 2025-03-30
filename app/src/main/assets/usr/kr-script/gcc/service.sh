#!/system/bin/sh
MODDIR=/data/data/com.root.system/files/usr/kr-script/gcc/
wait_sys_boot_completed()
{
	while [ "$(getprop sys.boot_completed)" != "1" ]; do
		sleep 1
	done
}
revise_sys_charge_current()
{
	SYS_CHARGE_CURRENT_FILE=`ls /sys/class/power_supply/battery/*charge_current /sys/class/power_supply/battery/current_max /sys/class/power_supply/battery/thermal_input_current 2>/dev/null`
	while true; do
		if [[ "$(dumpsys battery)" == *"status: 2"* ]] || [[ "$(dumpsys battery)" == *"status: 5"* ]]; then
			for SYS_CHARGE_CURRENT in $SYS_CHARGE_CURRENT_FILE; do
				[ -z "$SYS_CHARGE_CURRENT" ] && exit 1
				if [ "$(cat $SYS_CHARGE_CURRENT)" -gt "$(getprop suto.sys_charge_current)" ]; then
					setprop suto.sys_charge_current "$(cat $SYS_CHARGE_CURRENT)"
					sed -i 's/^suto.sys_charge_current=.*/'"suto.sys_charge_current=$(cat $SYS_CHARGE_CURRENT)"'/g' ${MODDIR}/system.prop
				fi
			done
		fi
		sleep 10
	done
}
wait_sys_boot_completed && [ "$(getprop suto.bypass_charge)" ==  "Y" ] && nohup ${MODDIR}/Bypass_Charge.sh >/dev/null 2>&1 &
revise_sys_charge_current
