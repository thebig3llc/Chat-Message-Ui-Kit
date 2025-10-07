import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A class that represents an image shown in a preview widget.
@immutable
class PreviewImage extends Equatable {
  /// Creates a preview image.
  const PreviewImage({required this.id, required this.uri});

  /// Unique ID of the image.
  final String id;

  /// Image's URI.
  final String uri;

  /// Equatable props.
  @override
  List<Object> get props => [id, uri];
}
