import UIKit
import Flutter
import carching_background_locator

func registerPlugins(registry: FlutterPluginRegistry) -> () {
    if (!registry.hasPlugin("CarchingBackgroundLocatorPlugin")) {
        GeneratedPluginRegistrant.register(with: registry)
    }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    CarchingBackgroundLocatorPlugin.setPluginRegistrantCallback(registerPlugins)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
