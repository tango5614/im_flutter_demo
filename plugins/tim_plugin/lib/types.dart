part of tim_plugin;

class LogLevel {
  static const none = 0;
  static const debug = 3;
  static const info = 4;
  static const warn = 5;
  static const error = 6;
}

@JsonSerializable(
  explicitToJson: true,
)
class TIMMessage {
  @JsonKey()
  List<TIMElement> msg;
  bool isSelf;

  //消息发送者的id
  String identifier;

  int addElem(TIMElement elem) {
    this.msg.add(elem);
    return this.msg.length - 1;
  }

  TIMElement getElem(int index) {
    return this.msg[index];
  }

  int get elementCount {
    return this.msg.length;
  }

  List<Map<String, dynamic>> getParameterList() {
    final list = this.msg.map((msg) {
      return msg.getParameters();
    }).toList();
    return list;
  }

  TIMMessage() {
    msg = [];
  }

  factory TIMMessage.fromJson(Map<String, dynamic> json) {
    return _$TIMMessageFromJson(json);
  }
}

@JsonSerializable(generateToJsonFunction: false, createFactory: false)
abstract class TIMElement {
  final int _type = TIMElementType.none;

  Map<String, dynamic> getParameters();

  TIMElement();

  factory TIMElement.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case TIMElementType.text:
        return TIMTextElement.fromJson(json);
      case TIMElementType.image:
        return TIMImageElement.fromJson(json);
      default:
        return null;
    }
  }

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class TIMTextElement extends TIMElement {
  final int _type = TIMElementType.text;
  String text;

  @override
  Map<String, dynamic> getParameters() {
    final params = <String, dynamic>{'type': this._type, 'text': this.text};
    return params;
  }

  TIMTextElement({this.text});

  factory TIMTextElement.fromJson(Map<String, dynamic> json) {
    return _$TIMTextElementFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TIMTextElementToJson(this);
}

@JsonSerializable()
class TIMImageElement extends TIMElement {
  static const COMPRESSION_LEVEL_ORIGINAL = 0;
  static const COMPRESSION_LEVEL_HIGH = 1;
  static const COMPRESSION_LEVEL_LOW = 2;

  final int _type = TIMElementType.image;
  String path;
  int compressionLevel;
  List<TIMImage> images;

  @override
  Map<String, dynamic> getParameters() {
    final params = <String, dynamic>{
      'type': this._type,
      'path': this.path,
      'level': this.compressionLevel
    };
    return params;
  }

  TIMImageElement({this.path, this.compressionLevel});

  factory TIMImageElement.fromJson(Map<String, dynamic> json) =>
      _$TIMImageElementFromJson(json);

  Map<String, dynamic> toJson() => _$TIMImageElementToJson(this);
}

class TIMElementType {
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

@JsonSerializable()
class TIMImage {
  int type;
  int size;
  int height;
  int width;
  String url;
  String uuid;
}
