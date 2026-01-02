// lib/screens/chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../models/chat_thread.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  // 1. 準備假資料
  static const List<ChatThread> _mockThreads = [
    const ChatThread(
      id: '1',
      userName: '推推官方小幫手',
      userAvatar: 'https://images.unsplash.com/photo-1614680376593-902f74cf0d41?w=100', // 官方圖標
      lastMessage: '恭喜您獲得新手禮包！點擊查看詳情 🎁',
      time: '剛剛',
      unreadCount: 1,
      isOfficial: true,
    ),
    const ChatThread(
      id: '2',
      userName: '時尚達人 Amy',
      userAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      lastMessage: '請問這件外套還有其他顏色嗎？',
      time: '10:23',
      unreadCount: 3,
    ),
    const ChatThread(
      id: '3',
      userName: '美食探險家小雅',
      userAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100',
      lastMessage: '哈哈，那家店真的超好吃的！下次一起去',
      time: '昨天',
      unreadCount: 0,
    ),
    const ChatThread(
      id: '4',
      userName: '攝影師 Jack',
      userAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      lastMessage: '照片已經傳給你囉，記得查收',
      time: '星期一',
      unreadCount: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("訊息"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.playlist_add_check)),
        ],
      ),
      body: ListView.separated(
        itemCount: _mockThreads.length,
        separatorBuilder: (context, index) => const Divider(height: 1, indent: 76), // 分隔線
        itemBuilder: (context, index) {
          final thread = _mockThreads[index];
          return InkWell(
            onTap: () {
              // TODO: 下一步 - 點擊進入 ChatRoom
              if (kDebugMode) {
                debugPrint("點擊了與 ${thread.userName} 的對話");
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // 頭像區域
                  Stack(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[200]!),
                          image: DecorationImage(
                            image: NetworkImage(thread.userAvatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // 官方認證標記
                      if (thread.isOfficial)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.check_circle, size: 14, color: Colors.blue),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  
                  // 文字區域
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              thread.userName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              thread.time,
                              style: TextStyle(color: Colors.grey[500], fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                thread.lastMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis, // 文字過長顯示 ...
                                style: TextStyle(
                                  color: thread.unreadCount > 0 ? Colors.black87 : Colors.grey[600],
                                  fontWeight: thread.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                                ),
                              ),
                            ),
                            // 未讀紅點
                            if (thread.unreadCount > 0)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${thread.unreadCount}',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
