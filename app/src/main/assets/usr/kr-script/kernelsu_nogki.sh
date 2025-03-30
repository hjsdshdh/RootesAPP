#!/bin/bash

mkdir -p "$GJZS/kernelsu"

magiskboot unpack "${img:="$img2"}"

cp -f "${kernel1:="$kernel2"}" "$HOME"
cp -f "${kernel12:="$kernel2"}" "$HOME"

cd "$HOME" || exit

rm -rf "$HOME/kernel"
mv *.kernel kernel

magiskboot repack "${img:="$img2"}" boot.img

cp -f "$HOME/boot.img" "$GJZS/kernelsu"

sleep 1
rm -rf "$GJZS/kernel"
rm -rf "$HOME/ramdisk.cpio"
rm -rf "$HOME/dtb"
rm -rf "$HOME/"*.img
rm -rf "$HOME/kernel"

echo "完成！"
