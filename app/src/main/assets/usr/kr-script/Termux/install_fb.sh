rm -rf /data/data/com.termux/files/usr/etc/termux-login.sh
echo ~ >/data/data/com.termux/files/home/.config/termux/login.sh
mkdir /sdcard/.rootes
echo "
if [ -f /sdcard/.rootes/start.sh ]; then
    sh /sdcard/.rootes/start.sh
fi

" >/data/data/com.termux/files/usr/etc/termux-login.sh

chmod 777 /data/data/com.termux/files/home/.config/termux/login.sh
chmod 777 /data/data/com.termux/files/usr/etc/termux-login.sh

echo 请给Termux:API自启动权限！