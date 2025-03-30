package com.root.api

import android.content.Context
import android.util.Log
import android.widget.Toast
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

object DownloadFile {

    private const val TAG = "DownloadFile"

    /**
     * 下载文件并保存到指定路径
     *
     * @param context 应用的 Context，用于显示 Toast
     * @param fileUrl 下载文件的 URL
     * @param savePath 文件保存的路径
     */
    fun downloadFile(context: Context, fileUrl: String, savePath: String) {
        val client = OkHttpClient()

        // 创建一个请求对象
        val request = Request.Builder()
            .url(fileUrl)
            .build()

        // 启动协程在后台线程下载文件
        GlobalScope.launch(Dispatchers.IO) {
            try {
                // 显示 "正在下载"
                showToast(context, "正在下载...")

                // 使用 OkHttp 执行请求
                val response: Response = client.newCall(request).execute()

                if (response.isSuccessful) {
                    // 下载成功，写入文件
                    val file = File(savePath)
                    FileOutputStream(file).use { outputStream ->
                        response.body?.byteStream()?.copyTo(outputStream)
                    }
                    // 显示下载完成
                    showToast(context, "下载完成")
                    Log.d(TAG, "文件已成功下载并保存到: $savePath")
                } else {
                    // 下载失败
                    showToast(context, "下载失败: ${response.message}")
                    Log.e(TAG, "下载文件失败: ${response.message}")
                }
            } catch (e: IOException) {
                // 下载过程中发生错误
                showToast(context, "下载失败: ${e.message}")
                Log.e(TAG, "下载文件时发生错误: ${e.message}", e)
            }
        }
    }

    /**
     * 在主线程显示 Toast
     */
    private fun showToast(context: Context, message: String) {
        // 使用主线程显示 Toast
        GlobalScope.launch(Dispatchers.Main) {
            Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
        }
    }
}

//val fileUrl = "https://example.com/path/to/your/file.zip"  // 要下载的文件 URL
//val savePath = "/path/to/save/file.zip"  // 文件保存路径
//Downlo