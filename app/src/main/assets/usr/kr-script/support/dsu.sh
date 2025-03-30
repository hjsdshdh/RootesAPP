#!/system/bin/sh

# 获取 Android 版本号
version=$(getprop ro.build.version.sdk)

# 判断版本是否大于或等于 29
if [ "$version" -ge 29 ]; then
echo "1"
else
echo "0"
fi
