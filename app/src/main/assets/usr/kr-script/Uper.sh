#!/bin/bash

# Meta 信息
name="玩机百宝箱 配置"
author="玩机百宝箱 配置"

# Switcher 模块
switchInode="/sdcard/Android/yc/uperf/cur_powermode.txt"
perapp="/sdcard/Android/yc/uperf/perapp_powermode.txt"
idleHintDuration=$test3           # 闲置时长提示，单位秒
touchHintDuration=$test4          # 触摸时长提示，单位秒
triggerHintDuration=$test5       # 触发时长提示，单位秒
gestureHintDuration=$test6        # 手势时长提示，单位秒
switchHintDuration=$test7        # 切换时长提示，单位秒
junkHintDuration=$test8        # 杂项时长提示，单位秒

# Atrace 模块
atraceEnable=$test9             # 是否启用 Atrace

# Log 模块
logLevel="info"                # 日志级别

# Input 模块
inputEnable=true                # 是否启用输入
swipeThd=$test12                   # 滑动阈值
gestureThdX=$test13                # 手势 X 轴阈值
gestureThdY=$test14                # 手势 Y 轴阈值
gestureDelayTime=$test15            # 手势延迟时间，单位秒
holdEnterTime=$test16               # 按住进入的时间，单位秒

# Sfanalysis 模块
sfanalysisEnable=$test17           # 是否启用 SFanalysis
renderIdleSlackTime=$test99         # 渲染空闲松弛时间，单位秒

# Cpu 模块
cpuEnable=$test18                  # 是否启用 CPU

# Power models
powerModel1=(
  efficiency=$test19                # 效率
  nr=$test20                           # NR
  typicalPower=$test21              # 典型功耗
  typicalFreq=$test22                # 典型频率
  sweetFreq=$test23                  # 优化频率
  plainFreq=$test24                  # 普通频率
  freeFreq=$test25                   # 空闲频率
)

powerModel2=(
  efficiency=$test26                # 效率
  nr=$test27                           # NR
  typicalPower=$test28               # 典型功耗
  typicalFreq=$test29                # 典型频率
  sweetFreq=$test30                  # 优化频率
  plainFreq=$test31                  # 普通频率
  freeFreq=$test32                   # 空闲频率
)

# Sysfs 模块
sysfsEnable=$test33                # 是否启用 Sysfs
cpusetTa="/dev/cpuset/top-app/cpus"                   # Top-app CPU 集
cpusetFg="/dev/cpuset/foreground/cpus"               # Foreground CPU 集
cpusetBg="/dev/cpuset/background/cpus"               # Background CPU 集
cpusetSysBg="/dev/cpuset/system-background/cpus"     # System-background CPU 集
cpusetRe="/dev/cpuset/restricted/cpus"               # Restricted CPU 集

# Sched 模块
schedEnable=$test34                # 是否启用 Sched

# CPU masks
allCores=($test35)      # 所有 CPU 核心
c0Cores=($test36)           # C0 CPU 核心
c1Cores=($test37)                   # C1 CPU 核心
c2Cores=($test38)                   # C2 CPU 核心

