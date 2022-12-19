import 'dart:ffi';
import 'dart:isolate';
import 'dart:ui';

import 'package:carching_background_locator/location_dto.dart';
import 'package:carching_background_locator/settings/android_settings.dart';
import 'package:carching_background_locator/settings/ios_settings.dart';
import 'package:carching_background_locator/settings/locator_settings.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:carching_background_locator/carching_background_locator.dart';
import 'package:location_permissions/location_permissions.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ReceivePort port = ReceivePort();

  String latitude = 'loading...';
  String longitude = 'loading...';
  bool running = false;

  var isolatorName = "LocatorIsolate";

  @override
  void initState() {
    super.initState();

    if (IsolateNameServer.lookupPortByName(isolatorName) != null) {
      IsolateNameServer.removePortNameMapping(isolatorName);
    }

    IsolateNameServer.registerPortWithName(port.sendPort, isolatorName);

    port.listen((dynamic data) {
      print(data);
    });

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    print("Initializing...");
    await CarchingBackgroundLocator.initialize();
    final _isRunning = await CarchingBackgroundLocator.isServiceRunning();
    setState(() {
      running = _isRunning;
    });
    print(running.toString());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Carching Background Locator'),
        ),
        body: Column(
          children: [
            Text(running.toString()),
            Text(latitude),
            Text(longitude),
            ElevatedButton(
                onPressed: () async {
                  if (await _checkLocationPermission()) {
                    await CarchingBackgroundLocator.registerLocationUpdate(
                        callback,
                        iosSettings: const IOSSettings(accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
                        autoStop: false,
                        androidSettings: const AndroidSettings(
                            accuracy: LocationAccuracy.NAVIGATION,
                            interval: 1,
                            distanceFilter: 0,
                            client: LocationClient.google,
                            androidNotificationSettings: AndroidNotificationSettings(
                              notificationChannelName: 'Location tracking',
                              notificationTitle: 'Start Location Tracking',
                              notificationMsg: 'Track location in background',
                              notificationBigMsg:
                              'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
                              notificationIconColor: Colors.grey,
                              notificationTapCallback: notificationCallback
                            )
                        )
                    );
                    final bool _isRunning = await CarchingBackgroundLocator.isServiceRunning();

                    setState(() {
                      running = _isRunning;
                    });

                    print(_isRunning.toString());
                  }
                  },
                child: const Text("Start")
            ),
            ElevatedButton(
                onPressed: () async {
                  await CarchingBackgroundLocator.unRegisterLocationUpdate();
                  final _isRunning = await CarchingBackgroundLocator.isServiceRunning();
                  setState(() {
                    running = _isRunning;
                  });
                  },
                child: const Text("Stop")
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus();
    switch (access) {
      case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        final permission = await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.locationAlways,
        );
        if (permission == PermissionStatus.granted) {
          return true;
        } else {
          return false;
        }
        break;
      case PermissionStatus.granted:
        return true;
        break;
      default:
        return false;
        break;
    }
  }

  static void callback(LocationDto location) {
    final SendPort? send = IsolateNameServer.lookupPortByName("LocatorIsolate");
    send?.send(location);
  }

  static void notificationCallback() {

  }

  @override
  void dispose() {
    CarchingBackgroundLocator.unRegisterLocationUpdate();
    super.dispose();
  }
}
