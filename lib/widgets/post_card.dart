// lib/widgets/post_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; 
import '../models/post.dart';
// [新增] 引入這兩個頁面以進行跳轉
import '../screens/profile/profile_screen.dart';
import '../screens/shop/store_profile_screen.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      surfaceTintColor: Colors.white, 
      elevation: 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 頭部 (頭像 + 名字)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // [修改] 讓頭像可點擊
                GestureDetector(
                  onTap: () => _navigateToProfile(context),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(post.authorAvatar),
                    radius: 20,
                  ),
                ),
                const SizedBox(width: 10),
                
                // [修改] 讓名字區域可點擊
                Expanded(
                  child: GestureDetector(
                    onTap: () => _navigateToProfile(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            if (post.verified) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.check_circle, size: 14, color: Colors.blue),
                            ]
                          ],
                        ),
                        Text(post.timestamp, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                // 更多選項按鈕 (通常是檢舉或分享，不觸發個人頁跳轉)
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.grey),
                  onPressed: () {}, 
                ),
              ],
            ),
          ),

          // 2. 圖片 (中間大圖)
          // 這裡可以考慮包一層 GestureDetector，點擊圖片進入「貼文詳情頁」(如果有的話)
          // 目前先保持原樣
          if (post.image.isNotEmpty)
            CachedNetworkImage(
              imageUrl: post.image,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 300, 
                color: Colors.grey[200], 
                child: const Center(child: CircularProgressIndicator())
              ),
              errorWidget: (context, url, error) => Container(
                height: 300,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),

          // 3. 底部 (內容 + 按鈕)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.content, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.favorite_border, size: 22),
                    const SizedBox(width: 6),
                    Text('${post.likes}'),
                    const SizedBox(width: 20),
                    const Icon(Icons.chat_bubble_outline, size: 22),
                    const SizedBox(width: 6),
                    Text('${post.comments}'),
                    const Spacer(),
                    const Icon(Icons.bookmark_border, size: 22),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // [新增] 核心導航邏輯
  void _navigateToProfile(BuildContext context) {
    if (post.isMerchant) {
      // 商家 -> StoreProfileScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StoreProfileScreen(
            merchantName: post.authorName,
            avatarUrl: post.authorAvatar,
          ),
        ),
      );
    } else {
      // 個人 -> ProfileScreen (看別人模式)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(
            userId: post.authorName, // 暫時用名字當 ID
            userName: post.authorName,
            userAvatar: post.authorAvatar,
          ),
        ),
      );
    }
  }
}