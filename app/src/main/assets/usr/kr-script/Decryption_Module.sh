#本脚本由　by Han | 情非得已c，编写
#应用于搞机客上


[[ ! -f "$ZIPFILE" ]] && abort "！$ZIPFILE文件不存在无法解密"
echo "开始解密，请骚等……"
OutFile=${ZIPFILE%.zip}
mkch -r $TMPDIR
unzip -o "$ZIPFILE" -d $TMPDIR
cd $TMPDIR
zip -rq "$OutFile-已解密".zip ./*
rm -rf $TMPDIR
echo
echo "文件输出路径：$OutFile-已解密.zip"
