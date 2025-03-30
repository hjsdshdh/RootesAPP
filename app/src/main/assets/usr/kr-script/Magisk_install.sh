BOOT_IMG=$img
PATCHED_IMG="$GJZS/Magisk_boot.img"
magiskboot unpack $BOOT_IMG
magiskboot cpio ramdisk.cpio "patch"
magiskboot repack $BOOT_IMG
mv new-boot.img $PATCHED_IMG

echo "修补后的boot.img已保存在 $PATCHED_IMG"
