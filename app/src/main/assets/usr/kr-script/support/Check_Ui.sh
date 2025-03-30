#本脚本由　by Han | 情非得已c，编写
#应用于玩机百宝箱上


case $(getprop ro.com.google.clientidbase) in
    A*|a*) echo "1" ;;
    *) echo "0" ;;
esac
