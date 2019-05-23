import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:tim_plugin/tim_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await TimPlugin.initSdk(1400213425, "36862");
      await TimPlugin.addMessageListener().then((value) {
        value.listen((list) {
          print('list:$list ');
        });
      });
      await TimPlugin.login('t_2', 'eJxlj8FOhDAURfd8BWGrMW2hDpi4KHUMI5pIZmDBpiHTQjvjQC1VBOO-G1EjiW97zs29791xXdfb3W8vqv2*e2kts6MWnnvlesA7-4NaK84qy3zD-0HxppURrKqtMDOEGGMEwNJRXLRW1erHsAwtYM*PbG74TgcAIOgHCC8V1czwYZ3TTXYjRylpHB-KYU3gKcFhFcGByGFlziJak2LrH8lu0vypJ5smx7eP5ZjRcqWEDA9xQTuZpFMaIZwmWTy1zXMRXGpzl2fXi0qrTuL3nTBAoR8sB70K06uunQUEIIbIB1-nOR-OJ8GXW6c_');
      final message = TIMMessage();
      final elem = TIMTextElement();
      elem.text = 'test';
      message.addElem(elem);
      await TimPlugin.sendMessage(message, TIMConversationType.TIM_C2C, 't_4');
      print("send success");
    } on PlatformException catch(e) {
      await TimPlugin.login('t_2',
          'eJxlj8FOhDAURfd8BWGrMW2hDpi4KHUMI5pIZmDBpiHTQjvjQC1VBOO-G1EjiW97zs29791xXdfb3W8vqv2*e2kts6MWnnvlesA7-4NaK84qy3zD-0HxppURrKqtMDOEGGMEwNJRXLRW1erHsAwtYM*PbG74TgcAIOgHCC8V1czwYZ3TTXYjRylpHB-KYU3gKcFhFcGByGFlziJak2LrH8lu0vypJ5smx7eP5ZjRcqWEDA9xQTuZpFMaIZwmWTy1zXMRXGpzl2fXi0qrTuL3nTBAoR8sB70K06uunQUEIIbIB1-nOR-OJ8GXW6c_');
      print('send error:');
      print(e.code);
      print(e.message);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
