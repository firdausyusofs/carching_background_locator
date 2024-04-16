package com.carching.carching_background_locator.provider

import android.content.Context

interface BLActivityProvider {

    var listener: ActivityUpdateListener

    fun removeActivityUpdates()

    fun requestActivityUpdates(context: Context)

}