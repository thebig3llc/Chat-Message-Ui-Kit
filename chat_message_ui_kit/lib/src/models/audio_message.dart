import 'package:chat_message_ui_kit/src/enums/message_status.dart';
import 'package:chat_message_ui_kit/src/enums/message_type.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'message.dart';
import 'chat_user.dart';
import 'partial_audio.dart';

part 'audio_message.g.dart';

/// A class that represents audio message.
@JsonSerializable()
@immutable
abstract class AudioMessageModel extends MessageModel {
  /// Creates an audio message.
  const AudioMessageModel._({
    required super.author,
    super.createdAt,
    required this.duration,
    required super.id,
    this.mimeType,
    required this.name,
    super.remoteId,
    super.repliedMessage,
    super.roomId,
    super.showStatus,
    required this.size,
    super.status,
    MessageType? type,
    super.updatedAt,
    required this.uri,
  }) : super(type: type ?? MessageType.audio);

  /// The length of the audio.
  final Duration duration;

  /// Media type of the audio file.
  final String? mimeType;

  /// The name of the audio.
  final String name;

  /// Size of the audio in bytes.
  final num size;

  /// The audio file source (either a remote URL or a local resource).
  final String uri;

  /// Creates an audio MessageModel from a map (decoded JSON).
  factory AudioMessageModel.fromJson(Map<String, dynamic> json) {
    return _$AudioMessageModelFromJson(json);
  }

  /// Converts an audio MessageModel to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() {
    return _$AudioMessageModelToJson(this);
  }

  const factory AudioMessageModel({
    required ChatUser author,
    int? createdAt,
    required Duration duration,
    required String id,
    String? mimeType,
    required String name,
    String? remoteId,
    MessageModel? repliedMessage,
    String? roomId,
    bool? showStatus,
    required num size,
    Status? status,
    MessageType? type,
    int? updatedAt,
    required String uri,
  }) = _AudioMessage;

  /// Creates a full audio MessageModel from a partial one.
  factory AudioMessageModel.fromPartial({
    required ChatUser author,
    int? createdAt,
    required String id,
    required PartialAudioModel partialAudio,
    String? remoteId,
    String? roomId,
    bool? showStatus,
    Status? status,
    int? updatedAt,
  }) => _AudioMessage(
    author: author,
    createdAt: createdAt,
    duration: partialAudio.duration,
    id: id,
    mimeType: partialAudio.mimeType,
    name: partialAudio.name,
    remoteId: remoteId,
    repliedMessage: partialAudio.repliedMessage,
    roomId: roomId,
    showStatus: showStatus,
    size: partialAudio.size,
    status: status,
    type: MessageType.audio,
    updatedAt: updatedAt,
    uri: partialAudio.uri,
  );

  @override
  MessageModel copyWith({
    ChatUser? author,
    int? createdAt,
    Duration? duration,
    String? id,
    String? mimeType,
    String? name,
    String? remoteId,
    MessageModel? repliedMessage,
    String? roomId,
    bool? showStatus,
    num? size,
    Status? status,
    int? updatedAt,
    String? uri,
  });

  /// Equatable props.
  @override
  List<Object?> get props => [
    author,
    createdAt,
    duration,
    id,
    mimeType,
    name,
    remoteId,
    repliedMessage,
    roomId,
    showStatus,
    size,
    status,
    updatedAt,
    uri,
  ];
}

/// A utility class to enable better copyWith.
class _AudioMessage extends AudioMessageModel {
  const _AudioMessage({
    required super.author,
    super.createdAt,
    required super.duration,
    required super.id,
    super.mimeType,
    required super.name,
    super.remoteId,
    super.repliedMessage,
    super.roomId,
    super.showStatus,
    required super.size,
    super.status,
    super.type,
    super.updatedAt,
    required super.uri,
  }) : super._();

  @override
  MessageModel copyWith({
    ChatUser? author,
    int? createdAt,
    Duration? duration,
    String? id,
    String? mimeType,
    String? name,
    String? remoteId,
    MessageModel? repliedMessage,
    String? roomId,
    bool? showStatus,
    num? size,
    Status? status,
    int? updatedAt,
    String? uri,
  }) => _AudioMessage(
    author: author ?? this.author,
    createdAt: createdAt ?? this.createdAt,
    duration: duration ?? this.duration,
    id: id ?? this.id,
    mimeType: mimeType ?? this.mimeType,
    name: name ?? this.name,
    remoteId: remoteId ?? this.remoteId,
    repliedMessage: repliedMessage ?? this.repliedMessage,
    roomId: roomId ?? this.roomId,
    showStatus: showStatus ?? this.showStatus,
    size: size ?? this.size,
    status: status ?? this.status,
    updatedAt: updatedAt ?? this.updatedAt,
    uri: uri ?? this.uri,
  );
}
