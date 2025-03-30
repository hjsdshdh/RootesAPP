#本脚本由　by Han | 情非得已c，编写
#应用于搞机助手上


if [[ $APK = HeiYu ]]; then
    echo "正在激活黑阈"
    sh /data/data/me.piebridge.brevent/brevent.sh
    
elif [[ $APK = XiaoHeiWu ]]; then
    echo "正在激活小黑屋"
    sh /sdcard/Android/data/web1n.stopapp/files/demon.sh
    
elif [[ $APK = Shizuku ]]; then
    echo "正在激活Shizuku"
    sh /sdcard/Android/data/moe.shizuku.privileged.api/files/start.sh || sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh
    
elif [[ $APK = IceBox ]]; then
    echo "正在激活冰箱"
    sh /sdcard/Android/data/com.catchingnow.icebox/files/start.sh
    
elif [[ $APK = apkinstaller ]]; then
    echo "正在激活安装狮 - 静默安装-DPM模式"
    dpm set-device-owner com.modosa.apkinstaller/.receiver.AdminReceiver
    
elif [[ $APK = dpmapkinstaller ]]; then
    echo "正在激活安装狮-DPM"
    dpm set-device-owner com.modosa.dpmapkinstaller/.receiver.AdminReceiver
    
elif [[ $APK = taichi ]]; then
    echo "正在激活太极阴阳之门"
    dpm set-device-owner me.weishu.exp/.DeviceAdmin
    
elif [[ $APK = IceBox ]]; then
    echo "正在使用快否激活器激活「快否」"
    sh /storage/emulated/0/Android/data/cn.endureblaze.activatebenchaf/files/Run.sh
    
elif [[ $APK = AutoHz ]]; then
    echo "正在激活「AutoHz」"
    pm grant com.arter97.auto90 android.permission.WRITE_SECURE_SETTINGS
    
elif [[ $APK = PermissionDog ]]; then
    echo "正在激活权限狗 AppOps"
    sh /storage/emulated/0/Android/data/com.web1n.permissiondog/files/starter.sh
    
elif [[ $APK = AirFrozen ]]; then
    echo "正在激活AirFrozen（空调狗）"
    dpm set-device-owner me.yourbay.airfrozen/me.yourbay.airfrozen.main.core.mgmt.MDeviceAdminReceiver
    
elif [[ $APK = Tasker ]]; then
    echo "正在激活Tasker"
    pm grant net.dinglisch.android.taskerm android.permission.READ_LOGS
    am force-stop net.dinglisch.android.taskerm
    
elif [[ $APK = One_Plus ]]; then
    settings put global oneplus_screen_refresh_rate 0
    echo "已激活一加隐藏的屏幕刷新率选项"
    echo "请前往，设置-->显示-->屏幕刷新率重新设置即可"
    
elif [[ $APK = Samsung_Small_white_strip_enable ]]; then
    cmd overlay enable com.samsung.internal.systemui.navbar.gestural_no_hint
    echo "已启用三星设备小白条沉浸"
    
elif [[ $APK = Samsung_Small_white_strip_disable ]]; then
    cmd overlay disable com.samsung.internal.systemui.navbar.gestural_no_hint
    echo "已禁用三星设备小白条沉浸"
    
elif [[ $APK = Freeform_ON ]]; then
    echo "正在开启Freeform（多窗口模式）"
    settings put global enable_freeform_support 1
    
elif [[ $APK = Freeform_OFF ]]; then
    echo "正在关闭Freeform（多窗口模式）"
    settings put global enable_freeform_support 0
fi
