import 'dart:async';

import 'package:flutter/material.dart';

import '../models/models.dart';

class ChatController {
  /// Represents initial message list in chat which can be add by user.
  List<Message> initialMessageList;

  ScrollController scrollController;

  ChatController({
    required this.initialMessageList,
    required this.scrollController,
  });

  /// Represents message stream of chat
  StreamController<List<Message>> messageStreamController = StreamController();

  /// Used to dispose stream.
  void dispose() => messageStreamController.close();

  /// Used to add message in message list.
  void addMessage(Message message) {
    initialMessageList.add(message);
    messageStreamController.sink.add(initialMessageList);
  }

  /// Function for setting reaction on specific chat bubble
  void setReaction({
    required String emoji,
    required String messageId,
    required String userId,
  }) {
    final message =
        initialMessageList.firstWhere((element) => element.id == messageId);
    final reactedUserIds = message.reaction.reactedUserNames;
    final indexOfMessage = initialMessageList.indexOf(message);
    final userIndex = reactedUserIds.indexOf(userId);
    if (userIndex != -1) {
      if (message.reaction.reactions[userIndex] == emoji) {
        message.reaction.reactions.removeAt(userIndex);
        message.reaction.reactedUserNames.removeAt(userIndex);
      } else {
        message.reaction.reactions[userIndex] = emoji;
      }
    } else {
      message.reaction.reactions.add(emoji);
      message.reaction.reactedUserNames.add(userId);
    }
    initialMessageList[indexOfMessage] = Message(
      id: messageId,
      message: message.message,
      createdAt: message.createdAt,
      messageSenderId: message.messageSenderId,
      replyMessage: message.replyMessage,
      reaction: message.reaction,
      messageType: message.messageType,
      status: message.status,
    );
    messageStreamController.sink.add(initialMessageList);
  }

  /// Function to scroll to last messages in chat view
  void scrollToLastMessage() => Timer(
        const Duration(milliseconds: 300),
        () => scrollController.animateTo(
          scrollController.position.minScrollExtent,
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 300),
        ),
      );

  /// Function for loading data while pagination.
  void loadMoreData(List<Message> messageList) {
    /// Here, we have passed 0 index as we need to add data before first data
    initialMessageList.insertAll(0, messageList);
    messageStreamController.sink.add(initialMessageList);
  }
}
