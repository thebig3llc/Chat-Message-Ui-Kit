// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageMessageModel _$ImageMessageModelFromJson(Map<String, dynamic> json) =>
    ImageMessageModel(
      author: ChatUser.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: (json['createdAt'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toDouble(),
      id: json['id'] as String,
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
      width: (json['width'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ImageMessageModelToJson(ImageMessageModel instance) =>
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
      'height': instance.height,
      'name': instance.name,
      'size': instance.size,
      'uri': instance.uri,
      'width': instance.width,
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
