#本脚本由　by Han | 情非得已c，编写
#应用于玩机百宝箱上


if [[ $state -eq 1 ]]; then

settings put secure accessibility_enabled 1
echo yes >/data/data/com.root.system/.root

elif [[ $state -eq 0 ]]; then


settings put secure accessibility_enabled 0
rm -rf /data/data/com.root.system/.root
fi
