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

  // ==========================================
  // 👇 重點修改：新增 fromJson 解析後端資料
  // ==========================================
  factory Post.fromJson(Map<String, dynamic> json) {
    // 1. 處理圖片：後端給的是 List<PostImage>，我們取第一張當封面
    // 如果沒有圖片，就給一張預設圖避免報錯
    String coverImage = 'https://via.placeholder.com/300';
    if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      coverImage = json['images'][0]['imageUrl'] ?? coverImage;
    }

    return Post(
      // 後端 ID 可能是數字 (Long)，轉成 String
      id: json['id'].toString(), 
      // 後端目前只有 userId，暫時當作名字顯示
      authorName: json['userId'] ?? '匿名用戶', 
      // 後端暫無頭像欄位，先給預設圖
      authorAvatar: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100', 
      verified: false, 
      content: json['content'] ?? '',
      image: coverImage, 
      likes: json['likeCount'] ?? 0,
      comments: json['commentCount'] ?? 0,
      // 後端有 createdDate 但這裡先簡化顯示
      timestamp: '剛剛', 
      isMerchant: false,
    );
  }

  // [原有] copyWith 方法保持不變
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

  // [原有] 轉為瀑布流物件的方法
  WaterfallItem toWaterfallItem() {
    // 避免 id 是非數字字串導致 hashCode 出錯的保險寫法 (雖然後端是 Long 應該沒事)
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