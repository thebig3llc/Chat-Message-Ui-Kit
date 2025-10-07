import 'package:chat_message_ui_kit/src/enums/message_status.dart';
import 'package:chat_message_ui_kit/src/enums/message_type.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'audio_message.dart';
import 'image_message.dart';
import 'text_message.dart';
import 'video_message.dart';
import 'chat_user.dart';

/// Abstract base class for all message types in the chat system.
/// This class defines the common structure and behavior that all messages share,
/// regardless of their specific type (text, image, audio, video).
/// Uses Equatable for value-based equality comparison and is immutable.
@immutable
abstract class MessageModel extends Equatable {
  /// Constructor for creating a message instance with all common properties.
  /// Author, id, and type are required as they're essential for any message.
  /// Other properties are optional and can be null depending on the context.
  const MessageModel({
    required this.author,
    this.createdAt,
    required this.id,
    this.remoteId,
    this.repliedMessage,
    this.roomId,
    this.showStatus,
    this.status,
    required this.type,
    this.updatedAt,
  });

  /// The user who authored and sent this message.
  /// This contains all user information like name, avatar, etc.
  final ChatUser author;

  /// Timestamp when the message was created, stored in milliseconds since epoch.
  /// This is typically set when the message is first created locally or received from server.
  final int? createdAt;

  /// Unique local identifier for this message within the client application.
  /// This is used for UI rendering, scrolling to messages, and local operations.
  final String id;

  /// Unique identifier assigned by the backend/server when the message is persisted.
  /// This may be different from the local 'id' and is used for server synchronization.
  final String? remoteId;

  /// Reference to another message that this message is replying to.
  /// Used to create threaded conversations and reply chains in the chat.
  final MessageModel? repliedMessage;

  /// Identifier of the chat room/conversation this message belongs to.
  /// Used to group messages by conversation context.
  final String? roomId;

  /// Controls whether to display the message status indicators (sent, delivered, read).
  /// When true, status icons will be shown; when false or null, they're hidden.
  final bool? showStatus;

  /// Current delivery/read status of the message (sent, delivered, read, error, etc.).
  /// Used to show appropriate status indicators in the message bubble.
  final Status? status;

  /// The specific type of message content (text, image, audio, video).
  /// This determines how the message is rendered and what data it contains.
  final MessageType type;

  /// Timestamp when the message was last updated/modified, in milliseconds since epoch.
  /// Used for tracking message edits, status changes, or other modifications.
  final int? updatedAt;

  /// Factory constructor that creates the appropriate message subclass from JSON.
  /// Reads the 'type' field from the JSON to determine which specific message type to instantiate.
  /// This enables polymorphic deserialization where different message types can be created
  /// from JSON while maintaining type safety.
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    // Extract the message type from JSON and find the corresponding enum value
    final type = MessageType.values.firstWhere((e) => e.name == json['type']);

    // Create the appropriate message subclass based on the type
    switch (type) {
      case MessageType.audio:
        return AudioMessageModel.fromJson(json);
      case MessageType.image:
        return ImageMessageModel.fromJson(json);
      case MessageType.text:
        return TextMessageModel.fromJson(json);
      case MessageType.video:
        return VideoMessageModel.fromJson(json);
    }
  }

  /// Abstract method that converts this message to a JSON-serializable map.
  /// Each message subclass implements this to serialize their specific data.
  /// The resulting map can be sent to a server or stored locally.
  Map<String, dynamic> toJson();

  /// Abstract method that creates a new instance with updated properties.
  /// Each message subclass implements this to support immutable updates.
  /// Only the provided parameters are changed; others retain their original values.
  MessageModel copyWith({
    ChatUser? author,
    int? createdAt,
    String? id,
    String? remoteId,
    MessageModel? repliedMessage,
    String? roomId,
    bool? showStatus,
    Status? status,
    int? updatedAt,
  });
}
