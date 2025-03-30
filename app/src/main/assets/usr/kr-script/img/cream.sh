#!/system/bin/sh

# 设置文件路径和大小
IMG_PATH="/data/玩机百宝箱.img"
IMG_SIZE="$test"  # 可以根据需要调整大小

# 创建空的 img 文件
if [ ! -e "$IMG_PATH" ]; then
    dd if=/dev/zero of="$IMG_PATH" bs=1M count=0 seek=$(echo "$IMG_SIZE" | tr -d 'M')
    echo "生成 img 文件: $IMG_PATH, 大小: $IMG_SIZE"
    mkfs.ext4 /data/玩机百宝箱.img
else
    echo "文件已经存在: $IMG_PATH"
fi

echo 完成