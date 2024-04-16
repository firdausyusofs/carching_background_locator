package com.carching.carching_background_locator.provider

import android.annotation.SuppressLint
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import com.google.android.gms.location.ActivityRecognition
import com.google.android.gms.location.ActivityRecognitionClient
import com.google.android.gms.location.ActivityRecognitionResult

class ActivityProviderClient(context: Context, override var listener: ActivityUpdateListener): BLActivityProvider {

    private var pendingIntent: PendingIntent? = null;
    private val client: ActivityRecognitionClient = ActivityRecognition.getClient(context)

    override fun removeActivityUpdates() {
        TODO("Not yet implemented")
    }

    @SuppressLint("MissingPermission")
    override fun requestActivityUpdates(context: Context) {
        pendingIntent = getPendingIntentForService(context)

        client.requestActivityUpdates(5000L, pendingIntent!!)
    }

    private fun getPendingIntentForService(context: Context): PendingIntent {
        val intent = Intent(context, ActivityCallback::class.java)
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_MUTABLE)
        } else {
            PendingIntent.getBroadcast(context, 0, intent, 0)
        }
    }

}

private class ActivityCallback: BroadcastReceiver {

    override fun onReceive(context: Context?, intent: Intent?) {
        if (ActivityRecognitionResult.hasResult(intent)) {
        }
    }

}