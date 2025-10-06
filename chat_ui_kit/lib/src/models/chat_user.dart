import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'chat_user.g.dart';

/// A class that represents a chat user with all their profile information.
/// This is an immutable data class that uses Equatable for value comparison
/// and JsonSerializable for JSON serialization/deserialization.
@JsonSerializable()
@immutable
abstract class ChatUser extends Equatable {
  /// Private constructor to create a user instance.
  /// This is used internally by the factory constructors.
  const ChatUser._({
    this.createdAt,
    this.firstName,
    required this.id,
    this.imageUrl,
    this.lastName,
  });

  /// Unique identifier for the user - this is the primary key for user identification
  /// across the chat system. Must be unique and non-null.
  final String id;

  /// Timestamp when the user account was created, stored in milliseconds since epoch.
  /// This is optional and may be null for users created without timestamp tracking.
  final int? createdAt;

  /// User's first name - optional field for displaying user's given name.
  /// Can be null if the user hasn't provided a first name.
  final String? firstName;

  /// User's last name/surname - optional field for displaying user's family name.
  /// Can be null if the user hasn't provided a last name.
  final String? lastName;

  /// URL pointing to the user's avatar/profile image.
  /// This should be a valid HTTP/HTTPS URL pointing to an image resource.
  /// Can be null if the user doesn't have a profile image.
  final String? imageUrl;

  /// Factory constructor that creates a ChatUser instance from a JSON map.
  /// This is typically used when deserializing user data from an API response
  /// or local storage. Uses json_serializable generated code.
  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return _$ChatUserFromJson(json);
  }

  /// Converts this ChatUser instance to a JSON-serializable map.
  /// This is used when sending user data to an API or storing in local storage.
  /// Uses json_serializable generated code for consistent serialization.
  Map<String, dynamic> toJson() {
    return _$ChatUserToJson(this);
  }

  /// Main factory constructor for creating ChatUser instances.
  /// This is the primary way to create a new user - all parameters except 'id'
  /// are optional, allowing for flexible user creation with minimal required data.
  const factory ChatUser({
    int? createdAt,
    String? firstName,
    required String id,
    String? imageUrl,
    String? lastName,
  }) = _User;

  /// Creates a new ChatUser instance with updated values.
  /// Any parameter that is provided will override the existing value,
  /// while null parameters will keep the original values unchanged.
  /// This enables immutable updates to user data.
  ChatUser copyWith({
    int? createdAt,
    String? firstName,
    String? id,
    String? imageUrl,
    String? lastName,
  });

  /// Defines which properties are used for equality comparison.
  /// Two ChatUser instances are considered equal if all these properties match.
  /// This is used by Equatable to provide value-based equality instead of reference equality.
  @override
  List<Object?> get props => [createdAt, firstName, id, imageUrl, lastName];
}

/// Private implementation class that provides the concrete copyWith functionality.
/// This class extends ChatUser and implements the copyWith method with proper
/// handling of null values using the _Unset sentinel pattern.
class _User extends ChatUser {
  /// Constructor that delegates to the parent ChatUser private constructor.
  /// This maintains the same parameter structure while enabling the copyWith implementation.
  const _User({
    super.createdAt,
    super.firstName,
    required super.id,
    super.imageUrl,
    super.lastName,
  }) : super._();

  /// Implementation of copyWith that uses the _Unset pattern to distinguish
  /// between null values that should be set vs parameters that weren't provided.
  /// If a parameter equals _Unset, the original value is kept; otherwise the new value is used.
  @override
  ChatUser copyWith({
    dynamic createdAt = _Unset,
    dynamic firstName = _Unset,
    String? id,
    dynamic imageUrl = _Unset,
    dynamic lastName = _Unset,
    dynamic lastSeen = _Unset,
  }) => _User(
    createdAt: createdAt == _Unset ? this.createdAt : createdAt as int?,
    firstName: firstName == _Unset ? this.firstName : firstName as String?,
    id: id ?? this.id,
    imageUrl: imageUrl == _Unset ? this.imageUrl : imageUrl as String?,
    lastName: lastName == _Unset ? this.lastName : lastName as String?,
  );
}

/// Sentinel class used in copyWith to differentiate between explicit null values
/// and parameters that weren't provided. This allows copyWith to only update
/// the properties that were explicitly passed, leaving others unchanged.
class _Unset {}
