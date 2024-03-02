import 'package:flutter/material.dart';
import 'package:chatview/src/models/models.dart';
import 'package:chatview/src/extensions/extensions.dart';

class ChatGroupHeader extends StatelessWidget {
  const ChatGroupHeader({
    super.key,
    required this.day,
    this.groupSeparatorConfig,
  });

  /// Provides day of started chat.
  final DateTime day;

  /// Provides configuration for separator upon date wise chat.
  final DefaultGroupSeparatorConfiguration? groupSeparatorConfig;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: groupSeparatorConfig?.padding ??
          const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        day.getDay,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
