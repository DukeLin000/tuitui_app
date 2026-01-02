// lib/widgets/post_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; 
import '../models/post.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/shop/store_profile_screen.dart';
// [新增] 引入詳情頁
import '../screens/social/post_detail_screen.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false; // [新增] 本地按讚狀態
  late int likeCount;

  @override
  void initState() {
    super.initState();
    likeCount = widget.post.likes;
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  void _navigateToDetail() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => PostDetailScreen(post: widget.post))
    );
  }

  void _navigateToProfile(BuildContext context) {
    if (widget.post.isMerchant) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => StoreProfileScreen(merchantName: widget.post.authorName, avatarUrl: widget.post.authorAvatar)));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(userId: widget.post.authorName, userName: widget.post.authorName, userAvatar: widget.post.authorAvatar)));
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
                GestureDetector(onTap: () => _navigateToProfile(context), child: CircleAvatar(backgroundImage: CachedNetworkImageProvider(widget.post.authorAvatar), radius: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _navigateToProfile(context),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [Text(widget.post.authorName, style: const TextStyle(fontWeight: FontWeight.bold)), if (widget.post.verified) ...[const SizedBox(width: 4), const Icon(Icons.check_circle, size: 14, color: Colors.blue)]]),
                      Text(widget.post.timestamp, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ]),
                  ),
                ),
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
          ),

          // 2. 內容區域 (圖片 + 文字) -> [新增] 包裹 GestureDetector 點擊跳轉詳情
          GestureDetector(
            onTap: _navigateToDetail,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.post.image.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: widget.post.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(height: 300, color: Colors.grey[200]),
                    errorWidget: (context, url, error) => const SizedBox(height: 200, child: Icon(Icons.error)),
                  ),
                
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(widget.post.content, style: const TextStyle(fontSize: 15), maxLines: 3, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),

          // 3. 底部互動列
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                // 愛心按鈕 (可點擊)
                GestureDetector(
                  onTap: _toggleLike,
                  child: Row(
                    children: [
                      Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? Colors.red : Colors.black, size: 24),
                      const SizedBox(width: 6),
                      Text('$likeCount'),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                
                // 留言按鈕 (跳轉詳情)
                GestureDetector(
                  onTap: _navigateToDetail,
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 22),
                      const SizedBox(width: 6),
                      Text('${widget.post.comments}'),
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