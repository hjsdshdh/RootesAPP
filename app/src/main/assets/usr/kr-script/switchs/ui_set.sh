#本脚本由　by Han | 情非得已c，编写
#应用于玩机百宝箱上


if [[ $state -eq 1 ]]; then

cmd statusbar send-disable-flag recents
echo yes >/data/data/com.root.system/.miuiui

elif [[ $state -eq 0 ]]; then
cmd statusbar send-disable-flag
rm -rf /data/data/com.root.system/.miuiui
fi
