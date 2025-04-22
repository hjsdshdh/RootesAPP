package com.root.system

import android.content.Context

class ChargeSpeedStore(context: Context) {
    fun statistics(): MutableList<Sample> = mutableListOf()
    data class Sample(val capacity: Int = 0, val io: Int = 0)
}