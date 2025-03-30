#本脚本由　by Han | 情非得已c，编写
#应用于玩机百宝箱上


LN=`which ln`
RM=`which rm`

mask -v
dir=`dirname $Magisk`
if [[ $Option -eq 0 ]]; then
    echo ""$Magisk su -c "$LN -sf $Magisk $dir/su""" >> /data/adb/modules/startboot/service.sh
    echo "- 已临时隐藏了Magisk ROOT，已立即生效"
else
    $Magisk su -c "$RM -f $dir/su"
    echo "- 已永久隐藏了Magisk ROOT，已立即生效"
fi
