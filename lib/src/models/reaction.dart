class Reaction {
  Reaction({
    required this.reactions,
    required this.reactedUserNames,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) => Reaction(
        reactions: json['reactions'],
        reactedUserNames: json['reactedUserIds'],
      );

  /// Provides list of reaction in single message.
  final List<String> reactions;

  /// Provides list of user who reacted on message.
  final List<String> reactedUserNames;

  Map<String, dynamic> toJson() => {
        'reactions': reactions,
        'reactedUserIds': reactedUserNames,
      };
}
