import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';

/// This widget for alternative of excessive amount of passing arguments
/// over widgets.
class ChatViewInheritedWidget extends InheritedWidget {
  const ChatViewInheritedWidget({
    super.key,
    required super.child,
    required this.featureActiveConfig,
    required this.chatController,
  });

  final FeatureActiveConfig featureActiveConfig;
  final ChatController chatController;

  static ChatViewInheritedWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ChatViewInheritedWidget>();

  @override
  bool updateShouldNotify(covariant ChatViewInheritedWidget oldWidget) =>
      oldWidget.featureActiveConfig != featureActiveConfig;
}
