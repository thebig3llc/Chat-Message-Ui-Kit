import 'package:chat_message_core/chat_message_core.dart';
import 'package:chat_message_ui_kit/src/inherited/inherited_chat_theme.dart';
import 'package:chat_message_ui_kit/src/utils/functions.dart';
import 'package:flutter/material.dart';

/// Renders user's name as a message heading according to the theme.
class UserName extends StatelessWidget {
  /// Creates user name.
  const UserName({super.key, required this.author});

  /// Author to show name from.
  final ChatUser author;

  @override
  Widget build(BuildContext context) {
    final theme = InheritedChatTheme.of(context).theme;
    final color = getUserAvatarNameColor(author, theme.userAvatarNameColors);
    final name = getUserName(author);

    return name.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.userNameTextStyle.copyWith(color: color),
            ),
          );
  }
}
