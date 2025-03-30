# 由玩机百宝箱支持

if [ ! -f "$OTA_FILE" ]; then
    echo "OTA更新包不存在: $OTA_FILE"
    exit 1
fi

echo "启动 update_engine 服务..."
start update_engine

if [ $? -ne 0 ]; then
    echo "启动 update_engine 失败。"
    exit 1
fi

echo "开始 A/B 更新..."
update_engine_client --update --payload="$OTA_FILE"

if [ $? -eq 0 ]; then
    echo "更新成功启动。请等待更新完成并重启设备。"
else
    echo "更新失败。"
    exit 1
fi
