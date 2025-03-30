package com.root.system

import android.app.AlertDialog
import android.media.MediaPlayer
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import java.io.IOException

class MusicPlayer : AppCompatActivity() {

    private var mediaPlayer: MediaPlayer? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 获取传递过来的音乐路径
        val musicPath = intent.getStringExtra("music")

        if (musicPath != null) {
            playMusic(musicPath)
            showDialog()
        } else {
            Toast.makeText(this, "没有收到音乐文件路径", Toast.LENGTH_SHORT).show()
            finish() // 关闭活动
        }
    }

    private fun playMusic(musicPath: String) {
        try {
            mediaPlayer = MediaPlayer().apply {
                setDataSource(musicPath) // 设置音频文件路径
                prepare() // 准备音频
                start() // 播放音频
            }
        } catch (e: IOException) {
            e.printStackTrace()
            Toast.makeText(this, "无法播放音乐: ${e.message}", Toast.LENGTH_SHORT).show()
        }
    }

    private fun showDialog() {
        val builder = AlertDialog.Builder(this)
        builder.setTitle("正在播放音乐")
            .setMessage("音乐正在播放...")
            .setCancelable(true)
            .setNegativeButton("关闭") { dialog, _ ->
                dialog.dismiss() // 关闭对话框
                finish() // 关闭活动
            }
            .show()
    }

    override fun onDestroy() {
        super.onDestroy()
        mediaPlayer?.release() // 释放资源
        mediaPlayer = null
    }
}
