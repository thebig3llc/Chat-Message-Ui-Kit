import 'package:chat_message_ui_kit/src/models/chat_user.dart';
import 'package:flutter/material.dart';

import '../../enums/bubble_rtl_alignment.dart';
import '../../utils/functions.dart';
import '../../inherited/inherited_chat_theme.dart';

/// Renders user's avatar or initials next to a message.
class UserAvatar extends StatelessWidget {
  /// Creates user avatar.
  const UserAvatar({
    super.key,
    required this.author,
    this.bubbleRtlAlignment,
    this.imageHeaders,
    this.onAvatarTap,
  });

  /// Author to show image and name initials from.
  final ChatUser author;

  /// See [Message.bubbleRtlAlignment].
  final BubbleRtlAlignment? bubbleRtlAlignment;

  /// See [Chat.imageHeaders].
  final Map<String, String>? imageHeaders;

  /// Called when user taps on an avatar.
  final void Function(ChatUser)? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final color = getUserAvatarNameColor(
      author,
      InheritedChatTheme.of(context).theme.userAvatarNameColors,
    );
    final hasImage = author.imageUrl != null;
    final initials = getUserInitials(author);

    return Container(
      margin:
          bubbleRtlAlignment == BubbleRtlAlignment.left
              ? const EdgeInsetsDirectional.only(end: 8)
              : const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => onAvatarTap?.call(author),
        child: CircleAvatar(
          backgroundColor:
              hasImage
                  ? InheritedChatTheme.of(
                    context,
                  ).theme.userAvatarImageBackgroundColor
                  : color,
          backgroundImage:
              hasImage
                  ? NetworkImage(author.imageUrl!, headers: imageHeaders)
                  : null,
          radius: 16,
          child:
              !hasImage
                  ? Text(
                    initials,
                    style:
                        InheritedChatTheme.of(
                          context,
                        ).theme.userAvatarTextStyle,
                  )
                  : null,
        ),
      ),
    );
  }
}
