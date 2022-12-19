package com.carching.carching_background_locator.pluggables

import android.content.Context
import android.os.Handler
import com.carching.carching_background_locator.IsolateHolderService
import com.carching.carching_background_locator.Keys
import com.carching.carching_background_locator.PreferencesManager
import io.flutter.plugin.common.MethodChannel

class DisposePluggable : Pluggable {
    override fun setCallback(context: Context, callbackHandle: Long) {
        PreferencesManager.setCallbackHandle(context, Keys.DISPOSE_CALLBACK_HANDLE_KEY, callbackHandle)
    }

    override fun onServiceDispose(context: Context) {
        (PreferencesManager.getCallbackHandle(context, Keys.DISPOSE_CALLBACK_HANDLE_KEY))?.let { disposeCallback ->
            val backgroundChannel = IsolateHolderService.backgroundEngine?.dartExecutor?.binaryMessenger?.let {
                MethodChannel(
                    it,
                    Keys.BACKGROUND_CHANNEL_ID)
            }
            Handler(context.mainLooper)
                .post {
                    backgroundChannel?.invokeMethod(Keys.BCM_DISPOSE,
                        hashMapOf(Keys.ARG_DISPOSE_CALLBACK to disposeCallback))
                }
        }
    }
}