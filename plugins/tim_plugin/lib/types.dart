part of tim_plugin;

class LogLevel {
  static const none = 0;
  static const debug = 3;
  static const info = 4;
  static const warn = 5;
  static const error = 6;
}

class TIMMessage {
  final List<TIMElement> _msg = [];

  int addElem(TIMElement elem) {
    this._msg.add(elem);
    return this._msg.length - 1;
  }

  TIMElement getElem(int index) {
    return this._msg[index];
  }

  int get elementCount { return this._msg.length; }

  List<Map<String, dynamic>> getParameterList() {
    final list = this._msg.map((msg) {
      return msg.getParameters();
    }).toList();
    return list;
  }
}

abstract class TIMElement {
  final int _type = TIMMessageType.none;
  Map<String, dynamic> getParameters();
}

class TIMTextElement extends TIMElement {
  final int _type = TIMMessageType.text;
  String text;
  @override
  Map<String, dynamic> getParameters() {
    // TODO: implement getParameters
    final params = <String, dynamic> {
      'type': this._type,
      'text': this.text
    };
    return params;
  }
}

class TIMImageElement extends TIMElement {
  static const COMPRESSION_LEVEL_ORIGINAL = 0;
  static const COMPRESSION_LEVEL_HIGH = 1;
  static const COMPRESSION_LEVEL_LOW = 2;


  final int _type = TIMMessageType.image;
  String path;
  int compressionLevel;
  @override
  Map<String, dynamic> getParameters() {
    // TODO: implement getParameters
    final params = <String, dynamic> {
      'type': this._type,
      'path': this.path,
      'level': this.compressionLevel
    };
    return params;
  }
}

class TIMMessageType {
  static const none = -1;
  static const text = 0;
  static const image = 1;
}

class TIMConversationType {
  /// C2C 类型
  static const TIM_C2C = 1;

  /// 群聊 类型
  static const TIM_GROUP = 2;

  /// 系统消息
  static const TIM_SYSTEM = 3;
}
