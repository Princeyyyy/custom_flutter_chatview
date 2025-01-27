import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

import 'package:chatview/src/extensions/extensions.dart';
import '../utils/constants/constants.dart';
import 'image_message_view.dart';
import 'text_message_view.dart';
import 'reaction_widget.dart';
import 'voice_message_view.dart';

class MessageView extends StatefulWidget {
  const MessageView({
    super.key,
    required this.message,
    required this.isMessageBySender,
    required this.onLongPress,
    required this.isLongPressEnable,
    this.onDoubleTap,
    this.highlightColor = Colors.grey,
    this.shouldHighlight = false,
    this.highlightScale = 1.2,
    this.onMaxDuration,
    this.controller,
  });

  /// Provides message instance of chat.
  final Message message;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Give callback once user long press on chat bubble.
  final DoubleCallBack onLongPress;

  /// Allow user to set some action when user double tap on chat bubble.
  final MessageCallBack? onDoubleTap;

  /// Allow users to pass colour of chat bubble when user taps on replied message.
  final Color highlightColor;

  /// Allow users to turn on/off highlighting chat bubble when user tap on replied message.
  final bool shouldHighlight;

  /// Provides scale of highlighted image when user taps on replied image.
  final double highlightScale;

  /// Allow user to turn on/off long press tap on chat bubble.
  final bool isLongPressEnable;

  final ChatController? controller;

  final Function(int)? onMaxDuration;

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  bool get isLongPressEnable => widget.isLongPressEnable;

  @override
  void initState() {
    super.initState();
    if (isLongPressEnable) {
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
        upperBound: 0.1,
        lowerBound: 0.0,
      );

      _animationController?.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController?.reverse();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: isLongPressEnable ? _onLongPressStart : null,
      onDoubleTap: () {
        if (widget.onDoubleTap != null) widget.onDoubleTap!(widget.message);
      },
      child: (() {
        if (isLongPressEnable) {
          return AnimatedBuilder(
            builder: (_, __) {
              return Transform.scale(
                scale: 1 - _animationController!.value,
                child: _messageView,
              );
            },
            animation: _animationController!,
          );
        } else {
          return _messageView;
        }
      }()),
    );
  }

  Widget get _messageView {
    final message = widget.message.message;

    return Padding(
      padding: EdgeInsets.only(
        bottom: widget.message.reaction.reactions.isNotEmpty ? 6 : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          (() {
                if (message.isAllEmoji) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          leftPadding2,
                          4,
                          leftPadding2,
                          widget.message.reaction.reactions.isNotEmpty ? 14 : 0,
                        ),
                        child: Transform.scale(
                          scale: widget.shouldHighlight
                              ? widget.highlightScale
                              : 1.0,
                          child: Text(
                            message,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      if (widget.message.reaction.reactions.isNotEmpty)
                        ReactionWidget(
                          reaction: widget.message.reaction,
                          isMessageBySender: widget.isMessageBySender,
                          isMessageImage: false,
                        ),
                    ],
                  );
                } else if (widget.message.messageType.isImage) {
                  return ImageMessageView(
                    message: widget.message,
                    isMessageBySender: widget.isMessageBySender,
                    highlightImage: widget.shouldHighlight,
                    highlightScale: widget.highlightScale,
                  );
                } else if (widget.message.messageType.isText) {
                  return TextMessageView(
                    isMessageBySender: widget.isMessageBySender,
                    message: widget.message,
                    highlightColor: widget.highlightColor,
                    highlightMessage: widget.shouldHighlight,
                  );
                } else if (widget.message.messageType.isVoice) {
                  return VoiceMessageView(
                    screenWidth: MediaQuery.of(context).size.width,
                    message: widget.message,
                    onMaxDuration: widget.onMaxDuration,
                    isMessageBySender: widget.isMessageBySender,
                  );
                }
              }()) ??
              const SizedBox(),
        ],
      ),
    );
  }

  void _onLongPressStart(LongPressStartDetails details) async {
    await _animationController?.forward();
    widget.onLongPress(
      details.globalPosition.dy - 120 - 64,
      details.globalPosition.dx,
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
}
