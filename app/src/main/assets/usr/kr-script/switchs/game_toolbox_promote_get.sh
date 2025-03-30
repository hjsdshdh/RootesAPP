#本脚本由　by Han | 情非得已c，编写
#应用于搞机客上


a=`grep '^Han$' $Game_Toolbox_File`
if [[ -n $a ]]; then
    echo false
else
    echo true
fi
