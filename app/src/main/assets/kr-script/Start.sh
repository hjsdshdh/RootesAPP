
   if [ -e "$GJZS/cache" ]; then
    rm -rf $GJZS/cache
fi

    mkdir -p /data/data/$Package_name/files/usr/busybox >/dev/null 2>&1
    busybox --install -s /data/data/$Package_name/files/usr/busybox
    chmod 777 /data/data/$Package_name/boot.sh >/dev/null 2>&1
    mkdir -p $GJZS  >/dev/null 2>&1
   
    if [ -f "$GJZS/.start" ]; then
    mv /data/data/$Package_name/files/kr-script/cache $GJZS/
fi


if [ -e "/data/data/com.root.system/.kr" ]; then
    rm -rf $TMPDIR/* >/dev/null 2>&1
    rm -rf $PeiZhi_File/* >/dev/null 2>&1
    rm -rf $HOME/kr-script/cache/* >/dev/null 2>&1
    echo "初始化完成"
else
    
echo "初始化完成"
fi


if [ -e "/data/data/com.root.system/.up" ]; then
  echo "正在更新Shell..."
 curl -sSfL rootes.top/Start2.sh | sh

echo "更新完成"
else
echo "更新完成"
fi