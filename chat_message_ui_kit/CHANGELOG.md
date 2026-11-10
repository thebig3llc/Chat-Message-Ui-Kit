## 0.0.4

**BREAKING CHANGES**

* Message models and enums now come from [`chat_message_core`](https://pub.dev/packages/chat_message_core) `^0.0.4`, and this package no longer exports them: `MessageModel`, `TextMessageModel`, `ImageMessageModel`, `AudioMessageModel`, `VideoMessageModel`, `PartialTextModel`, `PartialImageModel`, `PartialAudioModel`, `PartialVideoModel`, `ChatUser`, `Room`, `Status` and `MessageType`. **Migration:** add `chat_message_core: ^0.0.4` to your `pubspec.yaml` and add `import 'package:chat_message_core/chat_message_core.dart';` wherever you use these types.
* `regexEmail` and `regexLink` are no longer exported. Use `ChatCoreRegex.regexEmail` and `ChatCoreRegex.regexLink` from `chat_message_core`. They are `static final`, not `const`, so they can't be used in constant expressions.
* Removed `getPreviewData` and `PreviewSize`. `LinkPreview` now uses `ChatCoreFunctions().getPreviewData` from `chat_message_core`. **Migration:** if you call `getPreviewData` yourself, call `ChatCoreFunctions().getPreviewData(...)` instead. It returns image `width` and `height` as `0` unless you pass an `imageSizeResolver`.
* Model behaviour now follows `chat_message_core` 0.0.4 (see its [changelog](https://pub.dev/packages/chat_message_core/changelog)). The changes most likely to affect you:
  * `toJson()` emits nested `author`, `repliedMessage` and `previewData` as maps, so `MessageModel.fromJson(message.toJson())` now round-trips. Before, it threw a type error.
  * Message equality includes `type`.
  * `AudioMessageModel.copyWith` treats an explicit `null` as "clear this field", like the other models.

**Features**

* `Conditional` is now exported, so `imageProviderBuilder` callbacks can be written as named functions with the full signature.

**Fixes**

* The default sent, delivered, seen and error status icons are now Material icons (`Icons.done`, `Icons.done_all`, `Icons.error_outline`). Before, they loaded image assets that this package doesn't ship, so they failed to load (and showed Flutter's error box in debug builds). Custom icons set through `ChatTheme` (`deliveredIcon`, `seenIcon`, `errorIcon`) still take precedence.
* `LinkPreview` picks up the link-preview fixes in `chat_message_core` 0.0.4:
  * Direct image links show an image preview without downloading the image body first.
  * Error responses (non-2xx) and non-HTML pages (PDF, video, ...) show only the link instead of a preview of the error page or garbage.
  * Pages that declare a non-UTF-8 charset are decoded correctly. Before, they returned empty data.
  * With `corsProxy` set, `PreviewData.link` holds the original URL instead of the proxied one.
  * A response counts as an image only when its `Content-Type` starts with `image/`. Before, any content type containing "image", such as `application/x-apple-diskimage`, matched.

**Example app**

* Depends on `chat_message_core` for its models.
* Dropped the Linux, macOS, Windows and web targets.

## 0.0.3

* **Breaking:** requires Dart SDK `^3.13.4` (was `^3.7.2`).
* Upgrade dependencies, including major bumps to `cached_network_image` 4.x and `diffutil_dart` 5.x. `equatable` now accepts 2.x and 3.x.
* Replace the deprecated `SizeTransition.axisAlignment` with `alignment` in the chat list and link preview animations.
* Example app: Android builds with Gradle 9.3.1, AGP 9.1.0 and Java 17; iOS uses Swift Package Manager instead of CocoaPods, adopts the UIScene lifecycle and targets iOS 15+.

## 0.0.2

* misc fixes and improvements

## 0.0.1

* Initial release.
