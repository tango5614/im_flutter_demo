library main.dart;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tim_plugin/tim_plugin.dart';
import 'dart:async';


void main() {
  TimPlugin.initSdk(1400213425, '36862');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static StreamSubscription<List<TIMMessage>> subscription;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'TIM Demo'),
      routes: <String, WidgetBuilder>{
        '/t_1': (BuildContext context) => ChatPage(title: 't_1'),
        '/t_2': (BuildContext context) => ChatPage(title: 't_2')
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void login(String user, String userSig, {String appidAt3rd}) async {
    try {
      await TimPlugin.login(user, userSig, appidAt3rd: appidAt3rd);
      MyApp.subscription?.cancel();
      MyApp.subscription = TimPlugin.addMessageListener().listen(_streamHandler);
      Navigator.pushNamed(context, '/$user');
    } on PlatformException catch (e) {
      print('code: ${e.code}, message: ${e.message}');
    }
  }
  void _streamHandler(List<TIMMessage> msgs) {

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('登陆'),
            RaisedButton(
              onPressed: () {
                this.login(
                    't_1',
                    'eJxlz11PgzAUgOF7fgXhdsaUlu7DZBeNDqeyLYOZrd40hB6WioPKCoEt-nczppHEc-u8Jy'
                        'fnbNm27WyC6DZOkqLKjTCtBse*sx3k3Pyh1kqK2AhSyn8IjVYliDg1UHboUkoxQv1GSciNStVPYYTbw6PMRHfhuu0h'
                        'hF3iYdpP1L7DxWx9--TYnIK3PDmxNsyeJxstF5F-WNEdDBhwICH361IO*Sedr5liquHF9mXVhu8*VGZYbYNdHNWZZjk'
                        'ZLR-I-ON1NuB7wpcpm057J406wO87Yw*P8WTU0xrKoyryLsDIpS4m6DKO9WV9A1QQXJ0_',
                    appidAt3rd: '1400213425');
              },
              child: Text('t_1'),
            ),
            RaisedButton(
              onPressed: () {
                this.login(
                    't_2',
                    'eJxlj8FOhDAURfd8BWGrMW2hDpi4KHUMI5pIZmDBpiHTQjvjQC1VB'
                        'OO-G1EjiW97zs29791xXdfb3W8vqv2*e2kts6MWnnvlesA7-4NaK84qy3zD-0HxppURrKqt'
                        'MDOEGGMEwNJRXLRW1erHsAwtYM*PbG74TgcAIOgHCC8V1czwYZ3TTXYjRylpHB-KYU3gKcF'
                        'hFcGByGFlziJak2LrH8lu0vypJ5smx7eP5ZjRcqWEDA9xQTuZpFMaIZwmWTy1zXMRXGpzl2'
                        'fXi0qrTuL3nTBAoR8sB70K06uunQUEIIbIB1-nOR-OJ8GXW6c_',
                    appidAt3rd: '1400213425');
              },
              child: Text('t_2'),
            )
          ],
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String text;
  final _msgList = <TIMMessage>[];
  final _controller = TextEditingController();
  Future<void> sendMessage(String text) async {
    final message = TIMMessage();
    final elem = TIMTextElement();
    elem.text = text;
    message.addElem(elem);
    setState(() {
      _msgList.add(message);
      _controller.text = '';
    });
    String receiver = widget.title == 't_1' ? 't_2' : 't_1';
    return await TimPlugin.sendMessage(
        message, TIMConversationType.TIM_C2C, receiver);
  }

  Widget _buildRow(TIMMessage message) {
    final elem = message.getElem(0) as TIMTextElement;
    return ListTile(
      title: Text(
        elem.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _msgList.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, i) {
                return _buildRow(_msgList[i]);
              }
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RaisedButton(
                  onPressed: () async {
                    await sendMessage(_controller.text);
                  },
                  child: Text('发送'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    MyApp.subscription?.cancel();
  }
}
