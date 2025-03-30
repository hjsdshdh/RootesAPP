            mkdir /data/adb/modules/
            cd /data/adb/modules/
            mkdir startboot
            echo 'id=rootes
name=玩机百宝箱--扩展模块
version=v1.0.0
versionCode=100
author=玩机百宝箱
description=开机自动启动sh' > /data/adb/modules/startboot/module.prop
mkdir bootanimation_make
     echo 'id=rootes
name=玩机百宝箱--扩展模块
version=v1.0.0
versionCode=100
author=玩机百宝箱
description=开机动画' > /data/adb/modules/bootanimation_make/module.prop
mkdir /data/adb/service.d/bootanimation_make
echo '#/system/bin
MODDIR=${0%/*}
sh /data/zram.sh 
sh /data/swap.sh' >/data/adb/modules/startboot/post-fs-data.sh
echo 请您重启软件
pkill com.root.system