// lib/models/post.dart
class Post {
  final String id;
  final String authorName;
  final String authorAvatar;
  final bool verified;
  final String content;
  final String image;
  final int likes;
  final int comments;
  final String timestamp;

  const Post({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    this.verified = false,
    required this.content,
    required this.image,
    required this.likes,
    required this.comments,
    required this.timestamp,
  });
}

class WaterfallItem {
  final String id;
  final String image;
  final String title;
  final String authorName;
  final String authorAvatar;
  final int likes;
  final double aspectRatio; // 用來控制瀑布流圖片的長寬比

  const WaterfallItem({
    required this.id,
    required this.image,
    required this.title,
    required this.authorName,
    required this.authorAvatar,
    required this.likes,
    required this.aspectRatio,
  });
}
