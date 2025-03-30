#本脚本由　by Han | 情非得已c，编写
#应用于玩机百宝箱上


wifi=$(pm list packages -U | grep "$package" | awk -F'uid:' '{print $2}')
File=$Data_Dir/wifi.log
wifi=$(pm list packages -U | grep "$package" | awk -F'uid:' '{print $2}')

iptables -w -D OUTPUT -t filter -m owner --uid-owner "$wifi" -j REJECT

sed -i "/$wifi/d" /data/data/com.root.system/boot.sh

         echo "已恢复了"$package""
         sed -i "/"$package"/d" $File