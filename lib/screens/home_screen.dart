import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/post_card.dart';
// 1. 這裡加上 "as feed"，給這個檔案取個綽號叫 feed
import '../widgets/waterfall_feed.dart' as feed; 

class HomeScreen extends StatelessWidget {
  final Function(Map<String, dynamic>) onUserTap;

  const HomeScreen({super.key, required this.onUserTap});

  // 假資料：貼文
  static const List<Post> _mockPosts = [
    Post(id: '1', authorName: '美食探險家小雅', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', verified: true, content: '今天發現了一家超讚的台灣小吃店！滷肉飯香氣撲鼻 😋', image: 'https://images.unsplash.com/photo-1617422725360-45b7671f980b?w=800', likes: 342, comments: 28, timestamp: '2小時前'),
    Post(id: '2', authorName: '時尚達人 Amy', authorAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100', verified: true, content: '新入手的秋冬穿搭分享 ✨ 這件針織外套質感真的超好！', image: 'https://images.unsplash.com/photo-1532453288672-3a27e9be9efd?w=800', likes: 856, comments: 124, timestamp: '5小時前'),
  ];

  // 2. 明確指定使用 feed 裡面的 WaterfallItem
  static const List<feed.WaterfallItem> _waterfallItems = [
    feed.WaterfallItem(id: '1', image: 'https://images.unsplash.com/photo-1737214475335-8ed64d91f473?w=600', title: '2024 最新法式指甲設計', authorName: 'Nail Studio', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 1234, aspectRatio: 1.3),
    feed.WaterfallItem(id: '2', image: 'https://images.unsplash.com/photo-1544580353-4a24b9074137?w=600', title: '韓系穿搭分享', authorName: 'Amy', authorAvatar: 'https://images.unsplash.com/photo-1589553009868-c7b2bb474531?w=100', likes: 2341, aspectRatio: 1.5),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ..._mockPosts.map((post) => GestureDetector(
          onTap: () => onUserTap({
            'name': post.authorName,
            'avatar': post.authorAvatar,
            'verified': post.verified
          }),
          child: PostCard(post: post),
        )),
        const SizedBox(height: 16),
        const Text("精選推薦", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        
        // 3. 明確指定使用 feed 裡面的 WaterfallFeed
        feed.WaterfallFeed(items: _waterfallItems),
      ],
    );
  }
}