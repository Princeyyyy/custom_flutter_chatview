import 'package:chatview/chatview.dart';
import 'package:chatview/src/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

import 'chat_bubble_widget.dart';
import 'chat_group_header.dart';

class ChatGroupedListWidget extends StatefulWidget {
  const ChatGroupedListWidget({
    super.key,
    required this.showPopUp,
    required this.scrollController,
    required this.chatBackgroundConfig,
    required this.replyMessage,
    required this.assignReplyMessage,
    required this.onChatListTap,
    required this.onChatBubbleLongPress,
    required this.isEnableSwipeToSeeTime,
    required this.currentUserId,
    this.messageConfig,
    this.chatBubbleConfig,
    this.swipeToReplyConfig,
    this.repliedMessageConfig,
  });

  /// Allow user to swipe to see time while reaction pop is not open.
  final bool showPopUp;
  final ScrollController scrollController;

  /// Allow user to give customisation to background of chat
  final ChatBackgroundConfiguration chatBackgroundConfig;

  /// Allow user to giving customisation different types
  /// messages
  final MessageConfiguration? messageConfig;

  /// Allow user to giving customisation to chat bubble
  final ChatBubbleConfiguration? chatBubbleConfig;

  /// Allow user to giving customisation to swipe to reply
  final SwipeToReplyConfiguration? swipeToReplyConfig;
  final RepliedMessageConfiguration? repliedMessageConfig;

  /// Provides reply message if actual message is sent by replying any message.
  final ReplyMessage replyMessage;

  /// Provides callback for assigning reply message when user swipe on chat bubble.
  final MessageCallBack assignReplyMessage;

  /// Provides callback when user tap anywhere on whole chat.
  final VoidCallBack onChatListTap;

  final String currentUserId;

  /// Provides callback when user press chat bubble for certain time then usual.
  final void Function(double, double, Message) onChatBubbleLongPress;

  /// Provide flag for turn on/off to see message crated time view when user
  /// swipe whole chat.
  final bool isEnableSwipeToSeeTime;

  @override
  State<ChatGroupedListWidget> createState() => _ChatGroupedListWidgetState();
}

