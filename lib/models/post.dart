// lib/models/post.dart
import 'waterfall_item.dart';

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
  final bool isMerchant;
  
  // [新增] 記錄當前用戶是否已按讚
  final bool isLikedByMe;

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
    this.isMerchant = false,
    // [新增] 預設為 false
    this.isLikedByMe = false,
  });

  // [新增] copyWith 方法：用來產生修改後的新物件 (因為 Post 是 immutable 的)
  Post copyWith({
    String? id,
    String? authorName,
    String? authorAvatar,
    bool? verified,
    String? content,
    String? image,
    int? likes,
    int? comments,
    String? timestamp,
    bool? isMerchant,
    bool? isLikedByMe,
  }) {
    return Post(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      verified: verified ?? this.verified,
      content: content ?? this.content,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      timestamp: timestamp ?? this.timestamp,
      isMerchant: isMerchant ?? this.isMerchant,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
    );
  }

  WaterfallItem toWaterfallItem() {
    final double randomRatio = (id.hashCode % 5 + 10) / 10.0;
    return WaterfallItem(
      id: id,
      image: image,
      title: content,
      authorName: authorName,
      authorAvatar: authorAvatar,
      likes: likes,
      aspectRatio: randomRatio,
      isMerchant: isMerchant,
    );
  }
}