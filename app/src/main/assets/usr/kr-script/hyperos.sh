echo 正在执行修复...
echo 需要3-5分钟 

sleep 0.5

su -mm -c mount -t tmpfs tmpfs /data/adb/modules/
su -c /system/bin/restorecon -Rv -F /data
su -c umount -l /data/adb/modules/