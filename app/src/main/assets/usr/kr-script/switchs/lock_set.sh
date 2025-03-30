#本脚本由　by Han | 情非得已c，编写
#应用于玩机百宝箱上


if [[ $state -eq 1 ]]; then
device_config put systemui nav_bar_handle_show_over_lockscreen true
echo yes >/data/data/com.root.system/.lock

elif [[ $state -eq 0 ]]; then
device_config put systemui nav_bar_handle_show_over_lockscreen false
rm -rf /data/data/com.root.system/.lock
fi
