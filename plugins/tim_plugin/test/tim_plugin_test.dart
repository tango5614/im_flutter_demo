import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tim_plugin/tim_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('tim_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await TimPlugin.platformVersion, '42');
  });
}
