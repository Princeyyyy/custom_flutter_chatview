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
    this.chatBubbleConfig,
    this.repliedMessageConfig,
    this.swipeToReplyConfig,
    this.messageTimeTextStyle,
    this.messageTimeIconColor,
    this.messageConfig,
    this.onReplyTap,
    this.shouldHighlight = false,
  }) : super(key: key);

  /// Represent current instance of message.
  final Message message;

  /// Give callback once user long press on chat bubble.
  final DoubleCallBack onLongPress;

  /// Provides configurations related to chat bubble such as padding, margin, max
  /// width etc.
  final ChatBubbleConfiguration? chatBubbleConfig;

  /// Provides configurations related to replied message such as textstyle
  /// padding, margin etc. Also, this widget is located upon chat bubble.
  final RepliedMessageConfiguration? repliedMessageConfig;

  /// Provides configurations related to swipe chat bubble which triggers
  /// when user swipe chat bubble.
  final SwipeToReplyConfiguration? swipeToReplyConfig;

  /// Provides textStyle of message created time when user swipe whole chat.
  final TextStyle? messageTimeTextStyle;

  /// Provides default icon color of message created time view when user swipe
  /// whole chat.
  final Color? messageTimeIconColor;

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

  bool get isMessageBySender => widget.message.messageSenderId == widget.currentUserId;

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
                  messageTimeIconColor: widget.messageTimeIconColor,
                  messageTimeTextStyle: widget.messageTimeTextStyle,
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
      padding:
          widget.chatBubbleConfig?.padding ?? const EdgeInsets.only(left: 5.0),
      margin:
          widget.chatBubbleConfig?.margin ?? const EdgeInsets.only(bottom: 10),
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
                            if (widget.swipeToReplyConfig?.onLeftSwipe !=
                                null) {
                              widget.swipeToReplyConfig?.onLeftSwipe!(
                                  widget.message.message,
                                  widget.message.messageSenderId);
                            }
                            widget.onSwipe(widget.message);
                          }
                        : null,
                    replyIconColor: widget.swipeToReplyConfig?.replyIconColor,
                    swipeToReplyAnimationDuration:
                        widget.swipeToReplyConfig?.animationDuration,
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
                                if (widget.swipeToReplyConfig?.onRightSwipe !=
                                    null) {
                                  widget.swipeToReplyConfig?.onRightSwipe!(
                                      widget.message.message,
                                      widget.message.messageSenderId);
                                }
                                widget.onSwipe(widget.message);
                              }
                            : null,
                    replyIconColor: widget.swipeToReplyConfig?.replyIconColor,
                    swipeToReplyAnimationDuration:
                        widget.swipeToReplyConfig?.animationDuration,
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
          widget.repliedMessageConfig?.repliedMessageWidgetBuilder != null
              ? widget.repliedMessageConfig!
                  .repliedMessageWidgetBuilder!(widget.message.replyMessage)
              : ReplyMessageWidget(
                  message: widget.message,
                  repliedMessageConfig: widget.repliedMessageConfig,
                  onTap: () => widget.onReplyTap
                      ?.call(widget.message.replyMessage.repliedMessageId),
                  currentUserId: widget.currentUserId,
                ),
        MessageView(
          outgoingChatBubbleConfig:
              widget.chatBubbleConfig?.outgoingChatBubbleConfig,
          isLongPressEnable:
              (featureActiveConfig?.enableReactionPopup ?? true) ||
                  (featureActiveConfig?.enableReplySnackBar ?? true),
          inComingChatBubbleConfig:
              widget.chatBubbleConfig?.inComingChatBubbleConfig,
          message: widget.message,
          isMessageBySender: isMessageBySender,
          messageConfig: widget.messageConfig,
          onLongPress: widget.onLongPress,
          chatBubbleMaxWidth: widget.chatBubbleConfig?.maxWidth,
          longPressAnimationDuration:
              widget.chatBubbleConfig?.longPressAnimationDuration,
          onDoubleTap: (message) => chatController?.setReaction(
            emoji: heart,
            messageId: message.id,
            userId: widget.currentUserId,
          ),
          shouldHighlight: widget.shouldHighlight,
          controller: chatController,
          highlightColor: widget.repliedMessageConfig
                  ?.repliedMsgAutoScrollConfig.highlightColor ??
              Colors.grey,
          highlightScale: widget.repliedMessageConfig
                  ?.repliedMsgAutoScrollConfig.highlightScale ??
              1.1,
          onMaxDuration: _onMaxDuration,
        ),
      ],
    );
  }

  void _onMaxDuration(int duration) => maxDuration = duration;
}
