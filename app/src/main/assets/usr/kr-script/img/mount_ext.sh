#!/system/bin/sh

# 设置文件路径和挂载点
IMG_PATH="$test"
MOUNT_POINT="/mnt/$test1"

# 创建挂载点目录
mkdir -p "$MOUNT_POINT"

# 挂载 img 文件，假设使用 ext4 文件系统
if mount -o loop -t $test2 "$IMG_PATH" "$MOUNT_POINT"; then
    echo "成功挂载: $IMG_PATH 到 $MOUNT_POINT"
    echo $test1 >>/data/data/com.root.system/分区名称.txt
else
    echo "挂载失败"
fi