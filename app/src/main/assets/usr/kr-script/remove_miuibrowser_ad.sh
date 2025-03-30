#本脚本由　by Han | 情非得已c，编写
#应用于搞机客上


dir=$USER_DIR/com.android.browser/shared_prefs
DEST=$dir/environment_flag_file.xml
spFile=`find $dir -type f | head -n 1`
[[ -z $spFile ]] && abort "！未安装小米浏览器"


cat <<'Han' >$DEST
<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<map>
    <string name="environment_flag">1</string>
</map>
Han
magisk --clone-attr "$spFile" $DEST
echo "- 完成"