# 写入配置到文件
configFile="/storage/emulated/0/Android/yc/uperf/uperf.json"
echo "{
  \"meta\": {
    \"name\": \"$name\",
    \"author\": \"$author\"
  },
  \"modules\": {
    \"switcher\": {
      \"switchInode\": \"$switchInode\",
      \"perapp\": \"$perapp\",
      \"hintDuration\": {
        \"idle\": $idleHintDuration,
        \"touch\": $touchHintDuration,
        \"trigger\": $triggerHintDuration,
        \"gesture\": $gestureHintDuration,
        \"switch\": $switchHintDuration,
        \"junk\": $junkHintDuration
      }
    },
    \"atrace\": {
      \"enable\": $atraceEnable
    },
    \"log\": {
      \"level\": \"$logLevel\"
    },
    \"input\": {
      \"enable\": $inputEnable,
      \"swipeThd\": $swipeThd,
      \"gestureThdX\": $gestureThdX,
      \"gestureThdY\": $gestureThdY,
      \"gestureDelayTime\": $gestureDelayTime,
      \"holdEnterTime\": $holdEnterTime
    },
    \"sfanalysis\": {
      \"enable\": $sfanalysisEnable,
      \"renderIdleSlackTime\": $renderIdleSlackTime
    },
    \"cpu\": {
      \"enable\": $cpuEnable,
      \"powerModel\": [
        {
          \"efficiency\": ${powerModel1[0]},
        {
          \"efficiency\": ${powerModel2[0]},
          \"nr\": ${powerModel2[1]},
          \"typicalPower\": ${powerModel2[2]},
          \"typicalFreq\": ${powerModel2[3]},
          \"sweetFreq\": ${powerModel2[4]},
          \"plainFreq\": ${powerModel2[5]},
          \"freeFreq\": ${powerModel2[6]}
        }
      ]
    },
    \"sysfs\": {
      \"enable\": $sysfsEnable,
      \"knob\": {
        \"cpusetTa\": \"$cpusetTa\",
        \"cpusetFg\": \"$cpusetFg\",
        \"cpusetBg\": \"$cpusetBg\",
        \"cpusetSysBg\": \"$cpusetSysBg\",
        \"cpusetRe\": \"$cpusetRe\"
      }
    },
    \"sched\": {
      \"enable\": $schedEnable,
      \"cpumask\": {
        \"all\": [${allCores[*]}],
        \"c0\": [${c0Cores[*]}],
        \"c1\": [${c1Cores[*]}],
        \"c2\": [${c2Cores[*]}]
      },
      \"affinity\": {
        \"auto\": {
          \"bg\": \"\",
          \"fg\": \"\",
          \"idle\": \"\",
          \"touch\": \"\",
          \"boost\": \"\"
        },
        \"norm\": {
          \"bg\": \"\",
          \"fg\": \"all\",
          \"idle\": \"all\",
          \"touch\": \"all\",
          \"boost\": \"all\"
        },
        \"bg\": {
          \"bg\": \"\",
          \"fg\": \"c0\",
          \"idle\": \"c0\",
          \"touch\": \"c0\",
          \"boost\": \"c0\"
        },
        \"ui\": {
          \"bg\": \"\",
          \"fg\": \"all\",
          \"idle\": \"all\",
          \"touch\": \"c1\",
          \"boost\": \"all\"
        },
        \"crit\": {
          \"bg\": \"\",
          \"fg\": \"all\",
          \"idle\": \"all\",
          \"touch\": \"c1\",
          \"boost\": \"c1\"
        },
        \"gtcoop\": {
          \"bg\": \"\",
          \"fg\": \"all\",
          \"idle\": \"all\",
          \"touch\": \"c1\",
          \"boost\": \"all\"
        },
        \"gtmain\": {
          \"bg\": \"\",
          \"fg\": \"all\",
          \"idle\": \"all\",
          \"touch\": \"c2\",
          \"boost\": \"all\"
        }
      },
      \"prio\": {
        \"auto\": {
          \"bg\": 0,
          \"fg\": 0,
          \"idle\": 0,
          \"touch\": 0,
          \"boost\": 0
        },
        \"bg\": {
          \"bg\": -3,
          \"fg\": 139,
          \"idle\": 139,
          \"touch\": 139,
          \"boost\": 139
        },
        \"norm\": {
          \"bg\": -1,
          \"fg\": -1,
          \"idle\": 120,
          \"touch\": 120,
          \"boost\": 130
        },
        \"coop\": {
          \"bg\": -3,
          \"fg\": 124,
          \"idle\": 122,
          \"touch\": 122,
          \"boost\": 130
        },
        \"ui\": {
          \"bg\": -3,
          \"fg\": 120,
          \"idle\": 110,
          \"touch\": 98,
          \"boost\": 116
        },
        \"rtusr\": {
          \"bg\": 98,
          \"fg\": 98,
          \"idle\": 97,
          \"touch\": 97,
          \"boost\": 98
        },
        \"rtsys\": {
          \"bg\": 97,
          \"fg\": 97,
          \"idle\": 96,
          \"touch\": 96,
          \"boost\": 97
        }
      },
      \"rules\": [
        {
          \"name\": \"Launcher\",
          \"regex\": \"/HOME_PACKAGE/\",
          \"pinned\": true,
          \"rules\": [
            {
              \"k\": \"/MAIN_THREAD/\",
              \"ac\": \"crit\",
              \"pc\": \"rtusr\"
            },
            {
              \"k\": \"^(RenderThread|GLThread)\",
              \"ac\": \"crit\",
              \"pc\": \"rtusr\"
            },
            {
              \"k\": \"^(GPU completion|HWC release|hwui|FramePolicy|ScrollPolicy|ged-swd)\",
              \"ac\": \"bg\",
              \"pc\": \"rtusr\"
            },
            {
              \"k\": \".\",
              \"ac\": \"auto\",
              \"pc\": \"auto\"
            }
          ]
        },
        {
          \"name\": \"SurfaceFlinger\",
          \"regex\": \"/system/bin/surfaceflinger\",
          \"pinned\": true,
          \"rules\": [
            {
              \"k\": \"/MAIN_THREAD/\",
              \"ac\": \"crit\",
              \"pc\": \"auto\"
            },
            {
              \"k\": \"^(app|RenderEngine)\",
              \"ac\": \"crit\",
              \"pc\": \"auto\"
            },
            {
              \"k\": \"^Binder:\",
              \"ac\": \"auto\",
              \"pc\": \"auto\"
            },
            {
              \"k\": \".\",
              \"ac\": \"bg\",
              \"pc\": \"auto\"
            }
          ]
        },
        {
          \"name\": \"SystemServer\",
          \"regex\": \"system_server\",
          \"pinned\": true,
          \"rules\": [
            {
              \"k\": \"^(TaskSnapshot|Greezer|CachedApp|SystemPressure|SensorService)|[Mm]emory\",
              \"ac\": \"bg\",
              \"pc\": \"auto\"
            },
            {
              \"k\": \"^Async\",
              \"ac\": \"auto\",
              \"pc\": \"norm\"
            },
            {
              \"k\": \".\",
              \"ac\": \"auto\",
              \"pc\": \"auto\"
            }
          ]
        },
        {
          \"name\": \"SystemUI\",
          \"regex\": \"com.android.systemui\",
          \"pinned\": true,
          \"rules\": [
            {
              \"k\": \"^(Jit thread pool|HeapTaskDaemon|FinalizerDaemon|ReferenceQueueD)\",
              \"ac\": \"bg\",
              \"pc\": \"auto\"
            },
            {
              \"k\": \".\",
              \"ac\": \"auto\",
              \"pc\": \"auto\"
            }
          ]
        },
        {
          \"name\": \"MediaProvider\",
          \"regex\": \"^com.android.providers.media\",
          \"pinned\": true,
          \"rules\": [
            {
              \"k\": \".\",
              \"ac\": \"auto\",
              \"pc\": \"bg\"
            }
          ]
        },
        {
          \"name\": \"Memory reclaim\",
          \"regex\": \"swapd|compactd\",
          \"pinned\":
          true,
          \"rules\": [
            {
              \"k\": \".\",
              \"ac\": \"bg\",
              \"pc\": \"auto\"
            }
          ]
        },
        {
          \"name\": \"RcWorkQueued\",
          \"regex\": \"RcWorkQueued\",
          \"pinned\": true,
          \"rules\": [
            {
              \"k\": \".\",
              \"ac\": \"auto\",
              \"pc\": \"auto\"
            }
          ]
        },
        {
          \"name\": \"Android System\",
          \"regex\": \"android\\.server\\.am\",
          \"pinned\": true,
          \"rules\": [
            {
              \"k\": \".\",
              \"ac\": \"bg\",
              \"pc\": \"auto\"
            }
          ]
        },
        {
          \"name\": \"LowMemoryKiller\",
          \"regex\": \"LowMemoryKiller\",
          \"pinned\": true,
          \"rules\": [
            {
              \"k\": \".\",
              \"ac\": \"bg\",
              \"pc\": \"auto\"
            }
          ]
        },
        {
          \"name\": \"Runtime Restart\",
          \"regex\": \"zygote64|zygote\",
          \"pinned\": true,
          \"rules\": [
            {
              \"k\": \".\",
              \"ac\": \"bg\",
              \"pc\": \"auto\"
            }
          ]
        },
        {
          \"name\": \"HAL\",
          \"regex\": \"\\/system\\/bin\\/hwservicemanager\",
          \"pinned\": true,
          \"rules\": [
            {
              \"k\": \".\",
              \"ac\": \"auto\",
              \"pc\": \"auto\"
            }
          ]
        },
        {
          \"name\": \"Event Log\",
          \"regex\": \"logd|statsd|sdcardd|healthd\",
          \"pinned\": true,
          \"rules\": [
            {
              \"k\": \".\",
              \"ac\": \"bg\",
              \"pc\": \"auto\"
            }
          ]
        }
      ]
    }
  },
  \"output\": {
    \"configFile\": \"$configFile\"
  }
}" > "$configFile"
echo "Configuration written to $configFile"
