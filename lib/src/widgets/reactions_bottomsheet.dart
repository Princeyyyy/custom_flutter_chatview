import 'package:chatview/src/controller/chat_controller.dart';
import 'package:chatview/src/models/models.dart';
import 'package:flutter/material.dart';

class ReactionsBottomSheet {
  Future<void> show({
    required BuildContext context,

    /// Provides reaction instance of message.
    required Reaction reaction,

    /// Provides controller for accessing few function for running chat.
    required ChatController chatController,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          color: Colors.white,
          child: ListView.builder(
            padding: const EdgeInsets.only(
              right: 12,
              left: 12,
              top: 18,
            ),
            itemCount: reaction.reactedUserNames.length,
            itemBuilder: (_, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      offset: const Offset(0, 20),
                      blurRadius: 40,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Text(
                            reaction.reactedUserNames[index],
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      reaction.reactions[index],
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
