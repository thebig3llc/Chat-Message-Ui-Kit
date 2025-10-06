// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
  createdAt: (json['createdAt'] as num?)?.toInt(),
  id: json['id'] as String,
  imageUrl: json['imageUrl'] as String?,
  lastMessages:
      (json['lastMessages'] as List<dynamic>?)
          ?.map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  name: json['name'] as String?,
  updatedAt: (json['updatedAt'] as num?)?.toInt(),
  users:
      (json['users'] as List<dynamic>)
          .map((e) => ChatUser.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
  'createdAt': instance.createdAt,
  'id': instance.id,
  'imageUrl': instance.imageUrl,
  'lastMessages': instance.lastMessages,
  'name': instance.name,
  'updatedAt': instance.updatedAt,
  'users': instance.users,
};
