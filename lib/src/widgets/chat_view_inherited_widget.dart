import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';

import '../models/feature_active_config.dart';

/// This widget for alternative of excessive amount of passing arguments
/// over widgets.
class ChatViewInheritedWidget extends InheritedWidget {
  const ChatViewInheritedWidget({
    super.key,
    required super.child,
    required this.chatController,
    required this.featureActiveConfig,
  });

  final ChatController chatController;
  final FeatureActiveConfig featureActiveConfig;

  static ChatViewInheritedWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ChatViewInheritedWidget>();

  @override
  bool updateShouldNotify(covariant ChatViewInheritedWidget oldWidget) =>
      oldWidget.featureActiveConfig != featureActiveConfig;
}
