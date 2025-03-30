package com.root.system.popup

import android.app.Service
import android.content.Intent
import android.graphics.PixelFormat
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.media.MediaRecorder
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.util.DisplayMetrics
import android.view.*
import android.widget.TextView
import android.widget.Toast
import androidx.core.content.ContextCompat
import com.root.system.R
import java.io.File
import java.util.*
import android.hardware.display.DisplayManager

class FloatingWindowService : Service() {

    private lateinit var windowManager: WindowManager
    private lateinit var floatingView: View
    private lateinit var recordTimer: TextView
    private var isRecording = false
    private var handler = Handler()
    private var timerRunnable: Runnable? = null
    private var seconds = 0

    private lateinit var mediaProjectionManager: MediaProjectionManager
    private var mediaProjection: MediaProjection? = null
    private lateinit var mediaRecorder: MediaRecorder

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()

        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager

        val inflater = LayoutInflater.from(this)
        floatingView = inflater.inflate(R.layout.floating_window_layout, null)
        recordTimer = floatingView.findViewById(R.id.recordTimer)

        mediaProjectionManager = getSystemService(MEDIA_PROJECTION_SERVICE) as MediaProjectionManager

        val layoutFlag = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        } else {
            WindowManager.LayoutParams.TYPE_PHONE
        }

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            layoutFlag,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        )

        params.gravity = Gravity.TOP or Gravity.START
        params.x = 0
        params.y = 100

        windowManager.addView(floatingView, params)

        floatingView.setOnTouchListener(object : View.OnTouchListener {
            private var lastAction: Int = 0
            private var initialX: Int = 0
            private var initialY: Int = 0
            private var initialTouchX: Float = 0.toFloat()
            private var initialTouchY: Float = 0.toFloat()
            private var downTime: Long = 0

            override fun onTouch(v: View, event: MotionEvent): Boolean {
                when (event.action) {
                    MotionEvent.ACTION_DOWN -> {
                        initialX = params.x
                        initialY = params.y
                        initialTouchX = event.rawX
                        initialTouchY = event.rawY
                        lastAction = event.action
                        downTime = System.currentTimeMillis() // 记录按下的时间
                        return true
                    }
                    MotionEvent.ACTION_UP -> {
                        val upTime = System.currentTimeMillis()
                        if (upTime - downTime >= 3000) { // 长按3秒
                            if (!isRecording) {
                                startRecording()
                            }
                        } else if (lastAction == MotionEvent.ACTION_DOWN) {
                            if (isRecording) {
                                stopRecording()
                            } else {
                                takeScreenshot()
                            }
                        }
                        lastAction = event.action
                        return true
                    }
                    MotionEvent.ACTION_MOVE -> {
                        params.x = initialX + (event.rawX - initialTouchX).toInt()
                        params.y = initialY + (event.rawY - initialTouchY).toInt()
                        windowManager.updateViewLayout(floatingView, params)
                        lastAction = event.action
                        return true
                    }
                }
                return false
            }
        })
    }
    
private fun takeScreenshot() {
    // 隐藏悬浮窗
    floatingView.visibility = View.GONE

    // 使用 screencap 进行截图
    val screenshotFile = File(getExternalFilesDir(null), "screenshot_${UUID.randomUUID()}.png")
    val command = "screencap -p ${screenshotFile.absolutePath}"

    try {
        Runtime.getRuntime().exec(arrayOf("su", "-c", command))
        Toast.makeText(this, "截图中...", Toast.LENGTH_SHORT).show()
    } catch (e: Exception) {
        Toast.makeText(this, "截图失败: ${e.message}", Toast.LENGTH_SHORT).show()
        e.printStackTrace()
    }

    // 延迟2秒后重新显示悬浮窗，并提示截图保存成功
    handler.postDelayed({
        floatingView.visibility = View.VISIBLE
        Toast.makeText(this, "截图已保存到: ${screenshotFile.absolutePath}", Toast.LENGTH_SHORT).show()
    }, 2000)
}

    
    

    private fun startRecording() {
        // 请求用户授权录屏
        val screenCaptureIntent = mediaProjectionManager.createScreenCaptureIntent()
        screenCaptureIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(screenCaptureIntent)
    }

    private fun startMediaProjection(resultCode: Int, data: Intent) {
        mediaProjection = mediaProjectionManager.getMediaProjection(resultCode, data)
        mediaRecorder = MediaRecorder()

        val metrics = DisplayMetrics()
        windowManager.defaultDisplay.getMetrics(metrics)
        val screenDensity = metrics.densityDpi

        mediaRecorder.setAudioSource(MediaRecorder.AudioSource.MIC)
        mediaRecorder.setVideoSource(MediaRecorder.VideoSource.SURFACE)
        mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
        mediaRecorder.setOutputFile(File(getExternalFilesDir(null), "recorded_video.mp4").absolutePath)
        mediaRecorder.setVideoSize(metrics.widthPixels, metrics.heightPixels)
        mediaRecorder.setVideoEncoder(MediaRecorder.VideoEncoder.H264)
        mediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB)
        mediaRecorder.setVideoEncodingBitRate(512 * 1000)
        mediaRecorder.setVideoFrameRate(30)
        mediaRecorder.prepare()

        val surface = mediaRecorder.surface
        mediaProjection?.createVirtualDisplay(
            "FloatingWindowService",
            metrics.widthPixels,
            metrics.heightPixels,
            screenDensity,
            DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
            surface,
            null,
            null
        )

        mediaRecorder.start()
        isRecording = true
        floatingView.findViewById<TextView>(R.id.icon).visibility = View.GONE
        recordTimer.visibility = View.VISIBLE
        startTimer()

        Toast.makeText(this, "开始录屏", Toast.LENGTH_SHORT).show()
    }

    private fun stopRecording() {
        // 停止录屏
        mediaRecorder.stop()
        mediaRecorder.reset()
        mediaProjection?.stop()
        isRecording = false

        handler.removeCallbacks(timerRunnable!!)

        floatingView.findViewById<TextView>(R.id.icon).visibility = View.VISIBLE
        recordTimer.visibility = View.GONE
        Toast.makeText(this, "录屏已暂停", Toast.LENGTH_SHORT).show()
    }

    private fun startTimer() {
        seconds = 0
        timerRunnable = object : Runnable {
            override fun run() {
                val minutes = seconds / 60
                val secs = seconds % 60
                val time = String.format("%02d:%02d", minutes, secs)
                recordTimer.text = time
                seconds++
                handler.postDelayed(this, 1000)
            }
        }
        handler.post(timerRunnable!!)
    }

    override fun onDestroy() {
        super.onDestroy()
        if (::floatingView.isInitialized) {
            windowManager.removeView(floatingView)
        }
        timerRunnable?.let {
            handler.removeCallbacks(it)
        }
    }
}
