import 'package:flutter/material.dart';

import 'carching_background_locator.dart';

class AutoStopHandler extends WidgetsBindingObserver {
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await CarchingBackgroundLocator.unRegisterLocationUpdate();
        break;
      case AppLifecycleState.resumed:
        break;
    }
  }
}
