import 'package:chatview/chatview.dart';
import 'dart:math';

import 'package:faker/faker.dart';

class Data {
  // Generate dummy data for testing
  static List<Message> messages = [];

  static List<Message> generateDummyData(int count) {
    final faker = Faker();
    Random random = Random();

    final DateTime today = DateTime.now();

    for (int i = 0; i < count; i++) {
      final String id = i.toString();
      String message;
      MessageType messageType;
      String messageSenderId;
      DateTime createdAt;
      ReplyMessage replyMessage = ReplyMessage();

      if (i.isEven) {
        if (i > 20) {
          if (i > 25) {
            message = faker.lorem.sentence();
            messageType = MessageType.text;
            messageSenderId = "currentUser.id";
          } else {
            message = "https://miro.medium.com/max/1000/0*s7of7kWnf9fDg4XM.jpeg";
            messageType = MessageType.image;
            messageSenderId = "currentUser.id";
          }
        } else {
          message = "🤩🤩";
          messageType = MessageType.text;
          messageSenderId = "currentUser.id";
        }
      } else {
        message = faker.lorem.sentence();
        messageType = MessageType.text;
        messageSenderId = "otherUser.id";
        replyMessage = ReplyMessage(
          repliedMessageId: (i - 1).toString(),
          message: message,
          replyUserId: "otherUser.id",
          replyBy: messageSenderId,
          messageType: MessageType.text
        );
      }

      if (i % 5 == 0) {
        createdAt = today.subtract(Duration(days: count - i));
      } else if ((i - 1) % 5 == 0) {
        createdAt = today.subtract(Duration(days: count - (i - 1)));
      } else if ((i - 2) % 5 == 0) {
        createdAt = today.subtract(Duration(days: count - (i - 2)));
      } else if ((i - 3) % 5 == 0) {
        createdAt = today.subtract(Duration(days: count - (i - 3)));
      } else {
        createdAt = today.subtract(Duration(days: count - (i - 4)));
      }

      final Reaction reaction = Reaction(reactions: [], reactedUserNames: []);

      const MessageStatus status = MessageStatus.delivered;

      messages.add(Message(
        id: id,
        message: message,
        createdAt: createdAt,
        messageSenderId: messageSenderId,
        replyMessage: replyMessage,
        reaction: reaction,
        messageType: messageType,
        status: status,
      ));
    }

    return messages;
  }
}
