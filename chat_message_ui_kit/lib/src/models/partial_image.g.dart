// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partial_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartialImageModel _$PartialImageModelFromJson(Map<String, dynamic> json) =>
    PartialImageModel(
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

Map<String, dynamic> _$PartialImageModelToJson(PartialImageModel instance) =>
    <String, dynamic>{
      'height': instance.height,
      'name': instance.name,
      'repliedMessage': instance.repliedMessage,
      'size': instance.size,
      'uri': instance.uri,
      'width': instance.width,
    };
