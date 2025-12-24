// lib/models/chat_thread.dart
class ChatThread {
  final String id;
  final String userName;
  final String userAvatar;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOfficial; // 是否為官方帳號 (可選)

  const ChatThread({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOfficial = false,
  });
}
