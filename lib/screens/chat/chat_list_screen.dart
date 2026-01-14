// lib/screens/chat/chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart'; // [新增]
import '../../models/chat_thread.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  // ❌ [移除] static const List<ChatThread> _mockThreads = [...]; 假資料

  @override
  void initState() {
    super.initState();
    // 👇 [新增] 初始化時載入真實資料
    Future.microtask(() => context.read<ChatProvider>().loadThreads());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("訊息"),
        centerTitle: true,
      ),
      // 👇 [修改] 使用 Consumer 監聽 Provider 資料
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (chatProvider.threads.isEmpty) {
            return const Center(child: Text("目前沒有訊息", style: TextStyle(color: Colors.grey)));
          }

          return ListView.separated(
            itemCount: chatProvider.threads.length,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 76),
            itemBuilder: (context, index) {
              final thread = chatProvider.threads[index];
              return InkWell(
                onTap: () {
                  // 👇 [新增] 點擊進入聊天室，帶入真實 ID
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoomScreen(
                        chatId: thread.id, // 傳入 chatId
                        userName: thread.userName,
                        userAvatar: thread.userAvatar, // 順便傳頭像進去
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // ... (原有 UI 佈局保持不變，改讀取 thread 變數即可) ...
                      CircleAvatar(backgroundImage: NetworkImage(thread.userAvatar), radius: 25),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(thread.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(thread.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}