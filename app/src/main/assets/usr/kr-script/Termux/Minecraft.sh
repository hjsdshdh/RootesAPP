echo 请骚等一会，正在安装
pkg install openjdk
pkg install wget
rm -rf /data/data/com.termux/files/usr/etc/termux-login.sh
rm -rf /data/data/com.termux/files/home/.config/termux/login.sh
cd /sdcard
mkdir Minecraft-Server
cd Minecraft-Server
wget https://piston-data.mojang.com/v1/objects/450698d1863ab5180c25d7c804ef0fe6369dd1ba/server.jar
echo 正在开启
echo eula=true >eula.txt
java -jar server.jar