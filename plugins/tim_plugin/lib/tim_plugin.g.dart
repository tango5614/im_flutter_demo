// GENERATED CODE - DO NOT MODIFY BY HAND

part of tim_plugin;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TIMMessage _$TIMMessageFromJson(Map<String, dynamic> json) {
  return TIMMessage()
    ..msg = (json['msg'] as List)
        ?.map((e) =>
            e == null ? null : TIMElement.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TIMMessageToJson(TIMMessage instance) =>
    <String, dynamic>{'msg': instance.msg?.map((e) => e?.toJson())?.toList()};

Map<String, dynamic> _$TIMElementToJson(TIMElement instance) =>
    <String, dynamic>{};

TIMTextElement _$TIMTextElementFromJson(Map<String, dynamic> json) {
  return TIMTextElement(text: json['text'] as String);
}

Map<String, dynamic> _$TIMTextElementToJson(TIMTextElement instance) =>
    <String, dynamic>{'text': instance.text};

TIMImageElement _$TIMImageElementFromJson(Map<String, dynamic> json) {
  return TIMImageElement(
      path: json['path'] as String,
      compressionLevel: json['compressionLevel'] as int);
}

Map<String, dynamic> _$TIMImageElementToJson(TIMImageElement instance) =>
    <String, dynamic>{
      'path': instance.path,
      'compressionLevel': instance.compressionLevel
    };
