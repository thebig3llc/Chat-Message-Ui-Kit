import 'package:chat_message_ui_kit/src/enums/parsed_type.dart';
import 'package:flutter/widgets.dart';

class MatchText {
  MatchText({
    this.parsedType,
    this.pattern,
    this.style,
    this.onTap,
    this.renderText,
    this.renderWidget,
  });
  final ParsedType? parsedType;

  final String? pattern;

  final TextStyle? style;

  final Function(String)? onTap;

  /// A callback function that takes two parameter String & pattern
  ///
  /// @param str - is the word that is being matched
  /// @param pattern - pattern passed to the MatchText class
  ///
  /// eg: Your str is 'Mention [@allison:5455345]' where 5455345 is ID of this user
  /// and @allison the value to display on interface.
  /// Your pattern for ID & username extraction : `/\[(@[^:]+):([^\]]+)\]/`i
  /// Displayed text will be : Mention `@allison`
  Map<String, String> Function({required String str, required String pattern})?
  renderText;

  /// A callback function that takes the [text] the matches the [pattern] and returns
  /// the [Widget] to be displayed inside a [WidgetSpan]
  Widget Function({required String text, required String pattern})?
  renderWidget;
}
