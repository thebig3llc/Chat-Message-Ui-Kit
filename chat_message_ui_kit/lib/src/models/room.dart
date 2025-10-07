import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

import 'message.dart';
import 'chat_user.dart';

part 'room.g.dart';

/// Represents a chat room/conversation where multiple users can exchange messages.
/// This can be either a direct chat between two users or a group chat with multiple participants.
/// Uses JsonSerializable for JSON conversion and Equatable for value-based equality comparison.
@JsonSerializable()
@immutable
abstract class Room extends Equatable {
  /// Private constructor for creating a Room instance.
  /// Used internally by factory constructors to ensure proper initialization.
  const Room._({
    this.createdAt,
    required this.id,
    this.imageUrl,
    this.lastMessages,
    this.name,
    this.updatedAt,
    required this.users,
  });

  /// Timestamp when the room was created, stored in milliseconds since epoch.
  /// Used for sorting rooms by creation time and tracking room lifecycle.
  final int? createdAt;

  /// Unique identifier for this room across the entire chat system.
  /// This is the primary key used to reference this room in messages and API calls.
  final String id;

  /// URL pointing to the room's display image/avatar.
  /// For direct chats, this typically shows the other participant's avatar.
  /// For group chats, this can be a custom room image or generated group avatar.
  final String? imageUrl;

  /// Collection of the most recent messages in this room.
  /// Used for displaying message previews in room lists and for maintaining
  /// conversation context without loading full message history.
  final List<MessageModel>? lastMessages;

  /// Display name for the room shown in the UI.
  /// For direct chats, this is typically the other participant's name.
  /// For group chats, this is a custom room name set by participants.
  final String? name;

  /// Timestamp when the room was last modified, in milliseconds since epoch.
  /// Updated when messages are sent, users join/leave, or room settings change.
  final int? updatedAt;

  /// List of all users who are members of this room.
  /// Includes both active participants and users who may have left but are kept for history.
  final List<ChatUser> users;

  /// Factory constructor that creates a Room instance from JSON data.
  /// Used when deserializing room data from API responses or local storage.
  /// Utilizes json_serializable generated code for reliable deserialization.
  factory Room.fromJson(Map<String, dynamic> json) {
    return _$RoomFromJson(json);
  }

  /// Converts this Room instance to a JSON-serializable map.
  /// Used when sending room data to APIs or storing in local databases.
  /// Utilizes json_serializable generated code for consistent serialization.
  Map<String, dynamic> toJson() {
    return _$RoomToJson(this);
  }

  /// Main factory constructor for creating Room instances.
  /// Only 'id' and 'users' are required, as every room needs an identifier
  /// and at least some users. Other properties are optional for flexibility.
  const factory Room({
    int? createdAt,
    required String id,
    String? imageUrl,
    List<MessageModel>? lastMessages,
    String? name,
    int? updatedAt,
    required List<ChatUser> users,
  }) = _Room;

  /// Creates a new Room instance with updated properties.
  /// Any parameter provided will override the existing value in the new instance.
  /// Note: Passing null for imageUrl, name, or updatedAt will explicitly set them to null.
  /// This enables immutable updates to room data while preserving unchanged properties.
  Room copyWith({
    int? createdAt,
    String? id,
    String? imageUrl,
    List<MessageModel>? lastMessages,
    String? name,
    int? updatedAt,
    List<ChatUser>? users,
  });

  /// Defines which properties are used for equality comparison between Room instances.
  /// Two rooms are considered equal if all these properties have the same values.
  /// This enables value-based equality instead of reference-based equality.
  @override
  List<Object?> get props => [
    createdAt,
    id,
    imageUrl,
    lastMessages,
    name,
    updatedAt,
    users,
  ];
}

/// Private implementation class that provides concrete copyWith functionality.
/// This class extends Room and implements proper null handling using the _Unset pattern,
/// allowing copyWith to distinguish between null values and omitted parameters.
class _Room extends Room {
  /// Constructor that delegates to the parent Room private constructor.
  /// Maintains the same parameter structure while enabling the copyWith implementation.
  const _Room({
    super.createdAt,
    required super.id,
    super.imageUrl,
    super.lastMessages,
    super.name,
    super.updatedAt,
    required super.users,
  }) : super._();

  /// Implementation of copyWith using the _Unset pattern to handle null values properly.
  /// Parameters marked as _Unset retain their original values, while others are updated.
  /// This allows precise control over which properties to update in the new instance.
  @override
  Room copyWith({
    dynamic createdAt = _Unset,
    String? id,
    dynamic imageUrl = _Unset,
    dynamic lastMessages = _Unset,
    dynamic name = _Unset,
    dynamic updatedAt = _Unset,
    List<ChatUser>? users,
  }) => _Room(
    // For each property, use original value if _Unset, otherwise use the provided value
    createdAt: createdAt == _Unset ? this.createdAt : createdAt as int?,
    id: id ?? this.id,
    imageUrl: imageUrl == _Unset ? this.imageUrl : imageUrl as String?,
    lastMessages:
        lastMessages == _Unset
            ? this.lastMessages
            : lastMessages as List<MessageModel>?,
    name: name == _Unset ? this.name : name as String?,
    updatedAt: updatedAt == _Unset ? this.updatedAt : updatedAt as int?,
    users: users ?? this.users,
  );
}

/// Sentinel class used to differentiate between explicit null values and omitted parameters
/// in copyWith method. This enables precise control over which properties should be updated
/// versus which should retain their original values.
class _Unset {}
