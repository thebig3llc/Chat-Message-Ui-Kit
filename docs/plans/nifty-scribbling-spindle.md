# Chat-Message-UI-Kit — Project Plan
## Adopt chat_message_core, bug fixes, performance, UI roadmap, release

> **Status:** Plan only. No `lib/` changes have been made for anything in this document.
> **Revised:** 2026-11-04. Every item was re-checked against the code on `develop` and against `chat_message_core` 0.0.4.
> **Paths** are relative to `chat_message_ui_kit/` unless they start at the repo root. Core paths are relative to `Chat-Message-Core/chat_message_core/`.

---

## Revision log

**2026-11-04**
- **The package split is replaced by adopting the existing `chat_message_core`.** That package (repo `thebig3llc/Chat-Message-Core`, 0.0.4 on pub.dev) already holds the models, enums, `calculateChatMessages`, link-preview fetching and regexes. The UI kit still carries its own duplicate copies. The old Phase 3 (create a core package, pub workspace, file map, barrels) is gone.
- **Several bugs are already fixed in core 0.0.4** and get fixed in the UI kit simply by adopting it: B1, B13 (most of it), B15, B20.
- **Work that now belongs in the core repo:** B5, B13c, the O(n²) list build (Fix 1 step 1) and the day comparison (C6). See section 4.
- **Fix 3 dropped.** Core deliberately keeps `Room` equality deep over `lastMessages` and documents it ("don't use `Room` as a map or set key; key by `room.id`").
- **Public API break accepted.** The UI kit stops exporting its own top-level `formatBytes`, `regexEmail`, `regexLink` and `getPreviewData`; consumers use core's `ChatCoreFunctions()` and `ChatCoreRegex`. Released as 0.1.0.
- **Fix 7 removed.** Its premise was false. `ImageStreamListener` overrides `==`, and two tear-offs of the same method compare equal, so the existing `removeListener` works.
- **Fix 6 corrected.** The old code removed characters from the controller's text, which breaks cursor and selection. It also used Python's `(?P<name>…)` syntax.
- **Fixes 1, 2, 5 and 8 narrowed and corrected:**
  - Fix 1's guard was missing config fields.
  - Fix 2's `InheritedModel` returned early.
  - Fix 5's hash guard still served stale widgets.
  - Fix 8 rewrote the list without covering scroll-to-message, pagination or the typing indicator.
- **Fix 4 replaced** by the `ParsedText` fixes. `MatchText` is still exported, because it appears in public signatures.
- **Release workflows added** at `.github/workflows/`, matching the core repo: CI on PRs and on pushes to `main`, and publishing on a `v<version>` tag push. CI currently fails; see Phase 0.
- **Doc moved** from `chat_message_ui_kit/docs/` to the repo-root `docs/` so it isn't published to pub.dev.

---

