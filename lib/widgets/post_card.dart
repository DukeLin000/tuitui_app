// lib/widgets/post_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; 
import 'package:provider/provider.dart'; // [新增]
import '../models/post.dart';
import '../providers/post_provider.dart'; // [新增]
import '../screens/profile/profile_screen.dart';
import '../screens/shop/store_profile_screen.dart';
import '../screens/social/post_detail_screen.dart';

// [修改] 改為 StatelessWidget，因為狀態由外部 Provider 控制
class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => PostDetailScreen(post: post))
    );
  }

  void _navigateToProfile(BuildContext context) {
    if (post.isMerchant) {
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
          // 1. Header
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _navigateToProfile(context),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(post.authorAvatar),
                    radius: 20,
                  ),
                ),
                const SizedBox(width: 10),
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
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
          ),

          // 2. 內容區域 (圖片 + 文字)
          GestureDetector(
            onTap: () => _navigateToDetail(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.image.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: post.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(height: 300, color: Colors.grey[200]),
                    errorWidget: (context, url, error) => const SizedBox(height: 200, child: Icon(Icons.error)),
                  ),
                
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(post.content, style: const TextStyle(fontSize: 15), maxLines: 3, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),

          // 3. 底部互動列
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                // [修改] 愛心按鈕邏輯
                GestureDetector(
                  onTap: () {
                    // 呼叫 Provider 更新狀態
                    Provider.of<PostProvider>(context, listen: false).toggleLike(post.id);
                  },
                  child: Row(
                    children: [
                      // 根據 post.isLikedByMe 決定圖示與顏色
                      Icon(
                        post.isLikedByMe ? Icons.favorite : Icons.favorite_border,
                        color: post.isLikedByMe ? Colors.red : Colors.black,
                        size: 24,
                      ),
                      const SizedBox(width: 6),
                      Text('${post.likes}'),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                
                // 留言按鈕
                GestureDetector(
                  onTap: () => _navigateToDetail(context),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 22),
                      const SizedBox(width: 6),
                      Text('${post.comments}'),
                    ],
                  ),
                ),
                const Spacer(),
                const Icon(Icons.bookmark_border, size: 22),
              ],
            ),
          )
        ],
      ),
    );
  }
}