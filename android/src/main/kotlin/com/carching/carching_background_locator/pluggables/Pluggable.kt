package com.carching.carching_background_locator.pluggables

import android.content.Context

interface Pluggable {
    fun setCallback(context: Context, callbackHandle: Long)
    fun onServiceStart(context: Context) {}
    fun onServiceDispose(context: Context) {}
}