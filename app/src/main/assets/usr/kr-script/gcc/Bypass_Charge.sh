#!/system/bin/sh
MODDIR=${0%/*}
set_sys_def_scaling_governor()
{
	local i=60
	while [ $i -gt 0 ]; do
		if [ "$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_governor)" ==  "performance" ]; then
			sleep 1
			i=$(($i-1))
		else
			SYS_DEF_SCALING_GOVERNOR=`cat /sys/devices/system/cpu/cpufreq/policy0/scaling_governor`
			i=0
		fi
	done
	if [ -z "$SYS_DEF_SCALING_GOVERNOR" ]; then
		if [[ "$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors)" == *"walt"* ]]; then
			SYS_DEF_SCALING_GOVERNOR=walt
		elif [[ "$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors)" == *"schedutil"* ]]; then
			SYS_DEF_SCALING_GOVERNOR=schedutil
		elif [[ "$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors)" == *"ondemand"* ]]; then
			SYS_DEF_SCALING_GOVERNOR=ondemand
		else
			exit 1
		fi
	fi
}
revise_sys_input_charge_control_limit_max()
{
	for SYS_CHARGE_CONTROL_LIMIT in $SYS_CHARGE_CONTROL_LIMIT_FILE; do
		SYS_INPUT_CHARGE_CONTROL_LIMIT_MAX=0
		while true; do
			if [ "$SYS_INPUT_CHARGE_CONTROL_LIMIT_MAX" -gt "100" ]; then
				exit 1
			elif echo $SYS_INPUT_CHARGE_CONTROL_LIMIT_MAX > $SYS_CHARGE_CONTROL_LIMIT; then
				SYS_INPUT_CHARGE_CONTROL_LIMIT_MAX=$(($SYS_INPUT_CHARGE_CONTROL_LIMIT_MAX+1))
			else
				SYS_INPUT_CHARGE_CONTROL_LIMIT_MAX=$(($SYS_INPUT_CHARGE_CONTROL_LIMIT_MAX-1))
				BYPASS_CHARGE_OPTION=2
				return
			fi
		done
	done
}
check_bypass_charge_support()
{
	SYS_CHARGE_CURRENT_FILE=`ls /sys/class/power_supply/battery/*charge_current /sys/class/power_supply/battery/current_max /sys/class/power_supply/battery/thermal_input_current 2>/dev/null`
	SYS_CHARGE_CONTROL_LIMIT_FILE=`ls /sys/class/power_supply/battery/charge_control_limit 2>/dev/null`
	for SYS_CHARGE_CURRENT in $SYS_CHARGE_CURRENT_FILE; do
		if [ "$(cat $SYS_CHARGE_CURRENT)" -gt "$(getprop suto.sys_charge_current)" ]; then
			setprop suto.sys_charge_current "$(cat $SYS_CHARGE_CURRENT)"
		fi
	done
	if [ -z "$(getprop suto.bypass_charge_current)" ]; then
		setprop suto.bypass_charge_current "0"
	fi
	if [ "$(getprop suto.sys_charge_current)" -ge "0" ] && [ -n "$SYS_CHARGE_CURRENT_FILE" ]; then
		BYPASS_CHARGE_OPTION=1
		if [ "$(getprop suto.sys_charge_current)" == "0" ]; then
			setprop suto.sys_charge_current "5000000"
		fi
	elif [ -n "$SYS_CHARGE_CONTROL_LIMIT_FILE" ]; then
		revise_sys_input_charge_control_limit_max
	else
		exit 1
	fi
}
check_gamelist()
{
	touch $MODDIR/TempGameList.txt
	for PACKAGE_NAME in `cat $MODDIR/GameList.txt`; do
		if pm list packages | grep "$PACKAGE_NAME" >/dev/null; then
			echo -n "$PACKAGE_NAME " >> $MODDIR/TempGameList.txt
		fi
	done
	GAMELIST="$(cat $MODDIR/TempGameList.txt)"
	rm -rf $MODDIR/TempGameList.txt
	if [ -z "$GAMELIST" ]; then
		setprop suto.bypass_charge N
	else
		setprop suto.bypass_charge Y
	fi
}
performance_mode()
{
	for CPU in `ls /sys/devices/system/cpu/cpu*/online`; do
		[ -f $CPU ] && echo "1" > $CPU
	done
	for SCALING_GOVERNOR_PATH in `ls /sys/devices/system/cpu/cpufreq/policy*/scaling_governor`; do
		[[ "$(cat ${SCALING_GOVERNOR_PATH%/*}/scaling_available_governors)" == *"performance"* ]] && echo "performance" > $SCALING_GOVERNOR_PATH
	done
	if [ -f /sys/devices/system/cpu/qcom_lpm/parameters/sleep_disabled ]; then
		echo "1" > /sys/devices/system/cpu/qcom_lpm/parameters/sleep_disabled
	elif [ -f /sys/module/lpm_levels/parameters/sleep_disabled ]; then
		echo "Y" > /sys/module/lpm_levels/parameters/sleep_disabled
	fi
	for POLICY_PATH in `ls -d /sys/devices/system/cpu/cpufreq/policy*`; do
		if [ -f ${POLICY_PATH}/cpuinfo_max_freq ] && [ -f ${POLICY_PATH}/scaling_min_freq ]; then
			echo "$(cat ${POLICY_PATH}/cpuinfo_max_freq)" > ${POLICY_PATH}/scaling_min_freq
		fi
	done
}
balanced_mode()
{
	for CPU in `ls /sys/devices/system/cpu/cpu*/online`; do
		[ -f $CPU ] && echo "1" > $CPU
	done
	for SCALING_GOVERNOR_PATH in `ls /sys/devices/system/cpu/cpufreq/policy*/scaling_governor`; do
		[[ "$(cat ${SCALING_GOVERNOR_PATH%/*}/scaling_available_governors)" == *"$SYS_DEF_SCALING_GOVERNOR"* ]] && echo "$SYS_DEF_SCALING_GOVERNOR" > $SCALING_GOVERNOR_PATH
	done
	if [ -f /sys/devices/system/cpu/qcom_lpm/parameters/sleep_disabled ]; then
		echo "0" > /sys/devices/system/cpu/qcom_lpm/parameters/sleep_disabled
	elif [ -f /sys/module/lpm_levels/parameters/sleep_disabled ]; then
		echo "N" > /sys/module/lpm_levels/parameters/sleep_disabled
	fi
	for POLICY_PATH in `ls -d /sys/devices/system/cpu/cpufreq/policy*`; do
		if [ -f ${POLICY_PATH}/cpuinfo_min_freq ] && [ -f ${POLICY_PATH}/scaling_min_freq ]; then
			echo "$(cat ${POLICY_PATH}/cpuinfo_min_freq)" > ${POLICY_PATH}/scaling_min_freq
		fi
	done
}
charge_stop()
{
	
	[ "$(pidof mi_thermald)" -gt "0" ] && pgrep -f mi_thermald|xargs kill -19
	if [ "$BYPASS_CHARGE_OPTION" ==  "1" ]; then
		for SYS_CHARGE_CURRENT in $SYS_CHARGE_CURRENT_FILE; do
			if [ "$(cat $SYS_CHARGE_CURRENT)" != "$(getprop suto.bypass_charge_current)" ]; then
				chmod a+rw $SYS_CHARGE_CURRENT
				echo "$(getprop suto.bypass_charge_current)" > $SYS_CHARGE_CURRENT
				if [ "$(cat $SYS_CHARGE_CURRENT)" -gt "$(getprop suto.bypass_charge_current)" ]; then
					BYPASS_CHARGE_OPTION_WEIGHT_SUM=$(($BYPASS_CHARGE_OPTION_WEIGHT_SUM+1))
					if [ "$BYPASS_CHARGE_OPTION_WEIGHT_SUM" -gt "6" ]; then
						revise_sys_input_charge_control_limit_max
						BYPASS_CHARGE_OPTION_WEIGHT_SUM=1
					fi
				else
					BYPASS_CHARGE_OPTION_WEIGHT_SUM=1
				fi
			fi
		done
	elif [ "$BYPASS_CHARGE_OPTION" ==  "2" ]; then
		for SYS_CHARGE_CONTROL_LIMIT in $SYS_CHARGE_CONTROL_LIMIT_FILE; do
			if [ "$(cat $SYS_CHARGE_CONTROL_LIMIT)" != "$SYS_INPUT_CHARGE_CONTROL_LIMIT_MAX" ]; then
				chmod a+rw $SYS_CHARGE_CONTROL_LIMIT
				echo "$SYS_INPUT_CHARGE_CONTROL_LIMIT_MAX" > $SYS_CHARGE_CONTROL_LIMIT
				if [ "$(cat $SYS_CHARGE_CONTROL_LIMIT)" -lt "$SYS_INPUT_CHARGE_CONTROL_LIMIT_MAX" ]; then
					BYPASS_CHARGE_OPTION_WEIGHT_SUM=$(($BYPASS_CHARGE_OPTION_WEIGHT_SUM+1))
					if [ "$BYPASS_CHARGE_OPTION_WEIGHT_SUM" -gt "6" ]; then
						check_bypass_charge_support
						BYPASS_CHARGE_OPTION_WEIGHT_SUM=1
					fi
				else
					BYPASS_CHARGE_OPTION_WEIGHT_SUM=1
				fi
			fi
		done
	fi
}
charge_start()
{
	
	[ "$(pidof mi_thermald)" -gt "0" ] && pgrep -f mi_thermald|xargs kill -18
	if [ "$BYPASS_CHARGE_OPTION" == "1" ]; then
		for SYS_CHARGE_CURRENT in $SYS_CHARGE_CURRENT_FILE; do
			if [ "$(cat $SYS_CHARGE_CURRENT)" == "$(getprop suto.bypass_charge_current)" ]; then
				chmod a+rw $SYS_CHARGE_CURRENT
				echo "$(getprop suto.sys_charge_current)" > $SYS_CHARGE_CURRENT
			fi
		done
	elif [ "$BYPASS_CHARGE_OPTION" == "2" ]; then
		for SYS_CHARGE_CONTROL_LIMIT in $SYS_CHARGE_CONTROL_LIMIT_FILE; do
			if [ "$(cat $SYS_CHARGE_CONTROL_LIMIT)" == "$SYS_INPUT_CHARGE_CONTROL_LIMIT_MAX" ]; then
				chmod a+rw $SYS_CHARGE_CONTROL_LIMIT
				echo "0" > $SYS_CHARGE_CONTROL_LIMIT
			fi
		done
	fi
}
bypass_charge()
{
	if [ -n "$(getprop suto.start_bypass_charge_battery_capacity)" -a "$(dumpsys battery | grep 'level: ' | sed -n 's/.*level: //g;$p')" -ge "$(getprop suto.start_bypass_charge_battery_capacity)" ]; then
		for PACKAGE_NAME in $GAMELIST; do
			if [ "$(pidof $PACKAGE_NAME)" -gt "0" ]; then
				local i=$(pidof $PACKAGE_NAME)
				while [ "$i" -gt "0" ]; do
					sleep 2
					if [ "$(pidof $PACKAGE_NAME)" -gt "0" ]; then
						i=1
						screen_state
					else
						i=0
						charge_start
					fi
				done
			fi
		done
	fi
}
screen_state()
{
	if [ "$(getprop suto.screen_on_bypass_charge)" == "Y" ]; then
		if [[ "$(dumpsys deviceidle | grep mScreenOn)" == *"mScreenOn=true"* ]]; then
			charge_stop
		else
			charge_start
		fi
	else
		charge_stop
	fi
}
set_sys_def_scaling_governor && check_bypass_charge_support
while true; do
	dumpsys battery reset && sleep 1 && check_gamelist
	if [[ "$(dumpsys battery)" == *"status: 2"* ]] || [[ "$(dumpsys battery)" == *"status: 5"* ]]; then
		[ "$(getprop suto.powered_on_performance_enhancements)" ==  "Y" ] && performance_mode
		local i=1
		while [ "$i" -gt "0" ]; do
			sleep 1
			[ "$(getprop suto.bypass_charge)" ==  "Y" ] && bypass_charge
			BYPASS_CHARGE_OPTION_WEIGHT_SUM=1
			if [[ "$(dumpsys battery)" == *"status: 2"* ]] || [[ "$(dumpsys battery)" == *"status: 5"* ]]; then
				i=1
			else
				i=0
			fi
		done
	else
		[ "$(getprop suto.powered_on_performance_enhancements)" ==  "Y" ] && balanced_mode
		charge_start
		local i=1
		while [ "$i" -gt "0" ]; do
			sleep 6
			if [[ "$(dumpsys battery)" == *"status: 2"* ]] || [[ "$(dumpsys battery)" == *"status: 5"* ]]; then
				i=0
			else
				i=1
			fi
		done
	fi
done
