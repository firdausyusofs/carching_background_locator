
import 'dart:async';
import 'dart:io';

import 'package:carching_background_locator/location.dart';
import 'package:flutter/services.dart';

class CarchingBackgroundLocator {
  static const MethodChannel _channel = MethodChannel('carching_background_locator/methods');
  static const EventChannel _eventChannel = EventChannel('carching_background_locator/events');

  static startLocationService({double distanceFilter = 0.0}) async {
    return await _channel.invokeMethod("start_service", <String, dynamic>{'distance_filter': distanceFilter, 'force_location_manager': false});
  }

  static stopLocationService() async {
    return await _channel.invokeMethod("stop_service");
  }

  static setAndroidNotification({String? title, String? message, String? icon}) async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('set_android_notification', <String, dynamic>{'title': title, 'message': message, 'icon': icon});
    }
  }

  Future<Location> getCurrentLocation() async {
    var completer = Completer<Location>();

    var _data = Location();
    await onUpdate((p0) {
      _data.latitude = p0.latitude;
      _data.longitude = p0.longitude;
      _data.accuracy = p0.accuracy;
      _data.altitude = p0.altitude;
      _data.bearing = p0.bearing;
      _data.speed = p0.speed;
      _data.time = p0.time;
      completer.complete(_data);
    });

    return completer.future;
  }

  static onUpdate(Function(Location) location) {
    if (Platform.isIOS) {
      _channel.setMethodCallHandler((MethodCall call) async {
        if (call.method == 'location') {
          var locationData = Map.from(call.arguments);

          location(
              Location(
                latitude: locationData['latitude'],
                longitude: locationData['longitude'],
                altitude: locationData['altitude'],
                accuracy: locationData['accuracy'],
                bearing: locationData['bearing'],
                speed: locationData['speed'],
                time: locationData['time'],
              )
          );
        }
      });
    } else {
      void _onEvent(Object? event) {
        if (event != null) {
          var locationData = Map.from(event as Map);
          // Call the user passed function
          location(
            Location(
                latitude: locationData['latitude'],
                longitude: locationData['longitude'],
                altitude: locationData['altitude'],
                accuracy: locationData['accuracy'],
                bearing: locationData['bearing'],
                speed: locationData['speed'],
                time: locationData['time'],)
          );
        }
      }

      _eventChannel.receiveBroadcastStream().listen(_onEvent, onError: null);
    }
  }

}
