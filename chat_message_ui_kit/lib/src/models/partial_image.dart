import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

import 'message.dart';

part 'partial_image.g.dart';

/// A class that represents partial image message.
@JsonSerializable()
@immutable
class PartialImageModel {
  /// Creates a partial image message with all variables image can have.
  /// Use [ImageMessage] to create a full message.
  /// You can use [ImageMessage.fromPartial] constructor to create a full
  /// message from a partial one.
  const PartialImageModel({
    this.height,
    required this.name,
    this.repliedMessage,
    required this.size,
    required this.uri,
    this.width,
  });

  /// Image height in pixels.
  final double? height;

  /// The name of the image.
  final String name;

  /// MessageModel that is being replied to with the current message.
  final MessageModel? repliedMessage;

  /// Size of the image in bytes.
  final num size;

  /// The image source (either a remote URL or a local resource).
  final String uri;

  /// Image width in pixels.
  final double? width;

  /// Creates a partial image message from a map (decoded JSON).
  factory PartialImageModel.fromJson(Map<String, dynamic> json) {
    return _$PartialImageModelFromJson(json);
  }

  /// Converts a partial image message to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() {
    return _$PartialImageModelToJson(this);
  }
}
