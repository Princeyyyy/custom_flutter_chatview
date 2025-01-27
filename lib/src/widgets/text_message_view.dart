import 'package:flutter/material.dart';

import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/models/models.dart';

import '../utils/constants/constants.dart';
import 'link_preview.dart';
import 'reaction_widget.dart';

class TextMessageView extends StatelessWidget {
  const TextMessageView({
    super.key,
    required this.isMessageBySender,
    required this.message,
    this.highlightMessage = false,
    this.highlightColor,
  });

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides message instance of chat.
  final Message message;

  /// Represents message should highlight.
  final bool highlightMessage;

  /// Allow user to set color of highlighted message.
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final textMessage = message.message;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomPaint(
          painter: SpecialChatBubbleOne(
            color: isMessageBySender ? Colors.blue : Colors.pink,
            alignment:
                isMessageBySender ? Alignment.topRight : Alignment.topLeft,
            tail: true,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            margin: EdgeInsets.fromLTRB(
                5, 0, 6, message.reaction.reactions.isNotEmpty ? 15 : 2),
            decoration: BoxDecoration(
              borderRadius: _borderRadius(textMessage),
            ),
            child: textMessage.isUrl
                ? LinkPreview(
                    url: textMessage,
                  )
                : Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      textMessage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
          ),
        ),
        if (message.reaction.reactions.isNotEmpty)
          ReactionWidget(
            key: key,
            isMessageBySender: isMessageBySender,
            reaction: message.reaction,
            isMessageImage: false,
          ),
      ],
    );
  }

  BorderRadiusGeometry _borderRadius(String message) => isMessageBySender
      ? (message.length < 37
          ? BorderRadius.circular(replyBorderRadius1)
          : BorderRadius.circular(replyBorderRadius2))
      : (message.length < 29
          ? BorderRadius.circular(replyBorderRadius1)
          : BorderRadius.circular(replyBorderRadius2));
}

/// Custom painter used to create the shape of the chat bubble
///
/// [color],[alignment] and [tail] can be changed

class SpecialChatBubbleOne extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool tail;

  SpecialChatBubbleOne({
    required this.color,
    required this.alignment,
    required this.tail,
  });

  final double _radius = 10.0;
  final double _x = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (alignment == Alignment.topRight) {
      if (tail) {
        canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              0,
              0,
              size.width - _x,
              size.height,
              bottomLeft: Radius.circular(_radius),
              bottomRight: Radius.circular(_radius),
              topLeft: Radius.circular(_radius),
            ),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
        var path = Path();
        path.moveTo(size.width - _x, 0);
        path.lineTo(size.width - _x, 10);
        path.lineTo(size.width, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            size.width - _x,
            0.0,
            size.width,
            size.height,
            topRight: const Radius.circular(3),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );
      } else {
        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            0,
            size.width - _x,
            size.height,
            bottomLeft: Radius.circular(_radius),
            bottomRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );
      }
    } else {
      if (tail) {
        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            _x,
            0,
            size.width,
            size.height,
            bottomRight: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            bottomLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );
        var path = Path();
        path.moveTo(_x, 0);
        path.lineTo(_x, 10);
        path.lineTo(0, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            0.0,
            _x,
            size.height,
            topLeft: const Radius.circular(3),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );
      } else {
        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            _x,
            0,
            size.width,
            size.height,
            bottomRight: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            bottomLeft: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
