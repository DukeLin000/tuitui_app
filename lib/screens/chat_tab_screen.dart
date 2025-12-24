// lib/screens/chat_tab_screen.dart
import 'package:flutter/material.dart';
import 'chat_room_screen.dart';

class ChatTabScreen extends StatefulWidget {
  const ChatTabScreen({super.key});

  @override
  State<ChatTabScreen> createState() => _ChatTabScreenState();
}

class _ChatTabScreenState extends State<ChatTabScreen> {
  String? _activeChatId; // 記錄目前是否在聊天室中

  @override
  Widget build(BuildContext context) {
    // 如果有選中的聊天對象，顯示聊天室
    if (_activeChatId != null) {
      return ChatRoomScreen(
        chatId: _activeChatId!,
        onBack: () => setState(() => _activeChatId = null),
      );
    }

    // 否則顯示訊息列表
    return Scaffold(
      appBar: AppBar(
        title: const Text("訊息"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: List.generate(4, (index) => ListTile(
          leading: const CircleAvatar(backgroundImage: NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100')),
          title: Text("使用者 $index"),
          subtitle: const Text("嗨！你好嗎？"),
          trailing: const Text("10:00", style: TextStyle(color: Colors.grey, fontSize: 12)),
          onTap: () => setState(() => _activeChatId = "$index"),
        )),
      ),
    );
  }
}