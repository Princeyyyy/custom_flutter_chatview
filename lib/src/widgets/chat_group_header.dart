import 'package:flutter/material.dart';
import 'package:chatview/src/extensions/extensions.dart';

class ChatGroupHeader extends StatelessWidget {
  const ChatGroupHeader({
    super.key,
    required this.day,
  });

  /// Provides day of started chat.
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        margin: const EdgeInsets.only(
          right: 115,
          left: 115,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          color: Color(0xFFBEFFB7),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            day.getDay,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
