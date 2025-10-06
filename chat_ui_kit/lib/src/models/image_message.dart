import 'package:chat_ui_kit/src/enums/message_status.dart';
import 'package:chat_ui_kit/src/enums/message_type.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'message.dart';
import 'chat_user.dart' show ChatUser;
import 'partial_image.dart';

part 'image_message.g.dart';

/// A class that represents image message.
@JsonSerializable()
@immutable
abstract class ImageMessageModel extends MessageModel {
  /// Creates an image message.
  const ImageMessageModel._({
    required super.author,
    super.createdAt,
    this.height,
    required super.id,
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
    this.width,
  }) : super(type: type ?? MessageType.image);

  /// Image height in pixels.
  final double? height;

  /// The name of the image.
  final String name;

  /// Size of the image in bytes.
  final num size;

  /// The image source (either a remote URL or a local resource).
  final String uri;

  /// Image width in pixels.
  final double? width;

  /// Creates an image message from a map (decoded JSON).
  factory ImageMessageModel.fromJson(Map<String, dynamic> json) {
    return _$ImageMessageModelFromJson(json);
  }

  /// Converts an image message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() {
    return _$ImageMessageModelToJson(this);
  }

  const factory ImageMessageModel({
    required ChatUser author,
    int? createdAt,
    double? height,
    required String id,
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
    double? width,
  }) = _ImageMessage;

  /// Creates a full image message from a partial one.
  factory ImageMessageModel.fromPartial({
    required ChatUser author,
    int? createdAt,
    required String id,
    required PartialImageModel partialImage,
    String? remoteId,
    String? roomId,
    bool? showStatus,
    Status? status,
    int? updatedAt,
  }) => _ImageMessage(
    author: author,
    createdAt: createdAt,
    height: partialImage.height,
    id: id,
    name: partialImage.name,
    remoteId: remoteId,
    repliedMessage: partialImage.repliedMessage,
    roomId: roomId,
    showStatus: showStatus,
    size: partialImage.size,
    status: status,
    type: MessageType.image,
    updatedAt: updatedAt,
    uri: partialImage.uri,
    width: partialImage.width,
  );

  @override
  MessageModel copyWith({
    ChatUser? author,
    int? createdAt,
    double? height,
    String? id,
    Map<String, dynamic>? metadata,
    String? name,
    String? remoteId,
    MessageModel? repliedMessage,
    String? roomId,
    bool? showStatus,
    num? size,
    Status? status,
    int? updatedAt,
    String? uri,
    double? width,
  });

  /// Equatable props.
  @override
  List<Object?> get props => [
    author,
    createdAt,
    height,
    id,
    name,
    remoteId,
    repliedMessage,
    roomId,
    showStatus,
    size,
    status,
    updatedAt,
    uri,
    width,
  ];
}

/// A utility class to enable better copyWith.
class _ImageMessage extends ImageMessageModel {
  const _ImageMessage({
    required super.author,
    super.createdAt,
    super.height,
    required super.id,
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
    super.width,
  }) : super._();

  @override
  MessageModel copyWith({
    ChatUser? author,
    dynamic createdAt = _Unset,
    dynamic height = _Unset,
    String? id,
    dynamic metadata = _Unset,
    String? name,
    dynamic remoteId = _Unset,
    dynamic repliedMessage = _Unset,
    dynamic roomId,
    dynamic showStatus = _Unset,
    num? size,
    dynamic status = _Unset,
    dynamic updatedAt = _Unset,
    String? uri,
    dynamic width = _Unset,
  }) => _ImageMessage(
    author: author ?? this.author,
    createdAt: createdAt == _Unset ? this.createdAt : createdAt as int?,
    height: height == _Unset ? this.height : height as double?,
    id: id ?? this.id,
    name: name ?? this.name,
    remoteId: remoteId == _Unset ? this.remoteId : remoteId as String?,
    repliedMessage:
        repliedMessage == _Unset
            ? this.repliedMessage
            : repliedMessage as MessageModel?,
    roomId: roomId == _Unset ? this.roomId : roomId as String?,
    showStatus: showStatus == _Unset ? this.showStatus : showStatus as bool?,
    size: size ?? this.size,
    status: status == _Unset ? this.status : status as Status?,
    updatedAt: updatedAt == _Unset ? this.updatedAt : updatedAt as int?,
    uri: uri ?? this.uri,
    width: width == _Unset ? this.width : width as double?,
  );
}

class _Unset {}
