import 'dart:convert';

import 'package:chat_message_ui_kit/src/utils/conditional.dart';
import 'package:flutter/widgets.dart';

/// A valid 1x1 transparent PNG.
final _transparentPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

/// An `imageProviderBuilder` that ignores the URI and returns an in-memory
/// image. Widget tests answer every HTTP request with status 400, so network
/// images would otherwise fail to load.
ImageProvider testImageProviderBuilder({
  required String uri,
  required Map<String, String>? imageHeaders,
  required Conditional conditional,
}) => MemoryImage(_transparentPng);
