// lib/providers/post_provider.dart
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/waterfall_item.dart'; // 用於個人頁作品集

class PostProvider extends ChangeNotifier {
  // 1. 核心資料來源 (模擬後端資料庫)
  final List<Post> _items = [
    // ... 把原本 HomeScreen 的 _followingPosts 資料搬過來 ...
    const Post(
      id: '1',
      authorName: '美食探險家小雅',
      authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100',
      verified: true,
      content: '今天發現了一家超讚的台灣小吃店！滷肉飯香氣撲鼻 😋',
      image: 'https://images.unsplash.com/photo-1617422725360-45b7671f980b?w=800',
      likes: 342,
      comments: 28,
      timestamp: '2小時前',
      isMerchant: false,
    ),
    // ... 其他假資料
  ];

  // 2. 獲取資料的方法
  List<Post> get items => [..._items];

  // 3. 發布貼文 (新增)
  void addPost(Post post) {
    _items.insert(0, post); // 加在最上面
    notifyListeners(); // 通知畫面更新
  }

  // 4. 按讚/取消讚 (同步狀態)
  void toggleLike(String postId) {
    final index = _items.indexWhere((p) => p.id == postId);
    if (index != -1) {
      // 這裡簡化處理，實際可能需要將 Post 改為非 const 或 copyWith
      // 暫時僅做通知更新示意
      notifyListeners();
    }
  }
}