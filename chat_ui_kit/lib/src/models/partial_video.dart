import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

import 'message.dart';

part 'partial_video.g.dart';

/// A class that represents partial video message.
@JsonSerializable()
@immutable
class PartialVideoModel {
  /// Creates a partial video message with all variables video can have.
  /// Use [VideoMessage] to create a full message.
  /// You can use [VideoMessage.fromPartial] constructor to create a full
  /// message from a partial one.
  const PartialVideoModel({
    this.height,
    required this.name,
    this.repliedMessage,
    required this.size,
    required this.uri,
    this.width,
  });

  /// Video height in pixels.
  final double? height;

  /// The name of the video.
  final String name;

  /// MessageModel that is being replied to with the current message.
  final MessageModel? repliedMessage;

  /// Size of the video in bytes.
  final num size;

  /// The video source (either a remote URL or a local resource).
  final String uri;

  /// Video width in pixels.
  final double? width;

  /// Creates a partial video message from a map (decoded JSON).
  factory PartialVideoModel.fromJson(Map<String, dynamic> json) {
    return _$PartialVideoModelFromJson(json);
  }

  /// Converts a partial video message to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() {
    return _$PartialVideoModelToJson(this);
  }
}
