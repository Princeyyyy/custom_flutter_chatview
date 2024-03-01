import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/utils/measure_size.dart';
import 'package:chatview/src/widgets/reactions_bottomsheet.dart';
import 'package:flutter/material.dart';

import '../../chatview.dart';

class ReactionWidget extends StatefulWidget {
  const ReactionWidget({
    super.key,
    required this.reaction,
    this.messageReactionConfig,
    required this.isMessageBySender,
  });

  /// Provides reaction instance of message.
  final Reaction reaction;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  @override
  State<ReactionWidget> createState() => _ReactionWidgetState();
}

class _ReactionWidgetState extends State<ReactionWidget> {
  bool needToExtend = false;

  MessageReactionConfiguration? get messageReactionConfig =>
      widget.messageReactionConfig;
  ChatController? chatController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (provide != null) {
      chatController = provide!.chatController;
    }
  }

  @override
  Widget build(BuildContext context) {
    //// Convert into set to remove redundant values
    final reactionsSet = widget.reaction.reactions.toSet();
    return Positioned(
      bottom: 0,
      right: widget.isMessageBySender && needToExtend ? 0 : null,
      child: InkWell(
        onTap: () => chatController != null
            ? ReactionsBottomSheet().show(
                context: context,
                reaction: widget.reaction,
                chatController: chatController!,
                reactionsBottomSheetConfig:
                    messageReactionConfig?.reactionsBottomSheetConfig,
              )
            : null,
        child: MeasureSize(
          onSizeChange: (extend) => setState(() => needToExtend = extend),
          child: Container(
            padding: messageReactionConfig?.padding ??
                const EdgeInsets.symmetric(vertical: 1.7, horizontal: 6),
            margin: messageReactionConfig?.margin ??
                EdgeInsets.only(
                  left: widget.isMessageBySender ? 10 : 16,
                  right: 10,
                ),
            decoration: BoxDecoration(
              color: messageReactionConfig?.backgroundColor ??
                  Colors.grey.shade200,
              borderRadius: messageReactionConfig?.borderRadius ??
                  BorderRadius.circular(16),
              border: Border.all(
                color: messageReactionConfig?.borderColor ?? Colors.white,
                width: messageReactionConfig?.borderWidth ?? 1,
              ),
            ),
            child: Text(
              reactionsSet.join(' '),
              style: TextStyle(
                fontSize: messageReactionConfig?.reactionSize ?? 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
