// lib/models/post.dart
import 'waterfall_item.dart';

class Post {
  final String id;
  // 👇 [核心] 儲存作者 ID (UUID)，用於辨識是否為自己的貼文
  final String userId;
  final String authorName;
  final String authorAvatar;
  final bool verified;
  final String content;
  final String image;
  final int likes;
  final int comments;
  final String timestamp;
  final bool isMerchant;

  // [原有] 記錄當前用戶是否已按讚 (目前後端 DTO 還沒給這個欄位，預設 false)
  final bool isLikedByMe;

  // [新增] 標籤列表
  final List<String> tags;

  const Post({
    required this.id,
    required this.userId,
    required this.authorName,
    required this.authorAvatar,
    this.verified = false,
    required this.content,
    required this.image,
    required this.likes,
    required this.comments,
    required this.timestamp,
    this.isMerchant = false,
    this.isLikedByMe = false,
    this.tags = const [],
  });

  // ==========================================
  // 👇 重點修改：適配 Spring Boot PostDto 結構
  // ==========================================
  factory Post.fromJson(Map<String, dynamic> json) {
    
    // 1. [修正] 處理圖片
    // 後端 PostDto 回傳的是 "imageUrls": ["url1", "url2"]
    String coverImage = 'https://via.placeholder.com/300';
    if (json['imageUrls'] != null && (json['imageUrls'] as List).isNotEmpty) {
      coverImage = json['imageUrls'][0]; 
    } 
    // 相容舊版資料結構 (防呆)
    else if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      // 舊結構可能是物件 List
      var firstImg = json['images'][0];
      if (firstImg is String) {
        coverImage = firstImg;
      } else if (firstImg is Map && firstImg['imageUrl'] != null) {
        coverImage = firstImg['imageUrl'];
      }
    }

    // 2. [新增] 處理標籤
    List<String> parsedTags = [];
    if (json['tags'] != null) {
      parsedTags = List<String>.from(json['tags']);
    }

    // 3. [關鍵修正] 解析作者資訊 (對接 PostDto 的 'author' 欄位)
    String parsedAuthorName = '匿名用戶';
    String parsedAuthorAvatar = 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100';
    String parsedUserId = '';
    bool parsedIsMerchant = false;

    // 優先讀取 DTO 的 'author' 欄位
    if (json['author'] != null) {
      final authorData = json['author'];
      parsedAuthorName = authorData['nickname'] ?? authorData['username'] ?? parsedAuthorName;
      parsedAuthorAvatar = authorData['avatarUrl'] ?? parsedAuthorAvatar;
      parsedIsMerchant = authorData['merchant'] ?? false; // UserDto 裡有 isMerchant
      
      if (authorData['id'] != null) {
        parsedUserId = authorData['id'].toString();
      }
    } 
    // 相容舊版 'user' 欄位
    else if (json['user'] != null) {
      final userData = json['user'];
      parsedAuthorName = userData['nickname'] ?? parsedAuthorName;
      parsedAuthorAvatar = userData['avatarUrl'] ?? parsedAuthorAvatar;
      if (userData['id'] != null) {
        parsedUserId = userData['id'].toString();
      }
    }

    return Post(
      id: json['id']?.toString() ?? '',
      userId: parsedUserId,
      authorName: parsedAuthorName,
      authorAvatar: parsedAuthorAvatar,
      verified: false, // DTO 暫時沒回傳此欄位
      content: json['content'] ?? '',
      image: coverImage,
      likes: json['likeCount'] ?? 0,     // 對接 PostDto 的 likeCount
      comments: json['commentCount'] ?? 0, // 對接 PostDto 的 commentCount
      timestamp: '剛剛', // 後端 DTO 回傳的是 createdAt (如 "2024-01-01T12:00:00")，前端若要顯示時間差需另外寫 util
      isMerchant: parsedIsMerchant,
      tags: parsedTags,
    );
  }

  Post copyWith({
    String? id,
    String? userId,
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
    List<String>? tags,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
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
      tags: tags ?? this.tags,
    );
  }

  WaterfallItem toWaterfallItem() {
    // 簡單的 hashCode 轉型，避免非數值 ID 報錯
    final double randomRatio = (id.hashCode % 5 + 10) / 10.0;
    return WaterfallItem(
      id: id,
      userId: userId, // 傳遞正確的 userId
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