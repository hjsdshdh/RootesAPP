package com.root.api

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.*
import android.util.Log
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream

class FastbootManager(private val context: Context) {
    private val usbManager = context.getSystemService(Context.USB_SERVICE) as UsbManager

    companion object {
        private const val TAG = "FastbootManager"
        private const val ACTION_USB_PERMISSION = "com.root.system.USB_PERMISSION"

        // 已知 Fastboot 模式设备的 Vendor ID 和 Product ID 列表
        private val fastbootDevices = listOf(
            Pair(0x18D1, 0x4EE0), // Google (Pixel)
            Pair(0x2A70, 0x9011), // OnePlus
            Pair(0x2717, 0xFF48), // Xiaomi
            Pair(0x12D1, 0x1057), // Huawei
            Pair(0x04E8, 0x6860)  // Samsung
            // 其他设备可以在此扩展
        )
    }

    private val permissionReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == ACTION_USB_PERMISSION) {
                val device = intent.getParcelableExtra<UsbDevice>(UsbManager.EXTRA_DEVICE)
                val granted = intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)
                if (granted && device != null) {
                    Log.d(TAG, "Permission granted for device: ${device.deviceName}")
                    callback?.invoke(device, true)
                } else {
                    Log.e(TAG, "Permission denied for device")
                    callback?.invoke(device, false)
                }
                context?.unregisterReceiver(this)
            }
        }
    }

    private var callback: ((UsbDevice?, Boolean) -> Unit)? = null

    /**
     * 自动检测所有已连接的设备
     */
    private fun listAllDevices(): List<UsbDevice> {
        val devices = usbManager.deviceList.values.toList()
        if (devices.isEmpty()) {
            Log.e(TAG, "No USB devices found")
        } else {
            for (device in devices) {
                Log.d(
                    TAG, "Device Found: ${device.deviceName} (Vendor ID: ${device.vendorId}, Product ID: ${device.productId})"
                )
            }
        }
        return devices
    }

    /**
     * 自动查找 Fastboot 模式设备（包括未知设备）
     */
    private fun findFastbootDevice(): UsbDevice? {
        val devices = listAllDevices()

        // 优先匹配已知设备
        for (device in devices) {
            if (fastbootDevices.any { it.first == device.vendorId && it.second == device.productId }) {
                Log.d(TAG, "Known Fastboot device found: ${device.deviceName}")
                return device
            }
        }

        // 如果未匹配已知设备，则返回第一个设备尝试通信
        if (devices.isNotEmpty()) {
            Log.w(TAG, "Unknown device detected, attempting with first device: ${devices[0].deviceName}")
            return devices[0]
        }

        return null
    }

    /**
     * 请求 USB 设备权限
     */
    fun requestPermission(device: UsbDevice, callback: (UsbDevice?, Boolean) -> Unit) {
        this.callback = callback
        val permissionIntent = PendingIntent.getBroadcast(
            context,
            0,
            Intent(ACTION_USB_PERMISSION),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
        val filter = IntentFilter(ACTION_USB_PERMISSION)
        context.registerReceiver(permissionReceiver, filter)
        usbManager.requestPermission(device, permissionIntent)
    }

    /**
     * 获取设备架构信息
     */
    private fun getDeviceArchitecture(): String {
        return try {
            val arch = System.getProperty("os.arch") ?: "unknown"
            Log.d(TAG, "Device Architecture: $arch")
            arch
        } catch (e: Exception) {
            Log.e(TAG, "Error getting device architecture: ${e.message}")
            "unknown"
        }
    }

    /**
     * 将文件从 assets 复制到指定路径
     */
    private fun copyFastbootFileFromAssets(arch: String): File? {
        val assetsPath = "usr/xbin/${if (arch.contains("arm64", ignoreCase = true)) "arm64" else if (arch.contains("x86", ignoreCase = true)) "x86" else "arm"}/fastboot"
        val inputStream: InputStream = context.assets.open(assetsPath)
        val outputFile = File(context.filesDir, "fastboot")
        
        try {
            val outputStream = FileOutputStream(outputFile)
            val buffer = ByteArray(1024)
            var length: Int
            while (inputStream.read(buffer).also { length = it } > 0) {
                outputStream.write(buffer, 0, length)
            }
            outputStream.flush()
            inputStream.close()
            outputStream.close()

            // 为了确保可以执行文件，设置权限
            outputFile.setExecutable(true)
            return outputFile
        } catch (e: IOException) {
            Log.e(TAG, "Error copying fastboot file: ${e.message}")
            return null
        }
    }

    /**
     * 与 USB 设备进行通信
     */
    fun communicate(device: UsbDevice, command: ByteArray): String? {
        val connection = usbManager.openDevice(device) ?: return null

        val usbInterface = device.getInterface(0)
        connection.claimInterface(usbInterface, true)

        // 假设设备的端点配置
        val endpointOut = usbInterface.getEndpoint(0) // OUT 端点
        val endpointIn = usbInterface.getEndpoint(1)  // IN 端点

        return try {
            // 发送命令
            connection.bulkTransfer(endpointOut, command, command.size, 5000)

            // 接收响应
            val buffer = ByteArray(1024)
            val receivedBytes = connection.bulkTransfer(endpointIn, buffer, buffer.size, 5000)

            if (receivedBytes > 0) {
                String(buffer, 0, receivedBytes)
            } else {
                null
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error during communication: ${e.message}")
            null
        } finally {
            connection.releaseInterface(usbInterface)
            connection.close()
        }
    }

    /**
     * 自动执行 Fastboot 命令
     */
    fun autoExecuteFastbootCommand(command: String, callback: (String?) -> Unit) {
        val arch = getDeviceArchitecture()
        val fastbootFile = copyFastbootFileFromAssets(arch)
        
        if (fastbootFile != null) {
            val device = findFastbootDevice()
            if (device != null) {
                requestPermission(device) { grantedDevice, granted ->
                    if (granted && grantedDevice != null) {
                        val response = communicate(grantedDevice, command.toByteArray())
                        callback(response)
                    } else {
                        Log.e(TAG, "Permission denied or device unavailable")
                        callback(null)
                    }
                }
            } else {
                Log.e(TAG, "No suitable device found")
                callback(null)
            }
        } else {
            Log.e(TAG, "Failed to copy fastboot file")
            callback(null)
        }
    }
}


//val fastbootManager = FastbootManager(context)

// 自动执行 Fastboot 命令

//fastbootManager.autoExecuteFastbootCommand("fastboot reboot") { response ->

// if (response != null) {

// Log.d("Fastboot", "Device Response: $response")

// } else {

// Log.e("Fastboot", "Failed to execute Fastboot command")

// }

//}