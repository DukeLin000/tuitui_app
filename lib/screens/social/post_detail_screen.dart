// lib/screens/social/post_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/post.dart';
import '../../widgets/responsive_container.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  // 模擬留言數據
  final List<String> _comments = [
    "這件衣服哪裡買的？😍",
    "好有氣質喔！",
    "求連結～"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.post.authorAvatar), radius: 16),
            const SizedBox(width: 8),
            Text(widget.post.authorName, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined, color: Colors.black), onPressed: (){}),
          IconButton(icon: const Icon(Icons.more_horiz, color: Colors.black), onPressed: (){}),
        ],
      ),
      body: ResponsiveContainer(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. 大圖輪播 (這裡簡化為單圖)
                    CachedNetworkImage(
                      imageUrl: widget.post.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    
                    // 2. 貼文內容
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.post.content, style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 12),
                          Text(widget.post.timestamp, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const Divider(height: 32),
                          
                          // 3. 留言區標題
                          Text("共 ${_comments.length} 則留言", style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 16),
                          
                          // 4. 留言列表
                          ..._comments.map((c) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                CircleAvatar(backgroundColor: Colors.grey[200], radius: 16, child: const Icon(Icons.person, size: 16, color: Colors.grey)),
                                const SizedBox(width: 10),
                                Expanded(child: Text(c)),
                                const Icon(Icons.favorite_border, size: 14, color: Colors.grey),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 5. 底部留言輸入框
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[200]!))),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 40,
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: "說點什麼...",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 底部互動按鈕
                    const Icon(Icons.favorite_border, size: 28),
                    const SizedBox(width: 16),
                    const Icon(Icons.star_border, size: 28), // 收藏
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}