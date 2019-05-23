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
        ?.toList()
    ..isSelf = json['isSelf'] as bool
    ..identifier = json['identifier'] as String;
}

Map<String, dynamic> _$TIMMessageToJson(TIMMessage instance) =>
    <String, dynamic>{
      'msg': instance.msg?.map((e) => e?.toJson())?.toList(),
      'isSelf': instance.isSelf,
      'identifier': instance.identifier
    };

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
      compressionLevel: json['compressionLevel'] as int)
    ..images = (json['images'] as List)
        ?.map((e) =>
            e == null ? null : TIMImage.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TIMImageElementToJson(TIMImageElement instance) =>
    <String, dynamic>{
      'path': instance.path,
      'compressionLevel': instance.compressionLevel,
      'images': instance.images
    };

TIMImage _$TIMImageFromJson(Map<String, dynamic> json) {
  return TIMImage(
      type: json['type'] as int,
      size: json['size'] as int,
      height: json['height'] as int,
      width: json['width'] as int,
      url: json['url'] as String,
      uuid: json['uuid'] as String);
}

Map<String, dynamic> _$TIMImageToJson(TIMImage instance) => <String, dynamic>{
      'type': instance.type,
      'size': instance.size,
      'height': instance.height,
      'width': instance.width,
      'url': instance.url,
      'uuid': instance.uuid
    };
