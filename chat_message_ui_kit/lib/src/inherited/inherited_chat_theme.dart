import 'package:flutter/widgets.dart';

import '../themes/chat_theme.dart';

/// InheritedWidget that provides ChatTheme configuration to all descendant widgets.
/// This enables any widget in the chat widget tree to access theme properties
/// without manually passing theme data through constructor parameters.
class InheritedChatTheme extends InheritedWidget {
  /// Creates an InheritedChatTheme widget that makes theme data available to descendants.
  /// The theme parameter contains all styling information for the chat interface.
  const InheritedChatTheme({
    super.key,
    required this.theme,
    required super.child,
  });

  /// Retrieves the nearest InheritedChatTheme from the widget tree.
  /// Used by child widgets to access theme configuration without prop drilling.
  /// Throws if no InheritedChatTheme is found in the widget tree.
  static InheritedChatTheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedChatTheme>()!;
  }

  /// The chat theme configuration containing all styling properties.
  /// Includes colors, text styles, dimensions, and widget customizations.
  final ChatTheme theme;

  /// Determines whether dependent widgets should be rebuilt when theme changes.
  /// Uses hashCode comparison to detect theme changes efficiently.
  @override
  bool updateShouldNotify(InheritedChatTheme oldWidget) {
    return theme.hashCode != oldWidget.theme.hashCode;
  }
}
