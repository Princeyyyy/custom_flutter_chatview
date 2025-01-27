import 'dart:io' if (kIsWeb) 'dart:html';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatview/chatview.dart';
import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/utils/package_strings.dart';
import 'package:chatview/src/widgets/chatui_textfield.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../utils/constants/constants.dart';

class SendMessageWidget extends StatefulWidget {
  const SendMessageWidget({
    super.key,
    required this.onSendTap,
    required this.chatController,
    required this.currentUserId,
    this.sendMessageBuilder,
    this.onReplyCallback,
    this.onReplyCloseCallback,
  });

  /// Provides call back when user tap on send button on text field.
  final StringMessageCallBack onSendTap;
  final String currentUserId;

  /// Allow user to set custom text field.
  final ReplyMessageWithReturnWidget? sendMessageBuilder;

  /// Provides callback when user swipes chat bubble for reply.
  final ReplyMessageCallBack? onReplyCallback;

  /// Provides call when user tap on close button which is showed in reply pop-up.
  final VoidCallBack? onReplyCloseCallback;

  /// Provides controller for accessing few function for running chat.
  final ChatController chatController;

  @override
  State<SendMessageWidget> createState() => SendMessageWidgetState();
}

class SendMessageWidgetState extends State<SendMessageWidget> {
  final _textEditingController = TextEditingController();
  final ValueNotifier<ReplyMessage> _replyMessage =
      ValueNotifier(const ReplyMessage());

  ReplyMessage get replyMessage => _replyMessage.value;
  final _focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (provide != null) {}
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            bottomPadding4,
            bottomPadding4,
            bottomPadding4,
            _bottomPadding,
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ValueListenableBuilder<ReplyMessage>(
                builder: (_, state, child) {
                  if (state.message.isNotEmpty) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(14),
                        ),
                      ),
                      margin: const EdgeInsets.only(
                        bottom: 17,
                        right: 0.4,
                        left: 0.4,
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        leftPadding,
                        leftPadding,
                        leftPadding,
                        30,
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.only(
                          left: 8,
                          bottom: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                  onPressed: _onCloseTap,
                                ),
                              ],
                            ),
                            if (state.messageType.isVoice)
                              _voiceReplyMessageView
                            else if (state.messageType.isImage)
                              _imageReplyMessageView
                            else
                              Text(
                                state.message,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
                valueListenable: _replyMessage,
              ),
              ChatUITextField(
                focusNode: _focusNode,
                textEditingController: _textEditingController,
                onPressed: _onPressed,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget get _voiceReplyMessageView {
    return Row(
      children: [
        const Icon(
          Icons.mic,
          color: Colors.white,
          size: 25,
        ),
        const SizedBox(width: 4),
        if (replyMessage.voiceMessageDuration != null)
          Text(
            replyMessage.voiceMessageDuration!.toHHMMSS(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
      ],
    );
  }

  Widget get _imageReplyMessageView {
    return const Row(
      children: [
        Icon(
          Icons.photo,
          size: 25,
          color: Colors.black,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          PackageStrings.photo,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ],
    );
  }

  void _assignRepliedMessage() {
    if (replyMessage.message.isNotEmpty) {
      _replyMessage.value = const ReplyMessage();
    }
  }

  void _onPressed() {
    if (_textEditingController.text.isNotEmpty &&
        !_textEditingController.text.startsWith('\n')) {
      widget.onSendTap.call(
        _textEditingController.text.trim(),
        replyMessage,
        MessageType.text,
      );
      _assignRepliedMessage();
      _textEditingController.clear();
    }
  }

  void assignReplyMessage(Message message) {
    _replyMessage.value = ReplyMessage(
      message: message.message,
      replyBy: widget.currentUserId,
      replyUserId: message.messageSenderId,
      messageType: message.messageType,
      repliedMessageId: message.id,
      voiceMessageDuration: message.voiceMessageDuration,
    );

    FocusScope.of(context).requestFocus(_focusNode);
    if (widget.onReplyCallback != null) widget.onReplyCallback!(replyMessage);
  }

  void _onCloseTap() {
    _replyMessage.value = const ReplyMessage();
    if (widget.onReplyCloseCallback != null) widget.onReplyCloseCallback!();
  }

  double get _bottomPadding => (!kIsWeb && Platform.isIOS)
      ? (_focusNode.hasFocus
          ? bottomPadding1
          : View.of(context).viewPadding.bottom > 0
              ? bottomPadding2
              : bottomPadding3)
      : bottomPadding3;

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    _replyMessage.dispose();
    super.dispose();
  }
}
