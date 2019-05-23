library tim_plugin;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tim_plugin.g.dart';

part 'types.dart';

class TimPlugin {
  static const MethodChannel _channel = const MethodChannel('tim_plugin');
  static const EVENT_NAME = "event_name";
  static const EVENT_NAME_NEW_MESSAGE = "event_name_new_message";

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

  static Future<void> sendMessage(
      TIMMessage message, int type, String receiver) async {
    final params = {
      'message': message.getParameterList(),
      'type': type,
      'receiver': receiver,
    };
    return await _channel.invokeMethod('sendMessage', params);
  }

  ///客户端代码： 发送格式:  {'event_name':'event_name_new_message',
  ///    'data':{'msg':[
  ///    {TIMMessage.toJson格式}
  ///    ,{TIMMessage.toJson格式}]} }
  static Stream<List<TIMMessage>> addMessageListener() {
    _channel.invokeMethod("addMessageListener");
    return _eventChannel
        .receiveBroadcastStream()
        .map((map) => json.decode(json.encode(map)))
        .where((map) => (map[EVENT_NAME] as String) == EVENT_NAME_NEW_MESSAGE)
        .map((map) =>
        (map['data']['msg'] as List)
            ?.map((e) => e == null ? null : TIMMessage.fromJson(e))
            ?.toList());
  }
  static Future<void> createGroup(List<String> members, String name) async {}
}
