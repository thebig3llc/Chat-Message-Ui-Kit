import 'package:chat_ui_kit/src/models/chat_user.dart';
import 'package:chat_ui_kit/src/models/message.dart';
import 'package:chat_ui_kit/src/models/partial_text.dart';
import 'package:chat_ui_kit/src/models/preview_data.dart';
import 'package:chat_ui_kit/src/enums/message_status.dart';
import 'package:chat_ui_kit/src/enums/message_type.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';

part 'text_message.g.dart';

/// A class that represents text message.
@JsonSerializable()
@immutable
abstract class TextMessageModel extends MessageModel {
  /// Creates a text message.
  const TextMessageModel._({
    required super.author,
    super.createdAt,
    required super.id,
    this.previewData,
    super.remoteId,
    super.repliedMessage,
    super.roomId,
    super.showStatus,
    super.status,
    required this.text,
    MessageType? type,
    super.updatedAt,
  }) : super(type: type ?? MessageType.text);

  /// See [PreviewData].
  final PreviewData? previewData;

  /// User's message.
  final String text;

  /// Creates a text message from a map (decoded JSON).
  factory TextMessageModel.fromJson(Map<String, dynamic> json) {
    return _$TextMessageModelFromJson(json);
  }

  /// Converts a text message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() {
    return _$TextMessageModelToJson(this);
  }

  const factory TextMessageModel({
    required ChatUser author,
    int? createdAt,
    required String id,
    PreviewData? previewData,
    String? remoteId,
    MessageModel? repliedMessage,
    String? roomId,
    bool? showStatus,
    Status? status,
    required String text,
    MessageType? type,
    int? updatedAt,
  }) = _TextMessage;

  /// Creates a full text message from a partial one.
  factory TextMessageModel.fromPartial({
    required ChatUser author,
    int? createdAt,
    required String id,
    required PartialTextModel partialText,
    String? remoteId,
    String? roomId,
    bool? showStatus,
    Status? status,
    int? updatedAt,
  }) => _TextMessage(
    author: author,
    createdAt: createdAt,
    id: id,
    previewData: partialText.previewData,
    remoteId: remoteId,
    repliedMessage: partialText.repliedMessage,
    roomId: roomId,
    showStatus: showStatus,
    status: status,
    text: partialText.text,
    type: MessageType.text,
    updatedAt: updatedAt,
  );

  @override
  MessageModel copyWith({
    ChatUser? author,
    int? createdAt,
    String? id,
    PreviewData? previewData,
    String? remoteId,
    MessageModel? repliedMessage,
    String? roomId,
    bool? showStatus,
    Status? status,
    String? text,
    int? updatedAt,
  });

  /// Equatable props.
  @override
  List<Object?> get props => [
    author,
    createdAt,
    id,
    previewData,
    remoteId,
    repliedMessage,
    roomId,
    showStatus,
    status,
    text,
    updatedAt,
  ];
}

/// A utility class to enable better copyWith.
class _TextMessage extends TextMessageModel {
  const _TextMessage({
    required super.author,
    super.createdAt,
    required super.id,
    super.previewData,
    super.remoteId,
    super.repliedMessage,
    super.roomId,
    super.showStatus,
    super.status,
    required super.text,
    super.type,
    super.updatedAt,
  }) : super._();

  @override
  MessageModel copyWith({
    ChatUser? author,
    dynamic createdAt = _Unset,
    String? id,
    dynamic previewData = _Unset,
    dynamic remoteId = _Unset,
    dynamic repliedMessage = _Unset,
    dynamic roomId,
    dynamic showStatus = _Unset,
    dynamic status = _Unset,
    String? text,
    dynamic updatedAt = _Unset,
  }) => _TextMessage(
    author: author ?? this.author,
    createdAt: createdAt == _Unset ? this.createdAt : createdAt as int?,
    id: id ?? this.id,
    previewData:
        previewData == _Unset ? this.previewData : previewData as PreviewData?,
    remoteId: remoteId == _Unset ? this.remoteId : remoteId as String?,
    repliedMessage:
        repliedMessage == _Unset
            ? this.repliedMessage
            : repliedMessage as MessageModel?,
    roomId: roomId == _Unset ? this.roomId : roomId as String?,
    showStatus: showStatus == _Unset ? this.showStatus : showStatus as bool?,
    status: status == _Unset ? this.status : status as Status?,
    text: text ?? this.text,
    updatedAt: updatedAt == _Unset ? this.updatedAt : updatedAt as int?,
  );
}

class _Unset {}
