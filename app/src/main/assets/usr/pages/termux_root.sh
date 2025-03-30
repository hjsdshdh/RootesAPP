if [ -f /sdcard/yes_termux ]; then
    sh /sdcard/s.sh
else
cat <<Han
<?xml version="1.0" encoding="utf-8"?>
<resource dir="file:///android_asset/Configuration_File" />
<resource dir="file:///android_asset/samples" />
<resource dir="file:///android_asset/usr/pages/display" />
<group>
        <text>
            <title>没有安装必要软件</title>
        </text>
        
      <page link="https://git">
        <title>安装Termux:API（必要）</title>
    </page>
    
    <action>
        <title>安装环境</title>
        <set>cp /data/data/$Package_name/files/usr/kr-script/Termux/install_fb.sh /sdcard/
        echo 请复制粘贴到Termux
        echo sh /sdcard/install_fb.sh</set>
    </action>
</group>
Han
fi