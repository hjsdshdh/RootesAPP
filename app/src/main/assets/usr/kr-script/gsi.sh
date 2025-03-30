# Power by 玩机百宝箱
GSI_IMAGE_PATH="/sdcard/dsu.gz"

if [ ! -f "$SYSTEM_IMAGE_PATH" ]; then
    echo "找不到 system_raw.img 文件: $SYSTEM_IMAGE_PATH"
    exit 1
fi

echo "正在将 system_raw.img 压缩为 dsu.gz..."
gzip -c "$SYSTEM_IMAGE_PATH" > "$GSI_IMAGE_PATH"

if [ $? -eq 0 ]; then
    echo "压缩成功: $GSI_IMAGE_PATH"
else
    echo "压缩失败。"
    exit 1
fi

SYSTEM_SIZE=$(du -b "$SYSTEM_IMAGE_PATH" | cut -f1)


echo "启动 DSU 安装..."
am start-activity \
    -n com.android.dynsystem/com.android.dynsystem.VerificationActivity \
    -a android.os.image.action.START_INSTALL \
    -d file://"$GSI_IMAGE_PATH" \
    --el KEY_SYSTEM_SIZE "$SYSTEM_SIZE" \
    --el KEY_USERDATA_SIZE "$USERDATA_SIZE"

if [ $? -eq 0 ]; then
    echo "DSU安装已启动，请查看设备上的提示进行操作。"
else
    echo "DSU安装失败。"
    exit 1
fi
