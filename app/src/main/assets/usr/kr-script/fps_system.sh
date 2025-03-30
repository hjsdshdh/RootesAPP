echo "service call SurfaceFlinger 1035 i32 $test" >>/data/data/com.root.system/boot.sh
            chmod 777 /data/data/com.root.system/boot.sh
            settings put system peak_refresh_rate $test
settings put secure miui_refresh_rate $test
settings put secure user_refresh_rate $test
            service call SurfaceFlinger 1035 i32 $test >/dev/null 2>&1