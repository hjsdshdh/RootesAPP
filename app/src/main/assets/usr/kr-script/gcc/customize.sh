SKIPUNZIP=0
check_magisk_version()
{
	ui_print "- Magisk version: $MAGISK_VER_CODE"
	ui_print "- Module version: $(grep_prop version "${TMPDIR}/module.prop")"
	if [ "$MAGISK_VER_CODE" -lt 20400 ]; then
		ui_print "*********************************************************"
		ui_print "! 请安装 Magisk v20.4+ (20400+)"
		abort    "*********************************************************"
	fi
}
gamelist()
{
	ui_print "*********************************************************"
	ui_print "游戏列表文件为：GameList.txt"
	ui_print "模块默认只添加了以下几个游戏的包名："
	for PACKAGE_NAME in `cat $MODPATH/GameList.txt`; do
		ui_print $PACKAGE_NAME
	done
	ui_print "如果上面没有您玩的游戏，可自行添加到GameList.txt中！"
	ui_print "*********************************************************"
}
check_bypass_charge_support()
{
	ui_print "*********************************************************"
	SYS_CHARGE_CURRENT_FILE=`ls /sys/class/power_supply/battery/*charge_current /sys/class/power_supply/battery/current_max /sys/class/power_supply/battery/thermal_input_current 2>/dev/null`
	SYS_CHARGE_CONTROL_LIMIT_FILE=`ls /sys/class/power_supply/battery/charge_control_limit 2>/dev/null`
	for SYS_CHARGE_CURRENT in $SYS_CHARGE_CURRENT_FILE; do
		SYSTEM_CHARGE_CURRENT=`cat $SYS_CHARGE_CURRENT`
	done
	for SYS_CHARGE_CONTROL_LIMIT in $SYS_CHARGE_CONTROL_LIMIT_FILE; do
		SYSTEM_CHARGE_CONTROL_LIMIT=`cat $SYS_CHARGE_CONTROL_LIMIT`
	done
	if [ $SYSTEM_CHARGE_CURRENT -ge "0" ] && [ -n "$SYS_CHARGE_CURRENT_FILE" ]; then
		ui_print "已正确读取到当前系统默认充电电流文件"
		ui_print "$SYS_CHARGE_CURRENT_FILE"
		if [ $SYSTEM_CHARGE_CURRENT == "0" ]; then
			ui_print "但是当前系统默认设置充电电流为值为$SYSTEM_CHARGE_CURRENT μA"
			ui_print "本模块也许支持您的设备吧Y(-_-)Y"
			echo "suto.sys_charge_current=5000000" >> $MODPATH/system.prop
		else
			ui_print "当前系统默认设置充电电流为值为$SYSTEM_CHARGE_CURRENT μA"
			ui_print "本模块完美支持您的设备Y(^_^)Y"
			echo "suto.sys_charge_current=$SYSTEM_CHARGE_CURRENT" >> $MODPATH/system.prop
		fi
		gamelist
	elif [ -n "$SYSTEM_CHARGE_CONTROL_LIMIT" ]; then
		ui_print "本模块支持您的设备Y(-_-)Y"
		ui_print "但是在你的设备上模拟旁路充电可能无法做到电流为0mA"
		gamelist
	else
		ui_print "出错了！！没有读取到系统充电电流控制文件！"
		ui_print "（┬＿┬）"
		ui_print "可能本模块暂时不支持您的设备$(getprop ro.product.manufacturer) $(getprop ro.product.model)！"
		ui_print "以下文件列表可能是您的设备正确的充电文件之一"
		ui_print "您可以将日志截图并发给我，来尝试帮助适配您的设备"
		for ALL_CHARGE_CURRENT_FILE in `ls /sys/class/power_supply/*/*current* /sys/class/power_supply/*/*limit*`; do
			ui_print "$ALL_CHARGE_CURRENT_FILE $(cat $ALL_CHARGE_CURRENT_FILE)"
		done
		abort    "*********************************************************"
	fi
}
check_magisk_version
remove_thermals
check_bypass_charge_support
set_perm_recursive "$MODPATH" 0 0 0755 0644
chmod a+x ${MODPATH}/*.sh
