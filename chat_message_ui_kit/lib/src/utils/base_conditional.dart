import 'package:chat_message_ui_kit/src/utils/conditional.dart';

/// The abstract base class for a conditional import feature.
abstract class BaseConditional implements Conditional {}

/// Implemented in `browser_conditional.dart` and `io_conditional.dart`.
BaseConditional createConditional() {
  throw UnsupportedError('Cannot create a conditional');
}
