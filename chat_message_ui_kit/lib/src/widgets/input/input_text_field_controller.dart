import 'package:flutter/material.dart';

import '../../models/pattern_style.dart';

/// Enhanced text editing controller that provides real-time markdown highlighting in the input field.
/// Extends TextEditingController to add visual formatting for bold, italic, strikethrough, and code patterns
/// while the user types, giving immediate visual feedback for markdown syntax.
class InputTextFieldController extends TextEditingController {
  /// List of markdown patterns to detect and style in the input field.
  /// Each pattern defines a regex and corresponding TextStyle for visual highlighting.
  final List<PatternStyle> _listPatternStyle = [
    PatternStyle.bold, // **text** or __text__
    PatternStyle.italic, // *text* or _text_
    PatternStyle.lineThrough, // ~~text~~
    PatternStyle.code, // `text`
  ];

  /// Builds a styled TextSpan with markdown formatting applied to the input text.
  /// Called by the TextField to render text with visual highlighting for markdown patterns.
  /// Splits text into segments and applies appropriate styling to each pattern match.
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    // Collection to store all text spans (styled and unstyled)
    final children = <TextSpan>[];

    // Split text using a combined regex of all markdown patterns
    text.splitMapJoin(
      RegExp(
        _listPatternStyle
            .map((it) {
              return it.regExp.pattern;
            })
            .join('|'), // Combine all patterns with OR operator
      ),
      // Handle matched markdown patterns with styling
      onMatch: (match) {
        final text = match[0]!;
        // Find which pattern matched and get its corresponding style
        final patternStyle = _listPatternStyle.firstWhere((element) {
          return element.regExp.hasMatch(text);
        });

        // Create styled text span for the matched pattern
        final span = TextSpan(
          text: match.group(0),
          style: patternStyle.textStyle,
        );
        children.add(span);
        return span.toPlainText();
      },
      // Handle non-matched text with default styling
      onNonMatch: (text) {
        final span = TextSpan(text: text, style: style);
        children.add(span);
        return span.toPlainText();
      },
    );

    // Return the complete styled text span with all children
    return TextSpan(style: style, children: children);
  }
}
