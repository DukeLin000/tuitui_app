// lib/screens/chat/chat_room_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';

class ChatRoomScreen extends StatefulWidget {
  final String userName;
  final String? userAvatar; // [新增]
  final String chatId; // [修改] 必須要有 chatId 才能聊

  const ChatRoomScreen({
    super.key, 
    required this.userName, 
    this.userAvatar,
    required this.chatId,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  // ❌ [移除] final List<String> _messages = [...]; 假資料

  @override
  void initState() {
    super.initState();
    final myUserId = context.read<AuthProvider>().userProfile['id']?.toString() ?? '';
    // 👇 [新增] 載入真實訊息
    context.read<ChatProvider>().loadMessages(widget.chatId, myUserId);
  }

  void _handleSend() {
    if (_controller.text.isEmpty) return;
    final myUserId = context.read<AuthProvider>().userProfile['id']?.toString() ?? '';
    
    // 👇 [修改] 呼叫 Provider 發送訊息
    context.read<ChatProvider>().sendMessage(widget.chatId, _controller.text, myUserId);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... AppBar 保持不變 ...
      body: Column(
        children: [
          Expanded(
            // 👇 [修改] 使用 Consumer 顯示真實訊息
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                final messages = chatProvider.currentMessages;
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return Align(
                      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: msg.isMe ? Colors.purple : Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          msg.content, // [修改] 顯示真實內容
                          style: TextStyle(color: msg.isMe ? Colors.white : Colors.black87),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // ... 底部輸入框保持不變，但 Send 按鈕要呼叫 _handleSend ...
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white, size: 18),
            onPressed: _handleSend, // 綁定發送事件
          ),
        ],
      ),
    );
  }
}