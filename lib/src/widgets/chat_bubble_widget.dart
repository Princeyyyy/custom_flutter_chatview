import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/utils/constants/constants.dart';
import 'package:flutter/material.dart';

import '../../chatview.dart';
import 'message_time_widget.dart';
import 'message_view.dart';
import 'reply_message_widget.dart';
import 'swipe_to_reply.dart';

class ChatBubbleWidget extends StatefulWidget {
  const ChatBubbleWidget({
    required GlobalKey key,
    required this.message,
    required this.onLongPress,
    required this.slideAnimation,
    required this.onSwipe,
    required this.currentUserId,
    this.messageConfig,
    this.onReplyTap,
    this.shouldHighlight = false,
  }) : super(key: key);

  /// Represent current instance of message.
  final Message message;

  /// Give callback once user long press on chat bubble.
  final DoubleCallBack onLongPress;

  /// Provides slide animation when user swipe whole chat.
  final Animation<Offset>? slideAnimation;

  /// Provides configuration of all types of messages.
  final MessageConfiguration? messageConfig;

  /// Provides callback of when user swipe chat bubble for reply.
  final MessageCallBack onSwipe;

  final String currentUserId;

  /// Provides callback when user tap on replied message upon chat bubble.
  final Function(String)? onReplyTap;

  /// Flag for when user tap on replied message and highlight actual message.
  final bool shouldHighlight;

  @override
  State<ChatBubbleWidget> createState() => _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState extends State<ChatBubbleWidget> {
  String get replyMessage => widget.message.replyMessage.message;

  bool get isMessageBySender =>
      widget.message.messageSenderId == widget.currentUserId;

  FeatureActiveConfig? featureActiveConfig;
  ChatController? chatController;
  int? maxDuration;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (provide != null) {
      featureActiveConfig = provide!.featureActiveConfig;
      chatController = provide!.chatController;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (featureActiveConfig?.enableSwipeToSeeTime ?? true) ...[
          Visibility(
            visible: widget.slideAnimation?.value.dx == 0.0 ? false : true,
            child: Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: MessageTimeWidget(
                  messageTime: widget.message.createdAt,
                  isCurrentUser: isMessageBySender,
                ),
              ),
            ),
          ),
          SlideTransition(
            position: widget.slideAnimation!,
            child: _chatBubbleWidget(),
          ),
        ] else
          _chatBubbleWidget(),
      ],
    );
  }

  Widget _chatBubbleWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 5.0),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            isMessageBySender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: isMessageBySender
                ? SwipeToReply(
                    onLeftSwipe: featureActiveConfig?.enableSwipeToReply ?? true
                        ? () {
                            if (maxDuration != null) {
                              widget.message.voiceMessageDuration =
                                  Duration(milliseconds: maxDuration!);
                            }

                            widget.onSwipe(widget.message);
                          }
                        : null,
                    replyIconColor: Colors.black,
                    child: _messagesWidgetColumn(),
                  )
                : SwipeToReply(
                    onRightSwipe:
                        featureActiveConfig?.enableSwipeToReply ?? true
                            ? () {
                                if (maxDuration != null) {
                                  widget.message.voiceMessageDuration =
                                      Duration(milliseconds: maxDuration!);
                                }

                                widget.onSwipe(widget.message);
                              }
                            : null,
                    replyIconColor: Colors.black,
                    child: _messagesWidgetColumn(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _messagesWidgetColumn() {
    return Column(
      crossAxisAlignment:
          isMessageBySender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (replyMessage.isNotEmpty)
          ReplyMessageWidget(
            message: widget.message,
            onTap: () => widget.onReplyTap
                ?.call(widget.message.replyMessage.repliedMessageId),
            currentUserId: widget.currentUserId,
          ),
        MessageView(
          isLongPressEnable:
              (featureActiveConfig?.enableReactionPopup ?? true) ||
                  (featureActiveConfig?.enableReplySnackBar ?? true),
          message: widget.message,
          isMessageBySender: isMessageBySender,
          messageConfig: widget.messageConfig,
          onLongPress: widget.onLongPress,
          onDoubleTap: (message) => chatController?.setReaction(
            emoji: heart,
            messageId: message.id,
            userId: widget.currentUserId,
          ),
          shouldHighlight: widget.shouldHighlight,
          controller: chatController,
          highlightColor: Colors.grey,
          highlightScale: 1.1,
          onMaxDuration: _onMaxDuration,
        ),
      ],
    );
  }

  void _onMaxDuration(int duration) => maxDuration = duration;
}