class _ChatGroupedListWidgetState extends State<ChatGroupedListWidget>
    with TickerProviderStateMixin {
  ChatBackgroundConfiguration get chatBackgroundConfig =>
      widget.chatBackgroundConfig;

  bool get showPopUp => widget.showPopUp;

  bool highlightMessage = false;
  final ValueNotifier<String?> _replyId = ValueNotifier(null);

  ChatBubbleConfiguration? get chatBubbleConfig => widget.chatBubbleConfig;
  AnimationController? _animationController;
  Animation<Offset>? _slideAnimation;

  FeatureActiveConfig? featureActiveConfig;

  ChatController? chatController;

  bool get isEnableSwipeToSeeTime => widget.isEnableSwipeToSeeTime;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    // When this flag is on at that time only animation controllers will be
    // initialized.
    if (isEnableSwipeToSeeTime) {
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
      );
      _slideAnimation = Tween<Offset>(
        begin: const Offset(0.0, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(
        CurvedAnimation(
          curve: Curves.decelerate,
          parent: _animationController!,
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (provide != null) {
      featureActiveConfig = provide!.featureActiveConfig;
      chatController = provide!.chatController;
    }
    _initializeAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      // When reaction popup is being appeared at that user should not scroll.
      physics: showPopUp ? const NeverScrollableScrollPhysics() : null,
      controller: widget.scrollController,
      child: Column(
        children: [
          GestureDetector(
            onHorizontalDragUpdate: (details) => isEnableSwipeToSeeTime
                ? showPopUp
                    ? null
                    : _onHorizontalDrag(details)
                : null,
            onHorizontalDragEnd: (details) => isEnableSwipeToSeeTime
                ? showPopUp
                    ? null
                    : _animationController?.reverse()
                : null,
            onTap: widget.onChatListTap,
            child: _animationController != null
                ? AnimatedBuilder(
                    animation: _animationController!,
                    builder: (context, child) {
                      return _chatStreamBuilder;
                    },
                  )
                : _chatStreamBuilder,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width *
                (widget.replyMessage.message.isNotEmpty ? 0.3 : 0.14),
          ),
        ],
      ),
    );
  }

  Future<void> _onReplyTap(String id, List<Message>? messages) async {
    // Finds the replied message if exists
    final repliedMessages = messages?.firstWhere((message) => id == message.id);

    // Scrolls to replied message and highlights
    if (repliedMessages != null && repliedMessages.key.currentState != null) {
      await Scrollable.ensureVisible(
        repliedMessages.key.currentState!.context,
        // This value will make widget to be in center when auto scrolled.
        alignment: 0.5,
        curve: widget.repliedMessageConfig?.repliedMsgAutoScrollConfig
                .highlightScrollCurve ??
            Curves.easeIn,
        duration: widget.repliedMessageConfig?.repliedMsgAutoScrollConfig
                .highlightDuration ??
            const Duration(milliseconds: 300),
      );
      if (widget.repliedMessageConfig?.repliedMsgAutoScrollConfig
              .enableHighlightRepliedMsg ??
          false) {
        _replyId.value = id;

        Future.delayed(
          widget.repliedMessageConfig?.repliedMsgAutoScrollConfig
                  .highlightDuration ??
              const Duration(milliseconds: 300),
          () {
            _replyId.value = null;
          },
        );
      }
    }
  }

  /// When user swipe at that time only animation is assigned with value.
  void _onHorizontalDrag(DragUpdateDetails details) {
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-0.2, 0.0),
    ).animate(
      CurvedAnimation(
        curve: chatBackgroundConfig.messageTimeAnimationCurve,
        parent: _animationController!,
      ),
    );

    details.delta.dx > 1
        ? _animationController?.reverse()
        : _animationController?.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _replyId.dispose();
    super.dispose();
  }

  Widget get _chatStreamBuilder {
    return StreamBuilder<List<Message>>(
      stream: chatController?.messageStreamController.stream,
      builder: (context, snapshot) {
        return snapshot.connectionState.isActive
            ? GroupedListView<Message, String>(
                shrinkWrap: true,
                elements: snapshot.data!,
                groupBy: (element) => element.createdAt.getDateFromDateTime,
                itemComparator: (message1, message2) =>
                    message1.message.compareTo(message2.message),
                physics: const NeverScrollableScrollPhysics(),
                order: chatBackgroundConfig.groupedListOrder,
                sort: chatBackgroundConfig.sortEnable,
                groupSeparatorBuilder: (separator) =>
                    featureActiveConfig?.enableChatSeparator ?? false
                        ? _GroupSeparatorBuilder(
                            separator: separator,
                            defaultGroupSeparatorConfig: chatBackgroundConfig
                                .defaultGroupSeparatorConfig,
                            groupSeparatorBuilder:
                                chatBackgroundConfig.groupSeparatorBuilder,
                          )
                        : const SizedBox.shrink(),
                indexedItemBuilder: (context, message, index) {
                  return ValueListenableBuilder<String?>(
                    valueListenable: _replyId,
                    builder: (context, state, child) {
                      return ChatBubbleWidget(
                        key: message.key,
                        messageTimeTextStyle:
                            chatBackgroundConfig.messageTimeTextStyle,
                        messageTimeIconColor:
                            chatBackgroundConfig.messageTimeIconColor,
                        message: message,
                        messageConfig: widget.messageConfig,
                        chatBubbleConfig: chatBubbleConfig,
                        swipeToReplyConfig: widget.swipeToReplyConfig,
                        repliedMessageConfig: widget.repliedMessageConfig,
                        slideAnimation: _slideAnimation,
                        onLongPress: (yCoordinate, xCoordinate) =>
                            widget.onChatBubbleLongPress(
                          yCoordinate,
                          xCoordinate,
                          message,
                        ),
                        onSwipe: widget.assignReplyMessage,
                        shouldHighlight: state == message.id,
                        onReplyTap: widget
                                    .repliedMessageConfig
                                    ?.repliedMsgAutoScrollConfig
                                    .enableScrollToRepliedMsg ??
                                false
                            ? (replyId) => _onReplyTap(replyId, snapshot.data)
                            : null,
                        currentUserId: widget.currentUserId,
                      );
                    },
                  );
                },
              )
            : Center(
                child: chatBackgroundConfig.loadingWidget ??
                    const CircularProgressIndicator(),
              );
      },
    );
  }
}

class _GroupSeparatorBuilder extends StatelessWidget {
  const _GroupSeparatorBuilder({
    required this.separator,
    this.groupSeparatorBuilder,
    this.defaultGroupSeparatorConfig,
  });
  final String separator;
  final StringWithReturnWidget? groupSeparatorBuilder;
  final DefaultGroupSeparatorConfiguration? defaultGroupSeparatorConfig;

  @override
  Widget build(BuildContext context) {
    return groupSeparatorBuilder != null
        ? groupSeparatorBuilder!(separator)
        : ChatGroupHeader(
            day: DateTime.parse(separator),
            groupSeparatorConfig: defaultGroupSeparatorConfig,
          );
  }
}
