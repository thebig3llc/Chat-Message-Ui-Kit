import 'package:chat_message_ui_kit/src/models/message.dart';
import 'package:chat_message_ui_kit/src/models/preview_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'partial_text.g.dart';

/// A class that represents partial text message.
@JsonSerializable()
@immutable
class PartialTextModel {
  /// Creates a partial text message with all variables text can have.
  /// Use [TextMesage] to create a full message.
  /// You can use [TextMessage.fromPartial] constructor to create a full
  /// message from a partial one.
  const PartialTextModel({
    this.previewData,
    this.repliedMessage,
    required this.text,
  });

  /// See [PreviewData].
  final PreviewData? previewData;

  /// MessageModel that is being replied to with the current message.
  final MessageModel? repliedMessage;

  /// User's message.
  final String text;

  /// Creates a partial text message from a map (decoded JSON).
  factory PartialTextModel.fromJson(Map<String, dynamic> json) {
    return _$PartialTextModelFromJson(json);
  }

  /// Converts a partial text message to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() {
    return _$PartialTextModelToJson(this);
  }
}
