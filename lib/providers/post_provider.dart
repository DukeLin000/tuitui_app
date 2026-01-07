// lib/providers/post_provider.dart
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/waterfall_item.dart';
import '../services/api_service.dart'; // [新增] 引入我們剛寫好的 API 服務

class PostProvider extends ChangeNotifier {
  // 1. 核心資料來源 (改為預設空陣列，等待從後端載入)
  List<Post> _items = [];
  
  // [新增] 載入狀態標記 (可用於顯示轉圈圈 Loading)
  bool isLoading = false;

  // 2. 獲取 Post 列表
  List<Post> get items => [..._items];

  // [新增] 從後端 API 載入資料
  Future<void> fetchPosts() async {
    isLoading = true;
    notifyListeners(); // 通知 UI 更新 (例如顯示 Loading)

    try {
      // 呼叫 Service 去跟 Spring Boot 拿資料
      _items = await ApiService.fetchPosts();
    } catch (e) {
      print("Error fetching posts: $e");
      // 發生錯誤時保持 _items 為空或保留舊資料
    } finally {
      isLoading = false;
      notifyListeners(); // 載入完成，通知 UI 顯示內容
    }
  }

  // 3. 獲取 WaterfallItem 列表 (發現頁用)
  List<WaterfallItem> get discoveryItems {
    return _items.map((post) => post.toWaterfallItem()).toList();
  }

  // 4. 發布貼文 (修改為非同步，呼叫後端)
  Future<void> addPost(Post post) async {
    // 呼叫後端 API 建立貼文
    // 注意：這裡假設 post.authorName 為 userId，因為後端目前是用 userId 關聯
    final success = await ApiService.createPost(post.authorName, post.content);
    
    if (success) {
      // 如果成功，重新從後端抓取最新列表，確保資料一致
      await fetchPosts();
    } else {
      print("發布貼文失敗");
      // 這裡可以加入錯誤處理邏輯，例如顯示 SnackBar
    }
  }

  // 5. 按讚/取消讚 (目前維持前端模擬，因為後端尚未實作按讚 API)
  void toggleLike(String postId) {
    final index = _items.indexWhere((p) => p.id == postId);
    
    if (index != -1) {
      final oldPost = _items[index];
      final newIsLiked = !oldPost.isLikedByMe;
      final newLikeCount = oldPost.likes + (newIsLiked ? 1 : -1);

      _items[index] = oldPost.copyWith(
        isLikedByMe: newIsLiked,
        likes: newLikeCount,
      );

      notifyListeners();
      // TODO: 未來後端加入 POST /api/posts/{id}/like 時，在這裡呼叫 ApiService
    }
  }
}