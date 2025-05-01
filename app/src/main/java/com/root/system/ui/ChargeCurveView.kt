package com.root.system.ui

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.util.AttributeSet
import android.view.View
import com.root.system.R
import com.root.store.ChargeSpeedStore
import kotlin.math.max

class ChargeCurveView : View {
    private lateinit var storage: ChargeSpeedStore

    // 构造器
    constructor(context: Context) : super(context) {
        init(null, 0)
    }

    constructor(context: Context, attrs: AttributeSet) : super(context, attrs) {
        init(attrs, 0)
    }

    constructor(context: Context, attrs: AttributeSet, defStyle: Int) : super(context, attrs, defStyle) {
        init(attrs, defStyle)
    }

    private fun init(attrs: AttributeSet?, defStyle: Int) {
        invalidateTextPaintAndMeasurements()
        storage = ChargeSpeedStore(context)
    }

    private fun invalidateTextPaintAndMeasurements() {}

    fun getColorAccent(): Int {
        return resources.getColor(R.color.colorAccent)
    }

    private fun dp2px(context: Context, dpValue: Float): Int {
        val scale = context.resources.displayMetrics.density
        return (dpValue * scale + 0.5f).toInt()
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        val samples = storage.statistics()
        samples.sortBy { it.capacity }

        val pointRadius = 4f
        val paint = Paint().apply {
            strokeWidth = 2f
            isAntiAlias = true
        }

        val dpSize = dp2px(context, 1f)
        val innerPadding = dpSize * 24f

        // 修复类型不匹配：显式转换为Int
        val maxIO = samples.maxOfOrNull { it.io } ?: 0
        val maxAmpere = ((maxIO / 1000) + 1).toInt()  // 关键修复点

        val ratioX = (width - innerPadding * 2) / 100f
        val ratioY = (height - innerPadding * 2) / maxAmpere.toFloat()
        val startY = height - innerPadding

        val path = Path()
        var isFirstPoint = true

        // 绘制网格和坐标轴
        drawGrid(canvas, paint, dpSize, innerPadding, ratioX, maxAmpere, ratioY)

        // 绘制曲线
        paint.color = getColorAccent()
        samples.forEach { sample ->
            val pointX = sample.capacity * ratioX + innerPadding
            val current = sample.io / 1000f
            val pointY = startY - current * ratioY

            if (isFirstPoint) {
                path.moveTo(pointX, pointY)
                isFirstPoint = false
            } else {
                path.lineTo(pointX, pointY)
            }
            canvas.drawCircle(pointX, pointY, pointRadius, paint)
        }

        // 绘制路径
        paint.style = Paint.Style.STROKE
        paint.strokeWidth = 4f
        paint.color = Color.parseColor("#8BC34A")
        canvas.drawPath(path, paint)
    }

    private fun drawGrid(
        canvas: Canvas,
        paint: Paint,
        dpSize: Int,
        innerPadding: Float,
        ratioX: Float,
        maxAmpere: Int,
        ratioY: Float
    ) {
        val textSize = dpSize * 8.5f
        paint.textSize = textSize

        // X轴标签
        paint.textAlign = Paint.Align.CENTER
        for (point in 0..100 step 10) {
            paint.color = Color.parseColor("#888888")
            canvas.drawText(
                "$point%",
                innerPadding + point * ratioX,
                height - innerPadding + textSize + dpSize * 2,
                paint
            )
            canvas.drawCircle(
                innerPadding + point * ratioX,
                height - innerPadding,
                4f,
                paint
            )
        }

        // Y轴标签
        paint.textAlign = Paint.Align.RIGHT
        for (ampere in 0..maxAmpere) {
            if (ampere == 0) continue
            paint.color = Color.parseColor("#888888")
            canvas.drawText(
                "${ampere}A",
                innerPadding - dpSize * 4,
                innerPadding + (maxAmpere - ampere) * ratioY + textSize / 2.2f,
                paint
            )
        }
    }
}