import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:carching_background_locator/carching_background_locator.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String latitude = 'loading...';
  String longitude = 'loading...';

  @override
  void initState() {
    super.initState();
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
            Text(latitude),
            Text(longitude),
            ElevatedButton(
                onPressed: () async {
                  final response = await CarchingBackgroundLocator.startLocationService(distanceFilter: 20);
                  print(response);

                  CarchingBackgroundLocator.onUpdate((location) {
                    print(location);
                    setState(() {
                      latitude = location.latitude.toString();
                      longitude = location.longitude.toString();
                    });
                  });
                },
                child: const Text("Start")
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    CarchingBackgroundLocator.stopLocationService();
    super.dispose();
  }
}