## Contents
1. [Summary](#summary)
2. [Phase 0 — Make CI green](#phase-0)
3. [Phase 1 — Adopt chat_message_core](#phase-1)
4. [Work in the chat_message_core repo](#core-work)
5. [Phase 2 — UI kit bugs](#phase-2)
6. [Phase 3 — Performance fixes (revised)](#phase-3)
7. [Phase 4 — Cleanup and lints](#phase-4)
8. [Phase 5 — UI roadmap](#phase-5)
9. [Docs, example app and tests](#docs-tests)
10. [Release process](#release)
11. [Migration guide](#migration)
12. [Rollout checklist](#rollout)
13. [Open decisions and edge cases](#open)

---

<a name="summary"></a>
## 1. Summary

| Phase | Content | Target release | Breaking |
|---|---|---|---|
| 0 | Make CI green: formatting, codegen, 11 failing tests | Before any release | No |
| 1 | Adopt `chat_message_core`, delete duplicate code | 0.1.0 | **Yes**: top-level helpers move to `ChatCoreFunctions`/`ChatCoreRegex` |
| — | Core repo fixes (section 4) | core 0.0.5 → UI kit bumps its constraint | Core decides |
| 2 | UI kit bugs, P0 and P1 | 0.1.0 | Behaviour only |
| 3 | Performance fixes 1, 2, 5, 6, 8 | 0.1.0 | No |
| 4 | Cleanup, dead code, stricter lints | 0.1.0 or 0.1.1 | No (removed files are not exported) |
| 5 | UI roadmap | 0.1.x and later | Mostly additive |

`chat_message_core: ^0.0.4` means `>=0.0.4 <0.0.5`. Every core release in the 0.0.x range therefore needs a constraint bump and a new UI kit release.

---

<a name="phase-0"></a>
## 2. Phase 0 — Make CI green

The new `verify.yml` (see section 10) runs the same checks as the core repo. Run locally on 2026-11-04 against `develop` plus uncommitted formatting edits:

| Check | Result | What to do |
|---|---|---|
| `flutter analyze --fatal-infos` (package and example) | Passes | — |
| `dart format --set-exit-if-changed .` | **Fails**: 41 files would change | Run `dart format .` and commit |
| Stale `.g.dart` check (`build_runner build`) | **Fails** two ways: (1) `build_runner` scans `example/*/flutter/ephemeral/.plugin_symlinks/**` and errors on plugin sources; (2) the committed `.g.dart` files differ from what the current `json_serializable` generates | Phase 1 deletes every `.g.dart` from the UI kit, so remove this step from `verify.yml` then. If CI has to be green before Phase 1, add a `build.yaml` limiting `sources` to `lib/**` and regenerate. |
| `flutter test` | **Fails**: 11 of 56 tests | See below |

The failing tests point at real bugs plus some test fragility:
- **JSON round-trip tests in `test/models/`** (`type '_User' is not a subtype of type 'Map<String, dynamic>'`). This is B15; core fixes it, so these tests go away in Phase 1.
- **Widget, integration and performance tests** fail on:
  - Network images that can't load under `flutter test` (`NetworkImageLoadException`).
  - Status icon assets that don't exist (B7).
  - `RenderFlex` overflows in the test viewport.
  - Finders that don't match anything (`Bad state: No element`).

  Fix the bugs. Then make the tests independent of the network and the viewport: mock the image provider and set the test surface size. Don't skip or weaken the tests.

---

<a name="phase-1"></a>
## 3. Phase 1 — Adopt chat_message_core

### Why
The UI kit duplicates core's models, enums and utilities. The copies have already drifted: core has fixes the UI kit lacks (B1, B13, B15, B20). Consumers that use both packages get two incompatible `MessageModel` types. Core's own `CLAUDE.md` already describes it as the data layer that the UI kit re-exports.

### Steps
1. **Add the dependency:** `chat_message_core: ^0.0.4` in `pubspec.yaml`.
2. **Delete the UI kit copies** that core provides:
   - `lib/src/enums/message_status.dart`, `message_type.dart`, `parsed_type.dart`
   - `lib/src/models/`: `message`, `text_message`, `image_message`, `audio_message`, `video_message`, `partial_text`, `partial_image`, `partial_audio`, `partial_video`, `chat_user`, `room`, `preview_data`, `date_header`, `message_spacer`, `unread_header_data`, `preview_image`, and every `.g.dart`
   - `lib/src/utils/regex.dart`
   - From `lib/src/utils/functions.dart`: `formatBytes`, `getUserInitials`, `getUserName`, `formattedDateTimeRep`, `calculateChatMessages`. Keep `getUserAvatarNameColor` (uses `Color`) and `consistsOfEmojis`.
   - `lib/src/utils/preview_data.dart`. Its Flutter-only part, `_getImageSize`, becomes the `imageSizeResolver` passed to core (see step 4).
3. **Update imports and call sites.** Replace `package:chat_message_ui_kit/src/models/...` and `.../enums/...` imports with `package:chat_message_core/chat_message_core.dart`. Files that call the moved helpers:
   - `widgets/chat/chat.dart`: `ChatCoreFunctions().calculateChatMessages(..., isWeb: kIsWeb)`. Core takes `isWeb` as a parameter instead of reading `kIsWeb`.
   - `widgets/linking/link_preview.dart`: `ChatCoreFunctions().getPreviewData(text, imageSizeResolver: ..., onError: ..., proxy: ..., requestTimeout: ..., userAgent: ...)`.
   - `utils/matchers.dart`: `ChatCoreRegex.regexEmail` / `regexLink`.
   - `inherited/inherited_user.dart`, `widgets/message/image_message.dart`, `text_message.dart`, `user_avatar.dart`, `user_name.dart`, `widgets/typing_indicator.dart`.
4. **Image size resolver:** a small UI-kit helper with the core signature `Future<({double height, double width})> Function(String url)`. It resolves `Image.network(url)` and **has a timeout** (B13e). It always removes its `ImageStreamListener`, including on error and timeout.
5. **Barrel** (`lib/chat_message_ui_kit.dart`):
   - Add `export 'package:chat_message_core/chat_message_core.dart';`.
   - Remove the lines for the deleted files, plus `src/utils/preview_data.dart`, the `regex.dart` `show` line and `formatBytes` from the `functions.dart` `show`.
   - Keep `consistsOfEmojis` and add `src/models/match_text.dart` (B21).
6. **Dependencies:**
   - Remove `json_annotation`, `http`, `html`, `build_runner`, `json_serializable` and `freezed`. Nothing left in the UI kit uses them: only `utils/preview_data.dart` imports `http`/`html`, and `freezed` is unused.
   - Keep `equatable` (Fix 2) and `intl` (`DateFormat` parameters on `Chat`).
   - `diffutil_dart` goes in Fix 8.
7. **Tests:**
   - `test/models/*` duplicates core's `test/models/` suite and fails on B15, which core fixes. Delete it in this phase.
   - Add a test that a `TextMessageModel` built from core renders in `Chat`. That shows the types are the same.
8. **CI:** remove the "Check generated code is up to date" step from `verify.yml`; no `.g.dart` files are left.
9. **Docs:** update `CLAUDE.md` (models now live in core), README, and CHANGELOG with a **BREAKING CHANGES** section.

### What consumers see
See the 0.1.0 migration guide (section 11).

---

<a name="core-work"></a>
## 4. Work in the chat_message_core repo

These live in core now, so they're fixed there and released as core 0.0.5. Then the UI kit bumps to `chat_message_core: ^0.0.5`.

| ID | Core location | Issue | Fix |
|---|---|---|---|
| B5 | `lib/src/models/message.dart:80` | `MessageType.values.firstWhere(...)` has no `orElse`, so an unknown or missing `type` throws `StateError`. An unknown `status` string throws `ArgumentError` (no `unknownEnumValue` anywhere). A backend that adds a message type crashes older apps. | See D1. Use `@JsonKey(unknownEnumValue: …)` for `status`. |
| B13c | `lib/src/utils/functions.dart:552-570` (`_getActualImageUrl`) | Relative image paths are appended to the full page URL: `/a.png` on `https://x.com/blog/p.html` becomes `https://x.com/blog/p.html/a.png`. | `Uri.parse(pageUrl).resolve(imageUrl)` |
| P1 | `lib/src/utils/functions.dart:196`, `:204` | `calculateChatMessages` builds its list with `insert(0, …)` for every message, which is O(n²). | Append, then reverse once. Core's `test/utils/calculate_chat_messages_test.dart` guards the output. |
| C6 | `lib/src/utils/functions.dart:155` | The "different day" check compares only `.day`. | Compare year, month and day. |

**Already fixed in core 0.0.4** (verified):
- `copyWith` `_Unset` defaults (B1).
- `explicit_to_json: true` in `build.yaml` (B15).
- No dead `metadata`/`lastSeen` parameters (B20).
- Link preview: status and content-type checked before reading, charset-aware decoding, the proxy kept out of `link`, one timeout covering the whole fetch, and errors passed to `onError` (B13 a, b, d, f).

---

<a name="phase-2"></a>
## 5. Phase 2 — UI kit bugs

Each item was confirmed by reading the code. Tests are listed at the end of the section.

### P0 — crash or data loss

| ID | Location | What goes wrong | Fix |
|---|---|---|---|
| B2 | `lib/src/widgets/chat/chat.dart:38`, read at `:388`, `:395`, `:403` | `_chatMessageAutoScrollIndexById` is a top-level map shared by every `Chat` and never cleared. A second `Chat` (another route or tab) overwrites its entries. `scrollToMessage`/`highlightMessage` then read it with `!` and either crash on null or scroll to the wrong index. | Make it a field on `_ChatState`, rebuilt in `_refreshAutoScrollMapping`. For an unknown id, see D4. |
| B3 | `chat.dart:364`, `:601` | `dispose()` disposes `_scrollController` even when it came from `widget.scrollController`. A parent that reuses its controller then gets "used after being disposed". Because the field is `late final`, a swapped controller is also ignored. | Track ownership, dispose only what `Chat` created, and handle a swap in `didUpdateWidget`. |
| B4 | `lib/src/widgets/input/input.dart:300` | `dispose()` disposes `_textController` even when it came from `options.textEditingController`. | Same ownership pattern as B3. |
| B6 | `chat.dart:540-543` → `lib/src/widgets/optimized_image_gallery.dart:74` | `indexWhere` returns `-1` when the tapped image isn't in the gallery (on web, only `http`/`blob` URIs are added). That gives `PageController(initialPage: -1)`. With an empty gallery, `clamp(0, -1)` throws. | When the index is `-1`, don't open the gallery. |
| B7 | `lib/src/widgets/message/message_status.dart:20-40` | The default delivered, error and seen icons are `Image.asset('assets/icon-*.png', package: 'flutter_chat_ui')`. This package has no `assets/` folder and a different name, so every status shows a broken image unless the theme supplies icons. | Use Material `Icons` (`done_all`, `error_outline`, …). |
| B8 | `lib/src/widgets/parsed_text.dart:173`, `:186` | `mapping.onTap!(matchText)` crashes on tap for any `MatchText` without an `onTap`. | Use `?.call`, and attach a recognizer only when `onTap` is set. |

### P1 — wrong behaviour

| ID | Location | What goes wrong | Fix |
|---|---|---|---|
| B9 | `lib/src/widgets/message/message.dart:294` | `message is TextMessage` compares a model with the *widget* class, so it's always false. Emoji enlargement and `hideBackgroundOnEmojiMessages` never take effect. | `message is TextMessageModel` |
| B10 | `lib/src/widgets/message/image_message.dart` | There's no `didUpdateWidget`, so a changed `uri` or headers keep the old provider. There's no `onError`: when `width`/`height` are null and the load fails, the bubble stays 0×0, which is invisible. | Re-resolve in `didUpdateWidget`; add `onError` and an error placeholder. |
| B11 | `lib/src/widgets/image_gallery.dart:62-63` → `optimized_image_gallery.dart:248` | `ResizeImage(width: 2048, height: 2048)` uses the default `ResizeImagePolicy.exact`, so a 4032×3024 photo is decoded at 2048×2048 and looks distorted. | `policy: ResizeImagePolicy.fit` |
| B12 | `optimized_image_gallery.dart:318` | `PopScope` leaves `canPop` at its default of `true`. The gallery is an overlay inside `Chat`, so Android back pops the whole chat route. | Set `canPop: false` and close the gallery in `onPopInvokedWithResult`. |
| B13e | new resolver (Phase 1, step 4) | The image size lookup has no timeout today (`lib/src/utils/preview_data.dart:208`). | Add a timeout in the resolver. |
| B14 | `lib/src/widgets/linking/link_preview.dart` | A fetch starts whenever `previewData` is null. If the app doesn't write the result back into the message, the preview is fetched again every time the bubble is recreated, e.g. on scrolling back into view. | A small in-package LRU keyed by URL, plus documentation that apps should persist `previewData`. |
| B16 | `lib/src/widgets/chat/optimized_chat_list.dart:184-214` | New messages are wrapped in an animation widget, then unwrapped about 300 ms later. The widget type changes, so the subtree's state is lost: images re-resolve and previews re-fetch. | Always use the same wrapper type. |
| B17 | `optimized_chat_list.dart:239-270` | (a) `notification.depth` isn't checked. (b) When the list is shorter than the viewport, `maxScrollExtent` is 0, so every scroll notification fires `onEndReached`. (c) The future from `onEndReached!().whenComplete(...)` is thrown away. | Check `depth == 0` and `maxScrollExtent > 0`; await in a try/catch and report errors. |
| B18 | `chat.dart:381` | `scrollToMessage` is declared `void … async`, so callers can't await it and its errors are unhandled. | Return `Future<void>`. This is source-compatible. |
| B19 | `chat.dart:426-429` | `mounted` is checked before `Future.delayed(scrollDelay)` but not after. | Check again after the delay. |
| B21 | `lib/chat_message_ui_kit.dart` | `MatchText` is the type of `TextMessageOptions.matchers` but isn't exported, so consumers can't write custom matchers. `PreviewData` and `ParsedType` are covered by re-exporting core. | Export `src/models/match_text.dart`. |

**Check, may be intentional:** `input.dart:192` uses `Focus(autofocus: !widget.options.autofocus)`. The comment there says the inversion is deliberate. Confirm the behaviour on device before changing it.

### Phase 2 tests
- **B2:** two `Chat` widgets; `scrollToMessage` on the first after the second is built. An unknown id follows D4.
- **B3/B4:** pump with an external controller, unmount, then use the controller (no throw). Swap the controller during a rebuild.
- **B6:** tapping an image that isn't in the gallery doesn't throw.
- **B7:** `find.byIcon` for each status, or a golden test.
- **B8:** tapping a `MatchText` that has no `onTap`.
- **B9:** an emoji-only message renders at the enlarged size.
- **B13e:** a resolver that never completes times out, and the listener is removed.
- **B17:** a short list doesn't call `onEndReached` on every scroll; an `onEndReached` that throws is reported.

---

<a name="phase-3"></a>
## 6. Phase 3 — Performance fixes (revised)

### Fix 1 — `calculateChatMessages()` on every parent rebuild
**File:** `lib/src/widgets/chat/chat.dart`. The O(n) rewrite of the function itself is in core (section 4, P1).

`didUpdateWidget` (which `initState` also calls with `widget` itself) rebuilds the whole list on every parent `setState`. Guard it:

```dart
@override
void didUpdateWidget(covariant Chat oldWidget) {
  super.didUpdateWidget(oldWidget);
  // initState calls didUpdateWidget(widget), so identical() marks the first build.
  if (widget.messages.isNotEmpty &&
      (identical(oldWidget, widget) || _chatInputsChanged(oldWidget))) {
    _recomputeChatMessages();
  }
}

bool _chatInputsChanged(Chat old) =>
    !listEquals(widget.messages, old.messages) ||
    widget.user != old.user ||
    widget.customDateHeaderText != old.customDateHeaderText ||
    widget.dateFormat != old.dateFormat ||
    widget.dateHeaderThreshold != old.dateHeaderThreshold ||
    widget.dateIsUtc != old.dateIsUtc ||
    widget.dateLocale != old.dateLocale ||
    widget.groupMessagesThreshold != old.groupMessagesThreshold ||
    widget.showUserNames != old.showUserNames ||
    widget.timeFormat != old.timeFormat ||
    widget.scrollToUnreadOptions.lastReadMessageId !=
        old.scrollToUnreadOptions.lastReadMessageId;
```

`listEquals` returns early when the two lists are `identical`. Its element comparisons use `Equatable`, which is much cheaper than rebuilding. Note for consumers: `customDateHeaderText` (a closure) and `DateFormat` compare by identity, so create them once rather than inline in `build`.

**Isolate (`compute`): not now.** Re-measure after the core O(n) fix. If it's ever added:
- Use a generation counter so a stale result can't overwrite a newer one.
- Keep showing the previous list while computing.
- Fall back to the synchronous path when `customDateHeaderText` is set, because a closure may not be sendable.
- On web, `compute` runs on the same thread, so it has no effect there.

### Fix 2 — theme and user change detection
**Files:** `lib/src/themes/chat_theme.dart`, `lib/src/inherited/inherited_chat_theme.dart`, `lib/src/inherited/inherited_user.dart`

Today `InheritedChatTheme.updateShouldNotify` compares `hashCode`. `ChatTheme` doesn't override it, so that's identity: a theme built inline in `build` notifies every dependent on every rebuild.

- `ChatTheme` gets value equality through `Equatable`, with `props` listing all 57 fields (see D5).
- `InheritedChatTheme.updateShouldNotify` becomes `theme != oldWidget.theme`.
- `InheritedUser.updateShouldNotify` becomes `user != oldWidget.user`. Today it compares only `id`, so avatar and name changes are missed.
- Document that the 7 `Widget?` icon fields compare by identity, so consumers should use `const` icons.
- **`InheritedModel` is deferred.** It only helps if the 104 `InheritedChatTheme.of` call sites switch to `aspectOf`. If it's added later, `updateShouldNotifyDependent` must check every aspect, not return after the first match.

### Fix 3 — dropped
Core keeps `Room` equality deep over `lastMessages` on purpose (see core's `CLAUDE.md`). The UI kit doesn't compare `Room`s.

### Fix 4 — replaced
Making `MatchText` `Equatable` gains nothing, because nothing compares matchers. The real `ParsedText` problems are B8 and C3. `MatchText` is still exported (B21).

### Fix 5 — remove widget caching
**Files:** `optimized_chat_list.dart` (`_buildCachedItem`), `lib/src/utils/message_cache_manager.dart`

A cached widget depends on the grouping flags, the theme and every builder, not just the message, so even a hash guard serves stale output.
- Call `widget.itemBuilder` directly.
- Delete `MessageCacheManager` (not exported).
- Keep the new-message animation, using a stable wrapper (B16).

### Fix 6 — regex rebuilt on every keystroke (corrected)
**File:** `lib/src/widgets/input/input_text_field_controller.dart`

The span's text must stay identical to `text`; removing markdown characters breaks cursor and selection offsets.

```dart
// One named group per pattern, so a match identifies its style
// without re-running each regex.
late final RegExp _combinedPattern = RegExp(
  [
    for (var i = 0; i < _listPatternStyle.length; i++)
      '(?<p$i>${_listPatternStyle[i].regExp.pattern})',
  ].join('|'),
);

@override
TextSpan buildTextSpan({
  required BuildContext context,
  TextStyle? style,
  required bool withComposing,
}) {
  final children = <TextSpan>[];
  text.splitMapJoin(
    _combinedPattern,
    onMatch: (match) {
      final m = match as RegExpMatch;
      var i = 0;
      while (m.namedGroup('p$i') == null) {
        i++;
      }
      final patternStyle = _listPatternStyle[i];
      children.add(TextSpan(
        text: m[0], // keep the full text, markers included
        style: style?.merge(patternStyle.textStyle) ?? patternStyle.textStyle,
      ));
      return '';
    },
    onNonMatch: (nonMatch) {
      children.add(TextSpan(text: nonMatch, style: style));
      return '';
    },
  );
  return TextSpan(style: style, children: children);
}
```

Test that the concatenated `toPlainText()` always equals `controller.text`. Known limitation, out of scope: `withComposing` is ignored.

### Fix 7 — removed
`ImageStreamListener` defines `==` over `onImage`, `onChunk`, `onError` and `reportErrors` (Flutter `painting/image_stream.dart`), and two tear-offs of the same method on the same object compare equal. The existing `removeListener` call works. The real image problems are B10 and B11.

### Fix 8 — `OptimizedChatList` isolate
**File:** `optimized_chat_list.dart`

Spawning an isolate to compute a `Set` difference of message ids costs more than the work itself.
- Replace `_calculateDiffsInIsolate` with a synchronous set difference.
- Remove the internal `enableIsolateForDiff`/`diffThreshold` parameters. `ChatList` hardcodes them at `chat_list.dart:109-110`.
- Drop the `SliverAnimatedList` + `diffutil_dart` rewrite. It would have to reimplement scroll-to-message, pagination and the typing indicator.
- `diffutil_dart` is declared but never imported, so remove it from `pubspec.yaml`.

---

<a name="phase-4"></a>
## 7. Phase 4 — Cleanup and lints

| ID | Location | Issue | Fix |
|---|---|---|---|
| C2 | `lib/src/utils/functions.dart:90-93` (`consistsOfEmojis`) | The emoji `RegExp`s (about 10 KB of pattern) are rebuilt on every `TextMessage` build | Make them top-level `final`s |
| C3 | `parsed_text.dart:163`, `:185` | `TapGestureRecognizer`s are created in `build` of a `StatelessWidget` and never disposed | Make it stateful and own the recognizers, or use a `WidgetSpan` + `GestureDetector` |
| C4 | `optimized_image_gallery.dart:199-204` | Closing the gallery evicts every image, so reopening downloads them again | Let `ImageCache` manage eviction |
| C5 | `optimized_image_gallery.dart:183` | `debugPrint` in release builds | Remove it, or guard with `kDebugMode` |
| C7 | dead code | `performance_optimized_chat.dart` is imported by nothing, yet README advertises it, and it's a stub (its send button sends the literal `'Test message'`). `lazy_image_message.dart` is used only by that file. `cached_image_provider.dart` and `image_compression.dart` are imported only by `test/performance/image_gallery_memory_test.dart`. | Delete all four and that test. None are exported. |
| C8 | `test/input.dart`, `test/app_messaging_ui_test.dart` | One is empty; the other pumps an empty widget | Replace with real `Input` and `Chat` tests |
| C9 | `analysis_options.yaml` | Missing `unawaited_futures`, `discarded_futures`, `avoid_void_async`, `cancel_subscriptions`, `close_sinks` and `strict-casts`. These would have caught B17(c) and B18. | Enable them and fix the new warnings in the same PR |

---

<a name="phase-5"></a>
## 8. Phase 5 — UI roadmap

Effort: S is under a day, M is one to three days, L is more than three days. The "Evidence" column says what exists today. Items that need a model change (U14, U16, U17, U18) start in core.

### Theming
| ID | Item | Evidence | Effort |
|---|---|---|---|
| U1 | `DarkChatTheme` | Only `DefaultChatTheme` exists (`chat_theme.dart:276`). The example app mentions a `DarkChatTheme` that doesn't exist. | S |
| U2 | `ChatTheme.fromColorScheme(ColorScheme)` with Material 3 defaults | Nothing reads `Theme.of(context)` | M |
| U3 | `ChatTheme.copyWith` | 57 fields and no `copyWith` | M |
| U4 | Bubble shape options: radius per corner, optional tail painter | One `messageBorderRadius` value; the "tail" is a zeroed corner (`message.dart:296-319`) | M |
| U5 | Image bubble colour by sender | Image bubbles always use `secondaryColor` (`message.dart:210-213`) | S |
| U6 | Give `bubbleBuilder` the computed radius and `isAuthor` | It gets only `message` and `nextMessageInGroup` (`message.dart:77-82`) | S |

### Layout
| ID | Item | Evidence | Effort |
|---|---|---|---|
| U7 | Timestamp and status inside the bubble | Time appears only in date headers | M |
| U8 | "Today"/"Yesterday" date headers, localized | Today's header shows only the time. The formatting is now core's `formattedDateTimeRep`, so the label needs either a core hook or `customDateHeaderText`. | S |
| U9 | Sticky date header while scrolling | None | M |
| U10 | Jump-to-latest button with a new-message count | None | M |
| U11 | Density option (compact or comfortable) | Spacing is fixed | S |

### Interactions
| ID | Item | Evidence | Effort |
|---|---|---|---|
| U12 | Reply: swipe gesture, quoted preview in the bubble, reply banner in `Input` | `MessageModel.repliedMessage` exists but nothing renders it; only a raw `slidableMessageBuilder` hook exists | L |
| U13 | Long-press context menu builder (copy, reply, delete) | Only the raw `onMessageLongPress` | M |
| U14 | Reactions: model field (core), row under the bubble, builder | No field | L |
| U15 | "Edited" label from `updatedAt`, and a deleted-message placeholder | `updatedAt` is never read | S/M |

### Message types
| ID | Item | Evidence | Effort |
|---|---|---|---|
| U16 | File/document bubble and `MessageType.file` (core) | `documentIcon` and both document icon colours are in `ChatTheme` but unused; the l10n key `fileButtonAccessibilityLabel` is unused | M |
| U17 | System messages (core) | None | M |
| U18 | Custom type plus a fallback bubble for unknown types | Ties into B5/D1 | M |
| U19 | Default voice-note and video bubbles | Without builders they render `const SizedBox()` (`message.dart:234-236`, `268-270`), though README claims support. See D3. | L |

### Input
| ID | Item | Evidence | Effort |
|---|---|---|---|
| U20 | Configurable `maxLines`, `textCapitalization` and padding; leading/trailing slots | Hardcoded `maxLines: 5` and `TextCapitalization.sentences` (`input.dart:246-256`) | S |
| U21 | Reply/edit banner above the field | With U12 | M |
| U22 | Slots for voice-record and emoji-picker buttons (no new dependencies) | None | S |

### Accessibility and RTL
| ID | Item | Evidence | Effort |
|---|---|---|---|
| U23 | `Semantics` for bubbles (author, time, status), images, avatars and status icons | Only the send button has `Semantics` (`send_button.dart:27`) | M |
| U24 | Respect system text scaling | `parsed_text.dart:223` forces `TextScaler.linear(textScaleFactor)`; the typing indicator uses a fixed scale | S |
| U25 | 48×48 tap targets | The send button is constrained to `minWidth/minHeight: 24` (`send_button.dart:30`) | S |
| U26 | RTL: use `EdgeInsetsDirectional`/`AlignmentDirectional` | `input.dart:207-208` forces `TextDirection.ltr`; `message.dart:322-348` uses absolute alignment | M |

### Localization
| ID | Item | Evidence | Effort |
|---|---|---|---|
| U27 | Move hardcoded English into `ChatL10n` | `typing_indicator.dart:236-240` ("is typing", "and", "others"); `optimized_image_gallery.dart:278`, `299`, `309` ("Loading image…", "Failed to load image", "Retry") | S |
| U28 | Swedish class `ChatL10nSe`: the language code is `sv` | `chat_l10n.dart:195` | S, keeping a deprecated alias |
| U29 | Use `fileButtonAccessibilityLabel` in U16 | Defined but unused | S |

---

<a name="docs-tests"></a>
## 9. Docs, example app and tests

**README rewrite** (`README.md`):
- `TextMessage(` at line 53 should be `TextMessageModel(`.
- `PartialTextMessage` at line 63 should be `PartialTextModel`.
- `PerformanceOptimizedChat` (line 84) isn't exported and gets deleted in C7.
- Fix the broken code fences.
- Remove claims that aren't true yet: ARIA support, and audio/video without builders.
- Explain that models come from `chat_message_core` and are re-exported.

**Example app as a variations gallery:**
- Light/dark (U1), RTL, a locale switcher, custom builders, typing indicator, pagination, and reply once U12 lands.
- Fix the dead `source.unsplash.com` URL (`example/lib/chats.dart:169`) and the comment about the non-existent `DarkChatTheme` (`:233`).

**Tests:**
- The Phase 2 tests.
- Text-length invariant test for the input controller (Fix 6).
- Golden tests for each theme variant and for the status icons.
- No tests exist today for: `Input`, the send and attachment buttons, link previews, `ParsedText` and the matchers, l10n, the inherited widgets, `consistsOfEmojis`, the unread header, or RTL.
- Model and `calculateChatMessages` coverage lives in core.

**CHANGELOG:** order entries newest first, add one entry per release, and put API breaks under **BREAKING CHANGES**. `publish.yml` refuses a tag whose version has no `## <version>` heading.

---

<a name="release"></a>
## 10. Release process

The workflows match the `chat_message_core` repo.

| File | Runs on | Does |
|---|---|---|
| `.github/workflows/verify.yml` | Called by the other two | Formatting check, `flutter analyze --fatal-infos` (package and example), stale `.g.dart` check (remove in Phase 1), `flutter test`. Runs plain `flutter pub get`, because the package's `pubspec.lock` is gitignored. |
| `.github/workflows/ci.yml` | Pull requests and pushes to `main` | Runs `verify.yml` |
| `.github/workflows/publish.yml` | Pushing a tag matching `v[0-9]+.[0-9]+.[0-9]+*` | Checks the tag equals `v<pubspec version>`, that CHANGELOG has `## <version>` and that the tagged commit is on `main`. Then runs `verify.yml`, then publishes through `dart-lang/setup-dart/.github/workflows/publish.yml@v1` using OIDC in the `pub.dev` environment (no secrets). |

A push to `main` does not publish by itself. pub.dev only accepts GitHub Actions publishing from a tag push.

**One-time setup:**
1. pub.dev → `chat_message_ui_kit` → Admin → Automated publishing. Enable GitHub Actions with:
   - Repository: `thebig3llc/Chat-Message-Ui-Kit`
   - Tag pattern: `v{{version}}`
   - "Require GitHub Actions environment" set to `pub.dev`
2. GitHub → Settings → Environments → create `pub.dev` and add yourself under Required reviewers.

**To release:**
1. Bump `version:` in `chat_message_ui_kit/pubspec.yaml`.
2. Add a matching `## <version>` heading to `CHANGELOG.md`.
3. Merge to `main`.
4. Run `git tag v<version> && git push origin v<version>`.
5. Approve the publish job in GitHub Actions.

When the release needs a new core version, release core first (core repo, same steps), then bump the `chat_message_core` constraint here.

---

<a name="migration"></a>
## 11. Migration guide

### 0.1.0

**BREAKING CHANGES**
- **Top-level helpers removed** (they come from `chat_message_core` now):

  | Before | After |
  |---|---|
  | `formatBytes(size)` | `ChatCoreFunctions().formatBytes(size)` |
  | `regexEmail`, `regexLink` | `ChatCoreRegex.regexEmail`, `ChatCoreRegex.regexLink` |
  | `getPreviewData(text, proxy:, requestTimeout:, userAgent:)` | `ChatCoreFunctions().getPreviewData(text, imageSizeResolver:, onError:, proxy:, requestTimeout:, userAgent:)`. Without `imageSizeResolver`, image width and height are `0.0`. |

- **`copyWith` parameters that never did anything are gone:** `metadata` on the image and video models, `lastSeen` on `ChatUser`.
- **`toJson()` is deep:** nested models become maps. Output that goes through `jsonEncode` is unchanged; code that read objects out of the map must read maps instead.
- **Controllers:** `Chat` no longer disposes a `scrollController` you pass in, and `Input` no longer disposes your `textEditingController`. Dispose them yourself (B3, B4).

**Other changes**
- **Imports don't change:** `chat_message_ui_kit` re-exports `chat_message_core`. Non-Flutter code can depend on `chat_message_core` directly.
- **Newly exported:** `ChatCoreFunctions`, `ChatCoreRegex`, `PreviewData`, `PreviewDataImage`, `ParsedType`, `DateHeader`, `MessageSpacer`, `UnreadHeaderData`, `PreviewImage` (from core) and `MatchText`.
- **`copyWith` no longer clears `roomId`** when you leave it out.
- **Link previews:** non-2xx pages no longer produce a preview, and `link` is the original URL even when a proxy is used.
- **Status icons:** the defaults are now Material icons instead of broken asset images.
- **Emoji enlargement** now works. Messages that are only emoji render larger unless `emojiEnlargementBehavior` is `never`.
- **`scrollToMessage`** returns `Future<void>`. Existing call sites still compile.
- **`Room` equality is unchanged** (still deep over `lastMessages`).

---

<a name="rollout"></a>
## 12. Rollout checklist

### Before the next release
- [ ] Phase 0: `dart format .`; fix or replace the 11 failing tests; codegen step resolved (Phase 1 removes it)
- [ ] One-time pub.dev and GitHub environment setup (section 10)

### 0.1.0
- [ ] Phase 1: adopt `chat_message_core` ^0.0.4 (or ^0.0.5 if the core work is released first)
- [ ] Phase 2: UI kit bugs, with tests
- [ ] Phase 3: Fixes 1, 2, 5, 6, 8
- [ ] Phase 4: cleanup C2–C9
- [ ] README, CLAUDE.md and CHANGELOG (with BREAKING CHANGES)
- [ ] Tag `v0.1.0`

### Core repo (any time, then bump the constraint here)
- [ ] B5, B13c, P1 (O(n) list build), C6 → core 0.0.5

### 0.1.x and later
- [ ] UI roadmap items, in priority order: U1, U8, U23–U27, U12, U16, U18, then the rest
- [ ] Example app gallery and golden tests, growing with each UI item

---

<a name="open"></a>
## 13. Open decisions and edge cases

### Decisions needed before implementing
| ID | Question | Options |
|---|---|---|
| D1 | What should core's `fromJson` do with an unknown `type`? (B5) | Throw a clear `FormatException` naming the value, or map it to an `unsupported` type that the UI kit renders as a fallback bubble (U18) |
| D2 | What should `LinkPreview` do with core's `onError`? | Ignore it, or forward it through a new `Chat.onPreviewError` callback |
| D3 | How should audio and video work by default? (U19) | Add player dependencies (`just_audio`, `video_player`), or stay builder-only and correct the README |
| D4 | What should `scrollToMessage` do with an unknown id? (B2) | Return without scrolling, or throw `ArgumentError` |
| D5 | Is a `ChatTheme` that consumers `implements` (rather than `extends`) supported? (Fix 2) | If yes, add `props` with a default implementation, or keep hand-written `==` |

### Edge cases to cover while implementing
- An empty `messages` list. `build` already shows `emptyState` when `widget.messages.isEmpty`; keep that.
- Messages without `createdAt` (date headers and grouping skip them; keep that).
- `lastReadMessageId` not found in the list: no unread header, and scroll-on-open silently does nothing. Document it or report it.
- Images with `width`/`height` set to 0 or null (B10), and image-size lookups that never complete (B13e).
- Web-only URI restrictions in the gallery (B6).
- External controllers swapped between builds (B3, B4).
- A core release that changes the shape of `calculateChatMessages`'s output (the `Map` keys `message`, `nextMessageInGroup`, `showName`, `showStatus`). The UI kit depends on those keys, so pin the core constraint and cover it with a `Chat` render test.
