// lib/providers/post_provider.dart
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/waterfall_item.dart'; // 確保引入了 WaterfallItem Model

class PostProvider extends ChangeNotifier {
  // 1. 核心資料來源 (模擬後端資料庫)
  // 我們將原本分散在 HomeScreen 的假資料整合到這裡，作為唯一的資料源
  final List<Post> _items = [
    // --- 來自追蹤頁的資料 ---
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
    const Post(
      id: '2',
      authorName: '時尚達人 Amy',
      authorAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      verified: true,
      content: '新入手的秋冬穿搭分享 ✨ 這件針織外套質感真的超好！',
      image: 'https://images.unsplash.com/photo-1532453288672-3a27e9be9efd?w=800',
      likes: 856,
      comments: 124,
      timestamp: '5小時前',
      isMerchant: false,
    ),
    const Post(
      id: '3',
      authorName: 'Nail Studio',
      authorAvatar: 'https://images.unsplash.com/photo-1596462502278-27bfdd403348?w=100',
      verified: true,
      content: '本週新款指甲彩繪，預約請私訊！💅',
      image: 'https://images.unsplash.com/photo-1632515949706-e74736173042?w=800',
      likes: 120,
      comments: 5,
      timestamp: '1天前',
      isMerchant: true,
    ),
    // --- 補上一些資料給發現頁顯示 (模擬原本 Discovery 的內容) ---
    const Post(
      id: '4',
      authorName: 'Cafe Lover',
      authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100',
      verified: false,
      content: '中山站咖啡廳推薦',
      image: 'https://images.unsplash.com/photo-1634850034923-31cda5d080f5?w=600',
      likes: 892,
      comments: 10,
      timestamp: '3小時前',
      isMerchant: false,
    ),
    const Post(
      id: '5',
      authorName: 'Style Icon',
      authorAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      verified: false,
      content: '春季穿搭靈感',
      image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600',
      likes: 520,
      comments: 8,
      timestamp: '1天前',
      isMerchant: false,
    ),
    // 測試用的個人帳號
    const Post(
      id: 'test_user_1',
      authorName: '測試人員小明',
      authorAvatar: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100',
      verified: false,
      content: '這是一則個人帳號的測試貼文，點擊我的頭像應該會跳轉到 ProfileScreen (看別人模式)！🚀',
      image: 'https://images.unsplash.com/photo-1516762689617-e1cffcef479d?w=800',
      likes: 10,
      comments: 2,
      timestamp: '剛剛',
      isMerchant: false,
    ),
  ];

  // 2. [Getter 1] 給「追蹤頁」使用 (直接回傳 Post 列表)
  List<Post> get items => [..._items];

  // 3. [Getter 2] 給「發現頁」使用 (自動將 Post 轉換為 WaterfallItem)
  // [修改] 這裡直接呼叫我們剛在 Post Model 中新增的 `toWaterfallItem` 方法
  // 這樣一來，發布新貼文後，發現頁也會自動更新！
  List<WaterfallItem> get discoveryItems {
    return _items.map((post) => post.toWaterfallItem()).toList();
  }

  // 4. 發布貼文 (新增)
  void addPost(Post post) {
    _items.insert(0, post); // 加在列表最上面
    notifyListeners(); // 通知 UI (HomeScreen) 更新
  }

  // 5. 按讚/取消讚 (同步狀態)
  void toggleLike(String postId) {
    // 這裡先做簡單的通知更新，實際邏輯需要處理 Post 物件的狀態改變 (copyWith)
    notifyListeners();
  }
}