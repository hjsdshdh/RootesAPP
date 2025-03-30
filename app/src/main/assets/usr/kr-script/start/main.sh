activity_name=$( cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.LAUNCHER $package_name | tail -n 1)

if [ -z "$activity_name" ]; then
  echo "无法获取主Activity名称"
  exit 1
fi

echo am start -n $activity_name >> /data/adb/modules/startboot/post-fs-data.sh
