package com.example.carching_background_locator

import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.location.*
import android.util.Log
import android.widget.Toast
import androidx.core.app.ActivityCompat
import com.example.carching_background_locator.BackgroundLocationService
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import java.util.jar.Manifest

/** CarchingBackgroundLocatorPlugin */
class CarchingBackgroundLocatorPlugin: FlutterPlugin, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity

  companion object {
    @SuppressWarnings("deprecation")
//    @JvmStatic
    fun registerWith(registrar: PluginRegistry.Registrar) {
      val service = BackgroundLocationService.getInstance()
      service.onAttachedToEngine(registrar.context(), registrar.messenger())
      registrar.addRequestPermissionsResultListener(service)
    }

    const val TAG = "com.carching.Log.Tag"
    const val PLUGIN_ID = "carching_background_locator"
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    BackgroundLocationService.getInstance().onAttachedToEngine(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    BackgroundLocationService.getInstance().onDetachedFromEngine()
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    val service = BackgroundLocationService.getInstance()
    service.setActivity(binding)
    binding.addRequestPermissionsResultListener(service)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    this.onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    BackgroundLocationService.getInstance().setActivity(null)
  }
}
