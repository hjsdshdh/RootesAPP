#本脚本由　by Han | 情非得已c，编写
#应用于玩机百宝箱上


if [[ $state -eq 1 ]]; then


echo yes >/data/data/com.root.system/.gsi

gsi_tool enable
elif [[ $state -eq 0 ]]; then

rm -rf /data/data/com.root.system/.gsi
gsi_tool disable
gsi_tool enable -s
gsi_tool disable
fi
