curl -L https://gitee.com/rootes/scene/releases/download/1/LSPosed-v1.10.1-7115-zygisk-release.zip >/sdcard/s.txt
        echo 下载完成
       apd modules install /sdcard/s.txt > /dev/null 2>&1
       
       magisk --install-module /sdcard/s.txt > /dev/null 2>&1
       
       ksu install-module /sdcard/s.txt > /dev/null 2>&1
       echo 安装完成
       rm -rf /sdcard/s.txt