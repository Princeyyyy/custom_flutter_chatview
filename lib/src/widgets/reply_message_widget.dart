import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/models/models.dart';

import '../utils/constants/constants.dart';
import 'vertical_line.dart';

class ReplyMessageWidget extends StatelessWidget {
  const ReplyMessageWidget({
    super.key,
    required this.message,
    required this.currentUserId,
    this.onTap,
  });

  /// Provides message instance of chat.
  final Message message;

  final String currentUserId;

  /// Provides call back when user taps on replied message.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final replyBySender = message.replyMessage.replyBy == currentUserId;
    final textTheme = Theme.of(context).textTheme;
    final replyMessage = message.replyMessage.message;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          right: horizontalPadding,
          left: horizontalPadding,
          bottom: 4,
        ),
        constraints: const BoxConstraints(maxWidth: 280),
        child: Column(
          crossAxisAlignment:
              replyBySender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: replyBySender
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (!replyBySender)
                    const VerticalLine(
                      rightPadding: 4,
                    ),
                  Flexible(
                    child: Opacity(
                      opacity: 0.8,
                      child: message.replyMessage.messageType.isImage
                          ? Container(
                              height: 100,
                              width: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(replyMessage),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            )
                          : Container(
                              constraints: const BoxConstraints(
                                maxWidth: 280,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: _borderRadius(
                                  replyMessage: replyMessage,
                                  replyBySender: replyBySender,
                                ),
                                color: const Color(0xffff8aad),
                              ),
                              child: message.replyMessage.messageType.isVoice
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.mic,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 2),
                                        if (message.replyMessage
                                                .voiceMessageDuration !=
                                            null)
                                          Text(
                                            message.replyMessage
                                                .voiceMessageDuration!
                                                .toHHMMSS(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.25,
                                            ),
                                          ),
                                      ],
                                    )
                                  : Text(
                                      replyMessage,
                                      style: textTheme.bodyMedium!
                                          .copyWith(color: Colors.black),
                                    ),
                            ),
                    ),
                  ),
                  if (replyBySender)
                    const VerticalLine(
                      leftPadding: 4,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BorderRadiusGeometry _borderRadius({
    required String replyMessage,
    required bool replyBySender,
  }) =>
      replyBySender
          ? (replyMessage.length < 37
              ? BorderRadius.circular(replyBorderRadius1)
              : BorderRadius.circular(replyBorderRadius2))
          : (replyMessage.length < 29
              ? BorderRadius.circular(replyBorderRadius1)
              : BorderRadius.circular(replyBorderRadius2));
}
