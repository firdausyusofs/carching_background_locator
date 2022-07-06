import 'package:flutter/cupertino.dart';

class Location {
  double? latitude;
  double? longitude;
  double? altitude;
  double? bearing;
  double? accuracy;
  double? speed;
  double? time;

  Location({
    @required this.latitude,
    @required this.longitude,
    @required this.altitude,
    @required this.bearing,
    @required this.accuracy,
    @required this.speed,
    @required this.time
  });

  toMap() {
    var map = {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'bearing': bearing,
      'accuracy': accuracy,
      'speed': speed,
      'time': time,
    };
    return map;
  }
}