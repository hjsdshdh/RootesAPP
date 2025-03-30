package com.root.krscript.model

interface AutoRunTask {
    fun onCompleted(result: Boolean?)
    val key: String?
}
