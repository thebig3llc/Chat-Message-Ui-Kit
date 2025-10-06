// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioMessageModel _$AudioMessageModelFromJson(Map<String, dynamic> json) =>
    AudioMessageModel(
      author: ChatUser.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: (json['createdAt'] as num?)?.toInt(),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      id: json['id'] as String,
      mimeType: json['mimeType'] as String?,
      name: json['name'] as String,
      remoteId: json['remoteId'] as String?,
      repliedMessage:
          json['repliedMessage'] == null
              ? null
              : MessageModel.fromJson(
                json['repliedMessage'] as Map<String, dynamic>,
              ),
      roomId: json['roomId'] as String?,
      showStatus: json['showStatus'] as bool?,
      size: json['size'] as num,
      status: $enumDecodeNullable(_$StatusEnumMap, json['status']),
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
      updatedAt: (json['updatedAt'] as num?)?.toInt(),
      uri: json['uri'] as String,
    );

Map<String, dynamic> _$AudioMessageModelToJson(AudioMessageModel instance) =>
    <String, dynamic>{
      'author': instance.author,
      'createdAt': instance.createdAt,
      'id': instance.id,
      'remoteId': instance.remoteId,
      'repliedMessage': instance.repliedMessage,
      'roomId': instance.roomId,
      'showStatus': instance.showStatus,
      'status': _$StatusEnumMap[instance.status],
      'type': _$MessageTypeEnumMap[instance.type]!,
      'updatedAt': instance.updatedAt,
      'duration': instance.duration.inMicroseconds,
      'mimeType': instance.mimeType,
      'name': instance.name,
      'size': instance.size,
      'uri': instance.uri,
    };

const _$StatusEnumMap = {
  Status.delivered: 'delivered',
  Status.error: 'error',
  Status.seen: 'seen',
  Status.sending: 'sending',
  Status.sent: 'sent',
};

const _$MessageTypeEnumMap = {
  MessageType.audio: 'audio',
  MessageType.image: 'image',
  MessageType.text: 'text',
  MessageType.video: 'video',
};
