// Different types Message of ChatView
enum MessageType {
  image,
  text,
  voice,
}

/// [MessageStatus] defines the current state of the message
/// if you are sender sending a message then, the
enum MessageStatus { read, delivered }

/// Types of states
enum ChatViewState { hasMessages, noData, loading, error }

enum ShowReceiptsIn { all, lastMessage }
