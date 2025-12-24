// lib/widgets/post_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // 使用快取圖片套件
import '../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      surfaceTintColor: Colors.white, // 避免 Material3 變色
      elevation: 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 頭部 (頭像 + 名字)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(post.authorAvatar),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Column(
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
                const Spacer(),
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
          ),

          // 2. 圖片 (中間大圖)
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
              errorWidget: (context, url, error) => const Icon(Icons.error),
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
}