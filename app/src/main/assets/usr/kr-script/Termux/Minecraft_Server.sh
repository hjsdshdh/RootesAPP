cp $PREFIX/kr-script/Termux/Minecraft.sh /data/data/com.termux/files/usr/etc/
rm -rf /data/data/com.termux/files/usr/etc/termux-login.sh
mv /data/data/com.termux/files/usr/etc/Minecraft.sh /data/data/com.termux/files/usr/etc/termux-login.sh
echo ~ >/data/data/com.termux/files/home/.config/termux/login.sh
chmod 777 /data/data/com.termux/files/home/.config/termux/login.sh
chmod 777 /data/data/com.termux/files/usr/etc/termux-login.sh
pkill com.termux
echo 正在启动
am start -n com.termux/com.termux.app.TermuxActivity