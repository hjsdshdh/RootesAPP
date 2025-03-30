package com.root.system.activities

import android.graphics.Color
import android.os.Bundle
import android.util.DisplayMetrics
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import kotlin.random.Random
import com.root.system.R
import android.view.View

class ActivityTestColor : AppCompatActivity() {
    private lateinit var rootLayout: LinearLayout
    private lateinit var screenInfoTextView: TextView
    private val colors = listOf(
        Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW, Color.CYAN,
        Color.MAGENTA, Color.LTGRAY, Color.DKGRAY, Color.WHITE, Color.BLACK
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.decorView.systemUiVisibility = (View.SYSTEM_UI_FLAG_FULLSCREEN
                or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY)
        
        setContentView(R.layout.activity_test_color)

        rootLayout = findViewById(R.id.root_layout)
        screenInfoTextView = findViewById(R.id.tv_screen_info)

        // 显示屏幕信息
        displayScreenInfo()

        // 设置点击事件监听器来切换背景颜色
        rootLayout.setOnClickListener {
            changeBackgroundColor()
        }
    }

    private fun displayScreenInfo() {
        val metrics = DisplayMetrics()
        windowManager.defaultDisplay.getMetrics(metrics)
        val width = metrics.widthPixels
        val height = metrics.heightPixels
        val density = metrics.densityDpi

        screenInfoTextView.text = "分辨率: ${width}x${height}\nDPI: $density"
    }

    private fun changeBackgroundColor() {
        val randomColor = colors[Random.nextInt(colors.size)]
        rootLayout.setBackgroundColor(randomColor)
    }
}
