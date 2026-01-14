class ChatThread {
  final String id;
  final String userName;
  final String userAvatar;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOfficial;

  const ChatThread({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOfficial = false,
  });

  // 👇 [新增] 解析後端 JSON
  factory ChatThread.fromJson(Map<String, dynamic> json) {
    return ChatThread(
      id: json['id'].toString(),
      userName: json['targetUser']['nickname'] ?? '未知用戶',
      userAvatar: json['targetUser']['avatarUrl'] ?? 'https://via.placeholder.com/100',
      lastMessage: json['lastMessage'] ?? '',
      time: json['lastMessageTime'] ?? '', // 後端需回傳格式化好的時間，或前端再處理
      unreadCount: json['unreadCount'] ?? 0,
      isOfficial: false, // 視後端邏輯而定
    );
  }
}