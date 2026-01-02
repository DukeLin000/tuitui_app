// lib/screens/chat/chat_room_screen.dart
import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  // [修改] 這裡接收 userName，方便顯示在標題
  // 如果未來要串接 API，這裡應該也要接收 targetUserId
  final String userName;
  final String? chatId; // 可選，如果是新對話可能還沒有 ID

  const ChatRoomScreen({
    super.key, 
    required this.userName, 
    this.chatId
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  // 模擬訊息數據
  final List<String> _messages = ['嗨！請問這件商品還有貨嗎？', '有的，目前庫存充足喔！', '太棒了，那我直接下單'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 改為白色背景比較清爽
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const BackButton(color: Colors.black), // 使用系統預設返回鍵
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16, 
              // 這裡未來可以改為接收 userAvatar 參數
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100')
            ),
            const SizedBox(width: 10),
            // [修改] 顯示傳入的 userName
            Text(widget.userName, style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert, color: Colors.black))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                // 簡單模擬：偶數是我發的，奇數是對方的
                final isMe = index % 2 == 0;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7), // 限制最大寬度
                    decoration: BoxDecoration(
                      color: isMe ? Colors.purple : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20).copyWith(
                        bottomRight: isMe ? const Radius.circular(4) : null,
                        bottomLeft: !isMe ? const Radius.circular(4) : null,
                      ),
                    ),
                    child: Text(
                      _messages[index],
                      style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // 底部輸入框
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white, 
                border: Border(top: BorderSide(color: Colors.grey[200]!))
              ),
              child: Row(
                children: [
                  IconButton(onPressed: (){}, icon: const Icon(Icons.add_circle_outline, color: Colors.purple)),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "傳送訊息...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.purple,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          setState(() => _messages.add(_controller.text));
                          _controller.clear();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}