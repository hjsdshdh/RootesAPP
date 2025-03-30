#!/bin/bash

android=$(uname -r)
cd $GJZS

magiskboot unpack "${img:="$img2"}" 

ksud boot-patch \
  -b "$img" \
  -k $GJZS/kernel \
  -o "$GJZS/KernelSU_$android.img" \
  --magiskboot $ELF3_Path/magiskboot \
  --kmi "$android" \
  -m "$img2"

echo "完成！输出路径：KernelSU_$android.img"
