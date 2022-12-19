package com.carching.carching_background_locator.provider

interface LocationUpdateListener {
    fun onLocationUpdated(location: HashMap<Any, Any>?)
}