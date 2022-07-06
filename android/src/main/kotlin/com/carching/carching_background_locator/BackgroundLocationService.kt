package com.carching.carching_background_locator

import android.Manifest

import android.app.Activity
import android.content.*
import android.content.pm.PackageManager
import android.location.Location
import android.media.metrics.Event
import android.os.IBinder
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.Observer
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.carching.carching_background_locator.CarchingBackgroundLocatorPlugin
import com.carching.carching_background_locator.R
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.*


class BackgroundLocationService: MethodChannel.MethodCallHandler, PluginRegistry.RequestPermissionsResultListener, EventChannel.StreamHandler {
    companion object {
        const val METHOD_CHANNEL_NAME = "${CarchingBackgroundLocatorPlugin.PLUGIN_ID}/methods"
        const val EVENT_CHANNEL_NAME = "${CarchingBackgroundLocatorPlugin.PLUGIN_ID}/events"
        private const val REQUEST_PERMISSIONS_REQUEST_CODE = 34

        private var instance: BackgroundLocationService? = null

        val locationData = MutableLiveData<Location>()

        /**
         * Requests the singleton instance of [BackgroundLocationService] or creates it,
         * if it does not yet exist.
         */
        fun getInstance(): BackgroundLocationService {
            if (instance == null) {
                instance = BackgroundLocationService()
            }
            return instance!!
        }
    }


    /**
     * Context that is set once attached to a FlutterEngine.
     * Context should no longer be referenced when detached.
     */
    private var context: Context? = null
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var activity: Activity? = null
    private var isAttached = false
    private var receiver: MyReceiver? = null
    private var service: LocationUpdatesService? = null

    /**
     * Signals whether the LocationUpdatesService is bound
     */
    private var bound: Boolean = false

    private fun postInitialValue() {
        locationData.postValue(null);
    }

