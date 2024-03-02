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
    this.chatBubbleConfig,
    this.repliedMessageConfig,
    this.replyPopupConfig,
    this.reactionPopupConfig,
    this.messageConfig,
    ChatBackgroundConfiguration? chatBackgroundConfig,
    this.sendMessageBuilder,
    this.sendMessageConfig,
    this.onChatListTap,
    this.featureActiveConfig = const FeatureActiveConfig(),
  })  : chatBackgroundConfig =
            chatBackgroundConfig ?? const ChatBackgroundConfiguration();

  /// Provides configurations related to chat bubble such as padding, margin, max
  /// width etc.
  final ChatBubbleConfiguration? chatBubbleConfig;

  /// Allow user to giving customisation different types
  /// messages.
  final MessageConfiguration? messageConfig;

  /// Provides configuration for replied message view which is located upon chat
  /// bubble.
  final RepliedMessageConfiguration? repliedMessageConfig;

  /// Provides configuration for reply snack bar's appearance and options.
  final ReplyPopupConfiguration? replyPopupConfig;

  /// Provides configuration for reaction pop up appearance.
  final ReactionPopupConfiguration? reactionPopupConfig;

  /// Allow user to give customisation to background of chat
  final ChatBackgroundConfiguration chatBackgroundConfig;

  /// Provides call back when user tap on send button in text field. It returns
  /// message, reply message and message type.
  final StringMessageCallBack? onSendTap;

  /// Provides builder which helps you to make custom text field and functionality.
  final ReplyMessageWithReturnWidget? sendMessageBuilder;


  /// Provides controller for accessing few function for running chat.
  final ChatController chatController;

  /// Provides configuration of default text field in chat.
  final SendMessageConfiguration? sendMessageConfig;

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

  ChatBackgroundConfiguration get chatBackgroundConfig =>
      widget.chatBackgroundConfig;

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
        height:
            chatBackgroundConfig.height ?? MediaQuery.of(context).size.height,
        width: chatBackgroundConfig.width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: chatBackgroundConfig.backgroundColor ?? Colors.white,
          image: chatBackgroundConfig.backgroundImage != null
              ? DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(chatBackgroundConfig.backgroundImage!),
                )
              : null,
        ),
        padding: chatBackgroundConfig.padding,
        margin: chatBackgroundConfig.margin,
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
                        chatBackgroundConfig: widget.chatBackgroundConfig,
                        reactionPopupConfig: widget.reactionPopupConfig,
                        chatBubbleConfig: widget.chatBubbleConfig,
                        replyPopupConfig: widget.replyPopupConfig,
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
                      sendMessageConfig: widget.sendMessageConfig,
                      backgroundColor: chatBackgroundConfig.backgroundColor,
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
