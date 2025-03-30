#本脚本由　by Han | 情非得已c，编写
#应用于玩机百宝箱上


if [[ $state -eq 1 ]]; then
settings put system status_bar_show_seconds 1
echo yes >/data/data/com.root.system/.sleep2

elif [[ $state -eq 0 ]]; then
settings put system status_bar_show_seconds 0
rm -rf /data/data/com.root.system/.sleep2
fi
