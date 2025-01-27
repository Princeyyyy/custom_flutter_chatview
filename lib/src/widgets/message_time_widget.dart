import 'package:chatview/src/extensions/extensions.dart';
import 'package:flutter/material.dart';

class MessageTimeWidget extends StatelessWidget {
  const MessageTimeWidget({
    super.key,
    required this.messageTime,
    required this.isCurrentUser,
  });

  /// Provides message crated date time.
  final DateTime messageTime;

  /// Represents message is sending by current user.
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Icon(
                isCurrentUser ? Icons.arrow_forward : Icons.arrow_back,
                size: 10,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              messageTime.getTimeFromDateTime,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
