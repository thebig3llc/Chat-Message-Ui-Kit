// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partial_text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartialTextModel _$PartialTextModelFromJson(Map<String, dynamic> json) =>
    PartialTextModel(
      previewData:
          json['previewData'] == null
              ? null
              : PreviewData.fromJson(
                json['previewData'] as Map<String, dynamic>,
              ),
      repliedMessage:
          json['repliedMessage'] == null
              ? null
              : MessageModel.fromJson(
                json['repliedMessage'] as Map<String, dynamic>,
              ),
      text: json['text'] as String,
    );

Map<String, dynamic> _$PartialTextModelToJson(PartialTextModel instance) =>
    <String, dynamic>{
      'previewData': instance.previewData,
      'repliedMessage': instance.repliedMessage,
      'text': instance.text,
    };
