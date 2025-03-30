cd /data/data/com.root.system/files/
mkdir APY
cd /data/data/com.root.system/files/APY/
cp $img /data/data/com.root.system/files/APY/
mv *.img ap.img
magiskboot unpack ap.img
cp /data/data/com.root.system/files/usr/xbin/kpimg.img /data/data/com.root.system/files/APY

mkdir yet
kptools -p -i kernel -k kpimg.img -s $CMD -o /data/data/com.root.system/files/APY/yet/kernel
rm -rf /data/data/com.root.system/files/APY/kernel
cp /data/data/com.root.system/files/APY/yet/kernel /data/data/com.root.system/files/APY
magiskboot repack $img $GJZS/boot_new.img

echo 已经完成，请到$GJZS查看