    private val serviceConnection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName, service: IBinder) {
            bound = true
            val binder = service as LocationUpdatesService.LocalBinder
            this@BackgroundLocationService.service = binder.service
            requestLocation()
        }

        override fun onServiceDisconnected(name: ComponentName) {
            service = null
        }
    }

    fun onAttachedToEngine(@NonNull context: Context, @NonNull messenger: BinaryMessenger) {
        this.context = context
        isAttached = true
        channel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
        channel.setMethodCallHandler(this)

        receiver = MyReceiver(null)

        eventChannel = EventChannel(messenger, EVENT_CHANNEL_NAME)
        eventChannel.setStreamHandler(this)

        postInitialValue();

        LocalBroadcastManager.getInstance(context).registerReceiver(receiver!!,
                IntentFilter(LocationUpdatesService.ACTION_BROADCAST))
    }

    fun onDetachedFromEngine() {
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        context = null
        isAttached = false
    }

    fun setActivity(binding: ActivityPluginBinding?) {
        this.activity = binding?.activity

        if(this.activity != null){
            if (Utils.requestingLocationUpdates(context!!)) {
                if (!checkPermissions()) {
                    requestPermissions()
                }
            }
        } else {
            stopLocationService()
        }
    }

    private fun startLocationService(distanceFilter: Double?, forceLocationManager : Boolean?): Int{
        LocalBroadcastManager.getInstance(context!!).registerReceiver(receiver!!,
                IntentFilter(LocationUpdatesService.ACTION_BROADCAST))

        if (!bound) {
            val intent = Intent(context, LocationUpdatesService::class.java)
            intent.putExtra("distance_filter", distanceFilter)
            intent.putExtra("force_location_manager", forceLocationManager)
            context!!.bindService(intent, serviceConnection, Context.BIND_AUTO_CREATE)
        }

        return 0
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        receiver = MyReceiver(events)
        LocalBroadcastManager.getInstance(context!!).registerReceiver(receiver!!, IntentFilter(LocationUpdatesService.ACTION_BROADCAST))
    }

    override fun onCancel(arguments: Any?) {
        print("hello $arguments")
    }

    private fun stopLocationService(): Int {
        service?.removeLocationUpdates()
        LocalBroadcastManager.getInstance(context!!).unregisterReceiver(receiver!!)

        if (bound) {
            context!!.unbindService(serviceConnection)
            bound = false
        }

        return 0
    }

    private fun setAndroidNotification(title: String?, message: String?, icon: String?):Int{
        if (title != null) LocationUpdatesService.NOTIFICATION_TITLE = title
        if (message != null) LocationUpdatesService.NOTIFICATION_MESSAGE = message
        if (icon != null) LocationUpdatesService.NOTIFICATION_ICON = icon

        if (service != null) {
            service?.updateNotification()
        }

        return 0
    }

    private fun setConfiguration(timeInterval: Long?):Int {
        if (timeInterval != null) LocationUpdatesService.UPDATE_INTERVAL_IN_MILLISECONDS = timeInterval

        return 0
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            "stop_service" -> result.success(stopLocationService())
            "start_service" -> result.success(startLocationService(call.argument("distance_filter"), call.argument("force_location_manager")))
            "set_android_notification" -> result.success(setAndroidNotification(call.argument("title"),call.argument("message"),call.argument("icon")))
            "set_configuration" -> result.success(setConfiguration(call.argument<String>("interval")?.toLongOrNull()))
            else -> result.notImplemented()
        }
    }

    /**
     * Requests a location updated.
     * If permission is denied, it requests the needed permission
     */
    private fun requestLocation() {
        if (!checkPermissions()) {
            requestPermissions()
        } else {
            service?.requestLocationUpdates()
        }
    }

    /**
     * Checks the current permission for `ACCESS_FINE_LOCATION`
     */
    private fun checkPermissions(): Boolean {
        return PackageManager.PERMISSION_GRANTED == ActivityCompat.checkSelfPermission(context!!, Manifest.permission.ACCESS_FINE_LOCATION)
    }


    /**
     * Requests permission for location.
     * Depending on the current activity, displays a rationale for the request.
     */
    private fun requestPermissions() {
        if(activity == null) {
            return
        }

        val shouldProvideRationale = ActivityCompat.shouldShowRequestPermissionRationale(activity!!, Manifest.permission.ACCESS_FINE_LOCATION)
        if (shouldProvideRationale) {
            Log.i(CarchingBackgroundLocatorPlugin.TAG, "Displaying permission rationale to provide additional context.")
            Toast.makeText(context, R.string.permission_rationale, Toast.LENGTH_LONG).show()

        } else {
            Log.i(CarchingBackgroundLocatorPlugin.TAG, "Requesting permission")
            ActivityCompat.requestPermissions(activity!!,
                    arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                    REQUEST_PERMISSIONS_REQUEST_CODE)
        }
    }



//    private inner class MyReceiver : BroadcastReceiver() {
    private inner class MyReceiver(val events: EventChannel.EventSink?) : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val location = intent.getParcelableExtra<Location>(LocationUpdatesService.EXTRA_LOCATION)
            if (location != null) {
                val locationMap = HashMap<String, Any>()
                locationMap["latitude"] = location.latitude
                locationMap["longitude"] = location.longitude
                locationMap["altitude"] = location.altitude
                locationMap["accuracy"] = location.accuracy.toDouble()
                locationMap["bearing"] = location.bearing.toDouble()
                locationMap["speed"] = location.speed.toDouble()
                locationMap["time"] = location.time.toDouble()
//                locationMap["is_mock"] = location.isFromMockProvider
                events?.success(locationMap)
                channel.invokeMethod("location", locationMap, null)
            }
        }
    }

    /**
     * Handle the response from a permission request
     * @return true if the result has been handled.
     */
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?): Boolean {
        Log.i(CarchingBackgroundLocatorPlugin.TAG, "onRequestPermissionResult")
        if (requestCode == REQUEST_PERMISSIONS_REQUEST_CODE) {
            when {
                grantResults!!.isEmpty() -> Log.i(CarchingBackgroundLocatorPlugin.TAG, "User interaction was cancelled.")
                grantResults[0] == PackageManager.PERMISSION_GRANTED -> service?.requestLocationUpdates()
                else -> Toast.makeText(context, R.string.permission_denied_explanation, Toast.LENGTH_LONG).show()
            }
        }
        return true
    }
}