# 获取应用 APK 路径
app2=$(pm path "$app" | sed 's/package://')

# 检查是否能获取到 APK 文件路径
if [ -z "$app2" ]; then
    echo "未能找到应用 $app 的 APK 路径，请检查应用包名是否正确。"
    exit 1
fi

# 确认 APK 文件是否存在
if [ ! -f "$app2" ]; then
    echo "找不到文件 $app2。请检查路径是否正确。"
    exit 1
fi

# 复制 APK 到临时目录
cp "$app2" /data/local/tmp/app

# 检查复制操作是否成功
if [ $? -ne 0 ]; then
    echo "复制文件失败，请检查文件权限或路径是否正确。"
    exit 1
fi

# 安装 APK
if pm install --user 999 /data/local/tmp/app; then
    echo "应用安装成功。"
else
    echo "应用安装失败。请检查设置中是否启用了分身功能。"
fi

# 清理临时文件
rm -rf /data/local/tmp/app