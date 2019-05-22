import 'dart:async';

import 'package:flutter/services.dart';

class TimPlugin {
  static const MethodChannel _channel = const MethodChannel('tim_plugin');

  static const EventChannel _eventChannel =
      const EventChannel("tim_plugin_event");

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

/**
 * initSdk
 *
 * login
 *
 * logout
 *
 * sendMessage
 *
 * addMessageListener
 *
 * createGroup
 *
 *
 *
 */

}
