class ChatMessage {
  final String id;
  final String senderId;
  final String content;
  final String timestamp;
  final bool isMe; // 用於判斷訊息顯示在左邊還是右邊

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.isMe,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, String myUserId) {
    return ChatMessage(
      id: json['id'].toString(),
      senderId: json['senderId'].toString(),
      content: json['content'] ?? '',
      timestamp: json['createdAt'] ?? '',
      // 👇 比對發送者 ID 是否為自己
      isMe: json['senderId'].toString() == myUserId,
    );
  }
}