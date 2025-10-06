// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partial_audio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartialAudioModel _$PartialAudioModelFromJson(Map<String, dynamic> json) =>
    PartialAudioModel(
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      mimeType: json['mimeType'] as String?,
      name: json['name'] as String,
      repliedMessage:
          json['repliedMessage'] == null
              ? null
              : MessageModel.fromJson(
                json['repliedMessage'] as Map<String, dynamic>,
              ),
      size: json['size'] as num,
      uri: json['uri'] as String,
    );

Map<String, dynamic> _$PartialAudioModelToJson(PartialAudioModel instance) =>
    <String, dynamic>{
      'duration': instance.duration.inMicroseconds,
      'mimeType': instance.mimeType,
      'name': instance.name,
      'repliedMessage': instance.repliedMessage,
      'size': instance.size,
      'uri': instance.uri,
    };
