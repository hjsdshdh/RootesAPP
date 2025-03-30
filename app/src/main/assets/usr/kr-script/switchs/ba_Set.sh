#本脚本由　by Han | 情非得已c，编写
#应用于玩机百宝箱上


if [[ $state -eq 1 ]]; then
content insert --uri content://settings/system --bind name:s:status_bar_show_battery_percent --bind value:i:1
echo yes >/data/data/com.root.system/.ba

elif [[ $state -eq 0 ]]; then
content insert --uri content://settings/system --bind name:s:status_bar_show_battery_percent --bind value:i:0
rm -rf /data/data/com.root.system/.ba
fi
