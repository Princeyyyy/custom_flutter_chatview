import 'package:chatview/chatview.dart';
import 'package:chatview/src/widgets/chat_list_widget.dart';
import 'package:chatview/src/widgets/chat_view_inherited_widget.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart';
import '../values/custom_time_messages.dart';
import 'send_message_widget.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    super.key,
    required this.chatController,
    required this.currentUserId,
    this.onSendTap,
    this.repliedMessageConfig,
    this.messageConfig,
    this.sendMessageBuilder,
    this.onChatListTap,
    this.featureActiveConfig = const FeatureActiveConfig(),
  });

  /// Allow user to giving customisation different types
  /// messages.
  final MessageConfiguration? messageConfig;

  /// Provides configuration for replied message view which is located upon chat
  /// bubble.
  final RepliedMessageConfiguration? repliedMessageConfig;

  /// Provides call back when user tap on send button in text field. It returns
  /// message, reply message and message type.
  final StringMessageCallBack? onSendTap;

  /// Provides builder which helps you to make custom text field and functionality.
  final ReplyMessageWithReturnWidget? sendMessageBuilder;

  /// Provides controller for accessing few function for running chat.
  final ChatController chatController;

  /// Provides current user which is sending messages.
  final String currentUserId;

  /// Provides configuration for turn on/off specific features.
  final FeatureActiveConfig featureActiveConfig;

  /// Provides callback when user tap on chat list.
  final VoidCallBack? onChatListTap;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<SendMessageWidgetState> _sendMessageKey = GlobalKey();
  ValueNotifier<ReplyMessage> replyMessage =
      ValueNotifier(const ReplyMessage());

  ChatController get chatController => widget.chatController;

  FeatureActiveConfig get featureActiveConfig => widget.featureActiveConfig;

  @override
  void initState() {
    super.initState();
    setLocaleMessages('en', ReceiptsCustomMessages());
  }

  @override
  Widget build(BuildContext context) {
    chatController.scrollToLastMessage();

    return ChatViewInheritedWidget(
      chatController: chatController,
      featureActiveConfig: featureActiveConfig,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.grey,
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ValueListenableBuilder<ReplyMessage>(
                    valueListenable: replyMessage,
                    builder: (_, state, child) {
                      return ChatListWidget(
                        replyMessage: state,
                        chatController: widget.chatController,
                        messageConfig: widget.messageConfig,
                        repliedMessageConfig: widget.repliedMessageConfig,
                        onChatListTap: widget.onChatListTap,
                        assignReplyMessage: (message) => _sendMessageKey
                            .currentState
                            ?.assignReplyMessage(message),
                        currentUserId: widget.currentUserId,
                      );
                    },
                  ),
                  if (featureActiveConfig.enableTextField)
                    SendMessageWidget(
                      key: _sendMessageKey,
                      chatController: chatController,
                      sendMessageBuilder: widget.sendMessageBuilder,
                      onSendTap: _onSendTap,
                      onReplyCallback: (reply) => replyMessage.value = reply,
                      onReplyCloseCallback: () =>
                          replyMessage.value = const ReplyMessage(),
                      currentUserId: widget.currentUserId,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) {
    if (widget.sendMessageBuilder == null) {
      if (widget.onSendTap != null) {
        widget.onSendTap!(message, replyMessage, messageType);
      }
      _assignReplyMessage();
    }
    chatController.scrollToLastMessage();
  }

  void _assignReplyMessage() {
    if (replyMessage.value.message.isNotEmpty) {
      replyMessage.value = const ReplyMessage();
    }
  }

  @override
  void dispose() {
    replyMessage.dispose();
    super.dispose();
  }
}
