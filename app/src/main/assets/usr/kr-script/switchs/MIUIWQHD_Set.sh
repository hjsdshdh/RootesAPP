#本脚本由　by Han | 情非得已c，编写
#应用于玩机百宝箱上


if [[ $state -eq 1 ]]; then
echo yes >/data/data/com.root.system/.WQHD 

setprop persist.sys.miui_resolution 1440,3200,560 & settings put system miui_screen_compat 1 & service call SurfaceFlinger 1035 i32 1


elif [[ $state -eq 0 ]]; then
setprop persist.sys.miui_resolution 1440,3200,560 & settings put system miui_screen_compat 0 & service call SurfaceFlinger 1035 i32 1
rm -rf /data/data/com.root.system/.WQHD 
fi
