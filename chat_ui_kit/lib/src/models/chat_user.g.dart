// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUser _$ChatUserFromJson(Map<String, dynamic> json) => ChatUser(
  createdAt: (json['createdAt'] as num?)?.toInt(),
  firstName: json['firstName'] as String?,
  id: json['id'] as String,
  imageUrl: json['imageUrl'] as String?,
  lastName: json['lastName'] as String?,
);

Map<String, dynamic> _$ChatUserToJson(ChatUser instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'imageUrl': instance.imageUrl,
};
