import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carching_background_locator/carching_background_locator.dart';

void main() {
  const MethodChannel channel = MethodChannel('carching_background_locator');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await CarchingBackgroundLocator.platformVersion, '42');
  });
}
