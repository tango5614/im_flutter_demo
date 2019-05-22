import 'dart:async';
import 'package:flutter/services.dart';
part './types.dart';

class TimPlugin {
  static const MethodChannel _channel = const MethodChannel('tim_plugin');

  static const EventChannel _eventChannel =
      const EventChannel("tim_plugin_event");

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> initSdk(int appId, String accountType,
      {bool disableLogPrint, int logLevel, String logPath}) async {
    var params = <String, dynamic>{'appId': appId, 'accountType': accountType};
    if (disableLogPrint != null) {
      params['disableLogPrint'] = disableLogPrint;
    }
    if (logLevel != null) {
      params['logLevel'] = logLevel;
    }
    if (logPath != null) {
      params['logPath'] = logPath;
    }
    return await _channel.invokeMethod('initSdk', params);
  }

  static Future<void> login(String identifier, String userSig,
      {String appidAt3rd}) async {
    var params = <String, String>{
      'identifier': identifier,
      'userSig': userSig,
      'appidAt3rd': appidAt3rd
    };
    return await _channel.invokeMethod('login', params);
  }

  static Future<void> logout() async {
    return await _channel.invokeMethod('logout');
  }

  static Future<void> sendMessage(TIMMessage message, int type, String receiver) async {
    final params = {
      'message': message.getParameterList(),
      'type': type,
      'receiver': receiver,
    };
    return await _channel.invokeMethod('sendMessage', params);
  }

  static StreamSubscription<dynamic> addMessageListener(Function callback) {
    return _eventChannel.receiveBroadcastStream().listen(callback);
  }

  static Future<void> createGroup(List<String> members, String name) async {}
}
