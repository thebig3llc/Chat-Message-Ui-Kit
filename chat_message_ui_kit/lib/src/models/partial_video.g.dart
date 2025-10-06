// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partial_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartialVideoModel _$PartialVideoModelFromJson(Map<String, dynamic> json) =>
    PartialVideoModel(
      height: (json['height'] as num?)?.toDouble(),
      name: json['name'] as String,
      repliedMessage:
          json['repliedMessage'] == null
              ? null
              : MessageModel.fromJson(
                json['repliedMessage'] as Map<String, dynamic>,
              ),
      size: json['size'] as num,
      uri: json['uri'] as String,
      width: (json['width'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PartialVideoModelToJson(PartialVideoModel instance) =>
    <String, dynamic>{
      'height': instance.height,
      'name': instance.name,
      'repliedMessage': instance.repliedMessage,
      'size': instance.size,
      'uri': instance.uri,
      'width': instance.width,
    };
