#本脚本由　by Han | 情非得已c，编写
#应用于玩机百宝箱上


if [[ $state -eq 1 ]]; then
device_config put launcher ENABLE_FLOATING_SEARCH_BAR true
echo yes >/data/data/com.root.system/.pixel

elif [[ $state -eq 0 ]]; then
device_config put launcher ENABLE_FLOATING_SEARCH_BAR false
rm -rf /data/data/com.root.system/.pixel
fi
