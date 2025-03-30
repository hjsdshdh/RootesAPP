#本脚本由　by Han | 情非得已c，编写
#应用于玩机百宝箱上


if [[ $state -eq 1 ]]; then

settings put secure install_non_market_apps 1

echo yes >/data/data/com.root.system/.app

elif [[ $state -eq 0 ]]; then
settings put secure install_non_market_apps 0

rm -rf /data/data/com.root.system/.app
fi
