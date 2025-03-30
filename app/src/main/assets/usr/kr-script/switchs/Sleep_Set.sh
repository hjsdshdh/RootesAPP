#本脚本由　by Han | 情非得已c，编写
#应用于玩机百宝箱上


if [[ $state -eq 1 ]]; then
settings put system time_12_24 24


echo yes >/data/data/com.root.system/.sleep

elif [[ $state -eq 0 ]]; then
settings put system time_12_24 12

rm -rf /data/data/com.root.system/.sleep
fi
