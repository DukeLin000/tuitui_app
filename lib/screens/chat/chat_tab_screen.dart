// lib/screens/chat/chat_tab_screen.dart
import 'package:flutter/material.dart';
import 'chat_room_screen.dart';
import '../../widgets/responsive_container.dart'; 

class ChatTabScreen extends StatefulWidget {
  const ChatTabScreen({super.key});

  @override
  State<ChatTabScreen> createState() => _ChatTabScreenState();
}

class _ChatTabScreenState extends State<ChatTabScreen> {
  // [刪除] _activeChatId 變數，改用 Navigator 跳轉

  // 假資料
  final List<Map<String, dynamic>> _mockChats = [
    {
      'id': '1',
      'name': '美食探險家小雅',
      'avatar': 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100',
      'message': '那家店的滷肉飯真的超好吃！推薦你去試試看 😋',
      'time': '10:30',
      'unread': 2,
    },
    {
      'id': '2',
      'name': '時尚達人 Amy',
      'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      'message': '這件外套有其他顏色嗎？我想買米白色的',
      'time': '昨天',
      'unread': 0,
    },
    {
      'id': '3',
      'name': '科技開箱王',
      'avatar': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100',
      'message': '影片已經上傳囉，連結在這裡...',
      'time': '週一',
      'unread': 1,
    },
    {
      'id': '4',
      'name': '客服小幫手',
      'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
      'message': '您好，請問有什麼能為您服務的嗎？',
      'time': '週一',
      'unread': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      
      appBar: AppBar(
        title: const ResponsiveContainer(
          child: Text("訊息", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        backgroundColor: Colors.grey[50], 
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      
      body: ResponsiveContainer(
        child: Container(
          color: Colors.white,
          child: ListView.separated(
            itemCount: _mockChats.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE), indent: 72),
            itemBuilder: (context, index) {
              final chat = _mockChats[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                // 頭像
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(chat['avatar']),
                      backgroundColor: Colors.grey[200],
                    ),
                    if (chat['unread'] > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                // 名稱
                title: Text(
                  chat['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                // 訊息預覽
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    chat['message'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
                // 時間與未讀數
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      chat['time'],
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    if (chat['unread'] > 0) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${chat['unread']}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
                // [修改] 點擊後跳轉到聊天室頁面
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => ChatRoomScreen(
                        userName: chat['name'], // 傳入名稱
                        chatId: chat['id'],     // 傳入 ID
                      )
                    )
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}