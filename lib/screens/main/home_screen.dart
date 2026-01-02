import 'package:flutter/material.dart';
import '../../models/post.dart';
import '../../widgets/post_card.dart';
import '../../models/waterfall_item.dart'; // 1. 引入統一的 Model
import '../../widgets/waterfall_feed.dart'; // 2. 移除 'as feed'，直接使用 Widget
import '../../widgets/responsive_container.dart'; // 引入共用的 RWD 容器

class HomeScreen extends StatelessWidget {
  final Function(Map<String, dynamic>) onUserTap;

  const HomeScreen({super.key, required this.onUserTap});

  // 1. 貼文資料 (FeedSection)
  static const List<Post> _mockPosts = [
    Post(
      id: '1', 
      authorName: '美食探險家小雅', 
      authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', 
      verified: true, 
      content: '今天發現了一家超讚的台灣小吃店！滷肉飯香氣撲鼻 😋', 
      image: 'https://images.unsplash.com/photo-1617422725360-45b7671f980b?w=800', 
      likes: 342, 
      comments: 28, 
      timestamp: '2小時前'
    ),
    Post(
      id: '2', 
      authorName: '時尚達人 Amy', 
      authorAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100', 
      verified: true, 
      content: '新入手的秋冬穿搭分享 ✨ 這件針織外套質感真的超好！', 
      image: 'https://images.unsplash.com/photo-1532453288672-3a27e9be9efd?w=800', 
      likes: 856, 
      comments: 124, 
      timestamp: '5小時前'
    ),
  ];

  // 2. 瀑布流資料 (WaterfallFeed)
  // [修正] 使用 WaterfallItem (來自 models)，不再是 feed.WaterfallItem
  static const List<WaterfallItem> _waterfallItems = [
    WaterfallItem(id: '3', image: 'https://images.unsplash.com/photo-1737214475335-8ed64d91f473?w=600', title: '2024 最新法式指甲設計', authorName: 'Nail Studio', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 1234, aspectRatio: 1.3),
    WaterfallItem(id: '4', image: 'https://images.unsplash.com/photo-1544580353-4a24b9074137?w=600', title: '韓系穿搭分享', authorName: 'Amy', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 2341, aspectRatio: 1.5),
    WaterfallItem(id: '5', image: 'https://images.unsplash.com/photo-1634850034923-31cda5d080f5?w=600', title: '中山站咖啡廳推薦', authorName: 'Cafe Lover', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 892, aspectRatio: 1.2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0), 
        children: [
          
          // --- 第一部分：FeedSection (貼文列表) ---
          ..._mockPosts.map((post) => ResponsiveContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GestureDetector(
                onTap: () => onUserTap({
                  'name': post.authorName,
                  'avatar': post.authorAvatar,
                  'verified': post.verified
                }),
                child: PostCard(post: post),
              ),
            ),
          )),

          // --- 第二部分：分隔標題 ---
          const ResponsiveContainer(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Text(
                "為您推薦",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // --- 第三部分：WaterfallFeed (瀑布流) ---
          ResponsiveContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), 
            // [修正] 直接使用 WaterfallFeed，不再需要 feed 前綴
            child: WaterfallFeed(items: _waterfallItems),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}