#本脚本由　by Han | 情非得已c，编写
#应用于搞机客上


if [[ $1 = -system ]]; then
    f=/system/etc/hosts
elif [[ $1 = -mask ]]; then
    f=$Modules_Dir/Han.GJK-MIUI/system/etc/hosts
fi
    if [[ `grep -cs update.miui.com $f` -ge 1 ]]; then
        echo 1
    fi
