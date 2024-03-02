import 'package:chatview/chatview.dart';
import 'package:example/data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Example());
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat UI Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xffEE5366),
        colorScheme:
            ColorScheme.fromSwatch(accentColor: const Color(0xffEE5366)),
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isDarkTheme = false;

  final _chatController = ChatController(
    initialMessageList: Data.generateDummyData(30),
    scrollController: ScrollController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatView(
        chatController: _chatController,
        onSendTap: _onSendTap,
        featureActiveConfig: const FeatureActiveConfig(
          lastSeenAgoBuilderVisibility: true,
          receiptsBuilderVisibility: true,
          enableSwipeToSeeTime: true,
        ),
        chatBackgroundConfig: const ChatBackgroundConfiguration(
          messageTimeIconColor: Colors.black,
          messageTimeTextStyle: TextStyle(color: Colors.black),
          defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 17,
            ),
          ),
          backgroundColor: Colors.grey,
        ),
        sendMessageConfig: SendMessageConfiguration(
          replyMessageColor: Colors.black,
          defaultSendButtonColor: Colors.pink,
          replyDialogColor: Colors.blueGrey[400],
          replyTitleColor: Colors.black,
          textFieldBackgroundColor: Colors.white,
          closeIconColor: Colors.white,
          textFieldConfig: const TextFieldConfiguration(
            compositionThresholdTime: Duration(seconds: 1),
            textStyle: TextStyle(color: Colors.black),
          ),
        ),
        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: const ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              linkStyle: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
              backgroundColor: Color(0xffFCD8DC),
              bodyStyle: TextStyle(color: Colors.black),
              titleStyle: TextStyle(color: Colors.black),
            ),
            receiptsWidgetConfig:
                ReceiptsWidgetConfig(showReceiptsIn: ShowReceiptsIn.all),
          ),
          inComingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: const LinkPreviewConfiguration(
              linkStyle: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
              backgroundColor: Color(0xffFCD8DC),
              bodyStyle: TextStyle(color: Colors.black),
              titleStyle: TextStyle(color: Colors.black),
            ),
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
            onMessageRead: (message) {
              /// send your message receipts to the other client
              debugPrint('Message Read');
            },
          ),
        ),
        replyPopupConfig: const ReplyPopupConfiguration(
          backgroundColor: Colors.white,
          buttonTextStyle: TextStyle(
            color: Colors.black,
          ),
          topBorderColor: Color(0xFFBDBDBD),
        ),
        messageConfig: MessageConfiguration(
          messageReactionConfig: MessageReactionConfiguration(
            backgroundColor: const Color(0xFFEEEEEE),
            borderColor: const Color(0xFFEEEEEE),
            reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
              backgroundColor: Colors.white,
              reactedUserTextStyle: const TextStyle(
                color: Colors.black,
              ),
              reactionWidgetDecoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: isDarkTheme ? Colors.black12 : Colors.grey.shade200,
                    offset: const Offset(0, 20),
                    blurRadius: 40,
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          imageMessageConfig: const ImageMessageConfiguration(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          ),
        ),
        repliedMessageConfig: const RepliedMessageConfiguration(
          backgroundColor: Color(0xffff8aad),
          verticalBarColor: Color(0xffEE5366),
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.25,
          ),
          replyTitleTextStyle: TextStyle(
            color: Colors.black,
          ),
        ),
        currentUserId: "currentUser.id",
      ),
    );
  }

  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) {
    final id = int.parse(Data.messages.last.id) + 1;
    _chatController.addMessage(
      Message(
        id: id.toString(),
        createdAt: DateTime.now(),
        message: message,
        messageSenderId: "currentUser.id",
        replyMessage: replyMessage,
        messageType: messageType,
      ),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      _chatController.initialMessageList.last.setStatus =
          MessageStatus.delivered;
    });

    Future.delayed(const Duration(seconds: 1), () {
      _chatController.initialMessageList.last.setStatus = MessageStatus.read;
    });
  }
}
