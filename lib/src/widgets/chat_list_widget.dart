import 'dart:async';
import 'dart:io' if (kIsWeb) 'dart:html';

import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/widgets/chat_groupedlist_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../chatview.dart';
import 'reaction_popup.dart';
import 'reply_popup_widget.dart';

class ChatListWidget extends StatefulWidget {
  const ChatListWidget({
    super.key,
    required this.chatController,
    required this.chatBackgroundConfig,
    required this.assignReplyMessage,
    required this.replyMessage,
    required this.currentUserId,
    this.messageConfig,
    this.chatBubbleConfig,
    this.repliedMessageConfig,
    this.onChatListTap,
  });

  /// Provides controller for accessing few function for running chat.
  final ChatController chatController;

  /// Provides configuration for background of chat.
  final ChatBackgroundConfiguration chatBackgroundConfig;

  /// Provides configuration for customisation of different types
  /// messages.
  final MessageConfiguration? messageConfig;

  /// Provides configuration of chat bubble's appearance.
  final ChatBubbleConfiguration? chatBubbleConfig;

  /// Provides configuration for replied message view which is located upon chat
  /// bubble.
  final RepliedMessageConfiguration? repliedMessageConfig;

  /// Provides reply message when user swipe to chat bubble.
  final ReplyMessage replyMessage;

  final String currentUserId;

  /// Provides callback for assigning reply message when user swipe to chat
  /// bubble.
  final MessageCallBack assignReplyMessage;

  /// Provides callback when user tap anywhere on whole chat.
  final VoidCallBack? onChatListTap;

  @override
  State<ChatListWidget> createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> _isNextPageLoading = ValueNotifier<bool>(false);
  ValueNotifier<bool> showPopUp = ValueNotifier(false);
  final GlobalKey<ReactionPopupState> _reactionPopupKey = GlobalKey();

  ChatController get chatController => widget.chatController;

  List<Message> get messageList => chatController.initialMessageList;

  ScrollController get scrollController => chatController.scrollController;

  ChatBackgroundConfiguration get chatBackgroundConfig =>
      widget.chatBackgroundConfig;

  FeatureActiveConfig? featureActiveConfig;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (provide != null) {
      featureActiveConfig = provide!.featureActiveConfig;
    }
  }

  void _initialize() {
    chatController.messageStreamController = StreamController();
    if (!chatController.messageStreamController.isClosed) {
      chatController.messageStreamController.sink.add(messageList);
    }
    if (messageList.isNotEmpty) chatController.scrollToLastMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: showPopUp,
            builder: (_, showPopupValue, child) {
              return Stack(
                children: [
                  ChatGroupedListWidget(
                    showPopUp: showPopupValue,
                    scrollController: scrollController,
                    isEnableSwipeToSeeTime:
                        featureActiveConfig?.enableSwipeToSeeTime ?? true,
                    chatBackgroundConfig: widget.chatBackgroundConfig,
                    assignReplyMessage: widget.assignReplyMessage,
                    replyMessage: widget.replyMessage,
                    repliedMessageConfig: widget.repliedMessageConfig,
                    messageConfig: widget.messageConfig,
                    chatBubbleConfig: widget.chatBubbleConfig,
                    onChatBubbleLongPress: (yCoordinate, xCoordinate, message) {
                      if (featureActiveConfig?.enableReactionPopup ?? false) {
                        _reactionPopupKey.currentState?.refreshWidget(
                          message: message,
                          xCoordinate: xCoordinate,
                          yCoordinate: yCoordinate < 0
                              ? -(yCoordinate) - 5
                              : yCoordinate,
                        );
                        showPopUp.value = true;
                      }
                      if (featureActiveConfig?.enableReplySnackBar ?? false) {
                        _showReplyPopup(
                          message: message,
                          sendByCurrentUser:
                              message.messageSenderId == widget.currentUserId,
                        );
                      }
                    },
                    onChatListTap: _onChatListTap,
                    currentUserId: widget.currentUserId,
                  ),
                  if (featureActiveConfig?.enableReactionPopup ?? false)
                    ReactionPopup(
                      key: _reactionPopupKey,
                      onTap: _onChatListTap,
                      showPopUp: showPopupValue,
                      currentUserId: widget.currentUserId,
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _showReplyPopup({
    required Message message,
    required bool sendByCurrentUser,
  }) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            duration: const Duration(hours: 1),
            backgroundColor: Colors.white,
            content: ReplyPopupWidget(
              onMoreTap: () {
                _onChatListTap();
              },
              onReportTap: () {
                _onChatListTap();
              },
              onUnsendTap: () {
                _onChatListTap();
              },
              onReplyTap: () {
                widget.assignReplyMessage(message);
                if (featureActiveConfig?.enableReactionPopup ?? false) {
                  showPopUp.value = false;
                }

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              sendByCurrentUser: sendByCurrentUser,
            ),
            padding: EdgeInsets.zero,
          ),
        )
        .closed;
  }

  void _onChatListTap() {
    widget.onChatListTap?.call();
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      FocusScope.of(context).unfocus();
    }
    showPopUp.value = false;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  void dispose() {
    chatController.messageStreamController.close();
    scrollController.dispose();
    _isNextPageLoading.dispose();
    showPopUp.dispose();
    super.dispose();
  }
}
