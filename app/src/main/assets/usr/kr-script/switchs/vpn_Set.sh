#本脚本由　by Han | 情非得已c，编写
#应用于玩机百宝箱上


if [[ $state -eq 1 ]]; then

am start-foreground-service -n com.github.kr328.clash/com.github.kr328.clash.service.TunService

echo yes >/data/data/com.root.system/.vpn

elif [[ $state -eq 0 ]]; then

am force-stop com.github.kr328.clash

rm -rf /data/data/com.root.system/.vpn
fi
