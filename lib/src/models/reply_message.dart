import '../values/enumaration.dart';

class ReplyMessage {
  /// Provides reply message.
  final String message;

  /// Provides user id of who replied message.
  final String replyBy;

  /// Provides user id of whom to reply.
  final String replyUserId;

  /// Provides messageType to reply
  final MessageType messageType;

  /// Provides max duration for recorded voice message.
  final Duration? voiceMessageDuration;

  /// Id of message, it replies to.
  final String repliedMessageId;

  const ReplyMessage({
    this.repliedMessageId = '',
    this.message = '',
    this.replyUserId = '',
    this.replyBy = '',
    this.messageType = MessageType.text,
    this.voiceMessageDuration,
  });

  factory ReplyMessage.fromJson(Map<String, dynamic> json) => ReplyMessage(
        message: json['message'],
        replyBy: json['replyBy'],
        replyUserId: json['replyTo'],
        messageType: json["message_type"],
        repliedMessageId: json["id"],
        voiceMessageDuration: json["voiceMessageDuration"],
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'replyBy': replyBy,
        'replyTo': replyUserId,
        'message_type': messageType,
        'id': repliedMessageId,
        'voiceMessageDuration': voiceMessageDuration,
      };
}
