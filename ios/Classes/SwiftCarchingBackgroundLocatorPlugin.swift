import Flutter
import UIKit
import CoreLocation

public class SwiftCarchingBackgroundLocatorPlugin: NSObject, FlutterPlugin, CLLocationManagerDelegate {
    static var locationManager: CLLocationManager?
    static var channel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftCarchingBackgroundLocatorPlugin()
        SwiftCarchingBackgroundLocatorPlugin.channel = FlutterMethodChannel(name: "carching_background_locator/methods", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: SwiftCarchingBackgroundLocatorPlugin.channel!)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        SwiftCarchingBackgroundLocatorPlugin.locationManager = CLLocationManager()
        SwiftCarchingBackgroundLocatorPlugin.locationManager?.delegate = self
        SwiftCarchingBackgroundLocatorPlugin.locationManager?.requestAlwaysAuthorization()
        
        SwiftCarchingBackgroundLocatorPlugin.locationManager?.allowsBackgroundLocationUpdates = true
        if #available(iOS 11.0, *) {
            SwiftCarchingBackgroundLocatorPlugin.locationManager?.showsBackgroundLocationIndicator = true
        }
        SwiftCarchingBackgroundLocatorPlugin.locationManager?.pausesLocationUpdatesAutomatically = false
        SwiftCarchingBackgroundLocatorPlugin.channel?.invokeMethod("location", arguments: "method")
        
        if (call.method == "start_service") {
            SwiftCarchingBackgroundLocatorPlugin.channel?.invokeMethod("location", arguments: "start_service")
            
            let arguments = call.arguments as? Dictionary<String, Any>
            let distanceFilter = arguments?["distance_filter"] as? Double
            SwiftCarchingBackgroundLocatorPlugin.locationManager?.distanceFilter = distanceFilter ?? 0
            
            SwiftCarchingBackgroundLocatorPlugin.locationManager?.startUpdatingLocation()
        } else if (call.method == "stop_service") {
            SwiftCarchingBackgroundLocatorPlugin.channel?.invokeMethod("location", arguments: "stop_service")
            SwiftCarchingBackgroundLocatorPlugin.locationManager?.stopUpdatingLocation()
        }
        result(true)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = [
            "speed": locations.last!.speed,
            "altitude": locations.last!.altitude,
            "latitude": locations.last!.coordinate.latitude,
            "longitude": locations.last!.coordinate.longitude,
            "accuracy": locations.last!.horizontalAccuracy,
            "bearing": locations.last!.course,
            "time": locations.last!.timestamp.timeIntervalSince1970 * 1000,
        ]
        
        SwiftCarchingBackgroundLocatorPlugin.channel?.invokeMethod("location", arguments: location)
        
    }
}
