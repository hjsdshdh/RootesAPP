#!/system/bin/sh

# 设置文件路径和挂载点
IMG_PATH="/data/玩机百宝箱.img"
MOUNT_POINT="/mnt/rootes"

# 创建挂载点目录
mkdir -p "$MOUNT_POINT"

# 挂载 img 文件，假设使用 ext4 文件系统
if mount -o loop -t ext4 "$IMG_PATH" "$MOUNT_POINT"; then
umount -lf /mnt/rootes
rm -rf /mnt/rootes/
    echo "成功挂载: $IMG_PATH 到 $MOUNT_POINT"
else
    echo "挂载失败"
fi