import 'package:flutter/material.dart';
import '../models/chat_thread.dart';
import '../models/chat_message.dart';
import '../services/api_service.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatThread> _threads = [];
  List<ChatMessage> _currentMessages = [];
  bool isLoading = false;

  List<ChatThread> get threads => _threads;
  List<ChatMessage> get currentMessages => _currentMessages;

  // 載入聊天列表
  Future<void> loadThreads() async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await ApiService.fetchChatThreads();
      _threads = data.map((json) => ChatThread.fromJson(json)).toList();
    } catch (e) {
      print("Load threads error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 載入特定聊天室訊息
  Future<void> loadMessages(String chatId, String myUserId) async {
    try {
      final data = await ApiService.fetchMessages(chatId);
      _currentMessages = data.map((json) => ChatMessage.fromJson(json, myUserId)).toList();
      notifyListeners();
    } catch (e) {
      print("Load messages error: $e");
    }
  }

  // 發送訊息
  Future<void> sendMessage(String chatId, String content, String myUserId) async {
    // 1. 樂觀更新 (先顯示在畫面上)
    final tempMsg = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      senderId: myUserId,
      content: content,
      timestamp: '剛剛',
      isMe: true,
    );
    _currentMessages.add(tempMsg);
    notifyListeners();

    // 2. 呼叫後端
    final success = await ApiService.sendMessage(chatId, content);
    
    // 3. 如果失敗，應該要移除 tempMsg 並提示 (這裡簡化處理)
    if (success) {
      // 成功後重新拉取一次，確保 ID 正確
      await loadMessages(chatId, myUserId);
    }
  }
}