import 'package:chatview/chatview.dart';
import 'dart:math';

import 'package:faker/faker.dart';

class Data {
  static const profileImage =
      "https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_showcaseview/master/example/assets/simform.png";

  static final messageList = [
    Message(
      id: '1',
      message: "Hi!",
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      messageSenderId: '1',
      // userId of who sends the message
      replyMessage: const ReplyMessage(),
      reaction: Reaction(reactions: [], reactedUserNames: []),
      messageType: MessageType.text,
      status: MessageStatus.delivered,
    ),
    Message(
      id: '2',
      message: "Hello!",
      createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
      messageSenderId: '2',
      replyMessage: const ReplyMessage(),
      reaction: Reaction(reactions: [], reactedUserNames: []),
      messageType: MessageType.text,
      status: MessageStatus.delivered,
    ),
    Message(
      id: '3',
      message: "How are you?",
      createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      messageSenderId: '1',
      replyMessage: const ReplyMessage(),
      reaction: Reaction(reactions: [], reactedUserNames: []),
      messageType: MessageType.text,
      status: MessageStatus.delivered,
    ),
    // Add more messages as needed
  ];

  // Generate dummy data for testing
  static List<Message> generateDummyData(int count) {
    final List<Message> messages = [];
    final faker = Faker();
    Random random = Random();

    final DateTime today = DateTime.now();

    for (int i = 0; i < count; i++) {
      final String id = i.toString();
      String message;
      MessageType messageType;
      if ((i + 1) % 3 == 0) {
        message = "https://miro.medium.com/max/1000/0*s7of7kWnf9fDg4XM.jpeg";
        messageType = MessageType.image;
      } else if (random.nextInt(10) < 3) { // 30% chance of having "🤩🤩"
        message = "🤩🤩";
        messageType = MessageType.text;
      } else {
        message = faker.lorem.sentence();
        messageType = MessageType.text;
      }
      final DateTime createdAt = today.subtract(Duration(days: count - i));
      String messageSenderId = (random.nextInt(2) + 1).toString();

      const ReplyMessage replyMessage = ReplyMessage();

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
