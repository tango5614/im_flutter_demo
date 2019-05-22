import 'dart:async';

import 'package:flutter/services.dart';

class LogLevel {
  static const none = 0;
  static const debug = 3;
  static const info = 4;
  static const warn = 5;
  static const error = 6;
}

class TIMMessage {
  int addElem(TIMElement elem) {

  }
}

class TIMElement {
}

class TIMConversationType {
  /**
   *  C2C 类型
   */
  static const TIM_C2C = 1;

  /**
   *  群聊 类型
   */
  static const TIM_GROUP = 2;

  /**
   *  系统消息
   */
  static const TIM_SYSTEM = 3;
}

class TimPlugin {
  static const MethodChannel _channel = const MethodChannel('tim_plugin');

  static const EventChannel _eventChannel =
  const EventChannel("tim_plugin_event");

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> initSdk(int appId, String accountType,
      {bool disableLogPrint, LogLevel logLevel, String logPath}) async {

  }

  static Future<void> login(String indentifier, String userSig,
      String appidAt3rd) async {

  }

  static Future<void> logout() async {

  }

  static Future<void> sendMessage(TIMMessage message, TIMConversationType type, String receiver) async {

  }

  static Future<void> addMessageListener() async {

  }

  static Future<void> createGroup(List<String> members, String name) async {
    
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
