import 'package:chat_message_core/chat_message_core.dart';
import 'package:chat_message_ui_kit/src/inherited/inherited_chat_theme.dart';
import 'package:flutter/material.dart';

/// A class that represents a message status.
class MessageStatus extends StatelessWidget {
  /// Creates a message status widget.
  const MessageStatus({super.key, required this.status});

  /// Status of the message.
  final Status? status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case Status.delivered:
      case Status.sent:
        return InheritedChatTheme.of(context).theme.deliveredIcon != null
            ? InheritedChatTheme.of(context).theme.deliveredIcon!
            : Icon(
                Icons.done,
                color: InheritedChatTheme.of(context).theme.primaryColor,
                size: 16,
              );
      case Status.error:
        return InheritedChatTheme.of(context).theme.errorIcon != null
            ? InheritedChatTheme.of(context).theme.errorIcon!
            : Icon(
                Icons.error_outline,
                color: InheritedChatTheme.of(context).theme.errorColor,
                size: 16,
              );
      case Status.seen:
        return InheritedChatTheme.of(context).theme.seenIcon != null
            ? InheritedChatTheme.of(context).theme.seenIcon!
            : Icon(
                Icons.done_all,
                color: InheritedChatTheme.of(context).theme.primaryColor,
                size: 16,
              );
      case Status.sending:
        return InheritedChatTheme.of(context).theme.sendingIcon != null
            ? InheritedChatTheme.of(context).theme.sendingIcon!
            : Center(
                child: SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      InheritedChatTheme.of(context).theme.primaryColor,
                    ),
                  ),
                ),
              );
      default:
        return const SizedBox(width: 8);
    }
  }
}
