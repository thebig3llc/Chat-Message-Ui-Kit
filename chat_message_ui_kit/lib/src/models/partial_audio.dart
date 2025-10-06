import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'message.dart';

part 'partial_audio.g.dart';

/// A class that represents partial audio message.
@JsonSerializable()
@immutable
class PartialAudioModel {
  /// Creates a partial audio message with all variables audio can have.
  /// Use [AudioMessage] to create a full message.
  /// You can use [AudioMessage.fromPartial] constructor to create a full
  /// message from a partial one.
  const PartialAudioModel({
    required this.duration,
    this.mimeType,
    required this.name,
    this.repliedMessage,
    required this.size,
    required this.uri,
  });

  /// The length of the audio.
  final Duration duration;

  /// Media type of the audio file.
  final String? mimeType;

  /// The name of the audio.
  final String name;

  /// MessageModel that is being replied to with the current message.
  final MessageModel? repliedMessage;

  /// Size of the audio in bytes.
  final num size;

  /// The audio file source (either a remote URL or a local resource).
  final String uri;

  /// Creates a partial audio message from a map (decoded JSON).
  factory PartialAudioModel.fromJson(Map<String, dynamic> json) {
    return _$PartialAudioModelFromJson(json);
  }

  /// Converts a partial audio message to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() {
    return _$PartialAudioModelToJson(this);
  }
}
