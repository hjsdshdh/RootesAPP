package com.root.api

import android.util.Log
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException
import java.util.zip.ZipEntry
import java.util.zip.ZipInputStream

object Unzip {
    
    private const val TAG = "Unzip"

    /**
     * 解压指定的 zip 文件到目标目录
     *
     * @param zipFilePath zip 文件路径
     * @param destDirPath 解压到的目标目录
     */
    fun unzip(zipFilePath: String, destDirPath: String) {
        val destDir = File(destDirPath)
        if (!destDir.exists()) {
            destDir.mkdirs()
        }

        try {
            val zipFile = FileInputStream(zipFilePath)
            val zipInputStream = ZipInputStream(zipFile)
            var entry: ZipEntry? = zipInputStream.nextEntry

            // 遍历 zip 文件中的每个条目
            while (entry != null) {
                val entryFile = File(destDir, entry.name)

                if (entry.isDirectory) {
                    // 如果是目录，创建目录
                    entryFile.mkdirs()
                } else {
                    // 如果是文件，解压文件
                    FileOutputStream(entryFile).use { output ->
                        val buffer = ByteArray(1024)
                        var len: Int
                        while (zipInputStream.read(buffer).also { len = it } != -1) {
                            output.write(buffer, 0, len)
                        }
                    }
                }

                // 继续读取下一个条目
                zipInputStream.closeEntry()
                entry = zipInputStream.nextEntry
            }
            zipInputStream.close()
            Log.d(TAG, "解压完成：$zipFilePath 到 $destDirPath")
        } catch (e: IOException) {
            Log.e(TAG, "解压过程中发生错误: ${e.message}", e)
        }
    }
}

//val zipFilePath = "/path/to/your/file.zip"  // zip 文件路径
//val destDirPath = "/path/to/destination/folder"  // 解压到的目标目录
Unzip.unzip(zipFilePath, destDirPath)