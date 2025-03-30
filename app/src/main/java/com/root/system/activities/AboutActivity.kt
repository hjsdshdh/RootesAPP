package com.root.system.activities

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.root.system.BuildConfig
import com.root.system.R

class ActivityAbout : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_about)

        // 获取控件
        val compileTimeTextView: TextView = findViewById(R.id.compile_time)
        val compileHostTextView: TextView = findViewById(R.id.compile_host)
        val compileProcessorTextView: TextView = findViewById(R.id.compile_processor)
        val compileSystemTextView: TextView = findViewById(R.id.compile_system)

        // 设置显示信息
        compileTimeTextView.text = "编译时间: ${BuildConfig.BUILD_TIME}"
        compileHostTextView.text = "编译主机: ${BuildConfig.BUILD_HOST}"
        compileProcessorTextView.text = "编译主机处理器: ${BuildConfig.BUILD_PROCESSOR}"
        compileSystemTextView.text = "编译主机系统: ${BuildConfig.BUILD_SYSTEM}"
    }
}
