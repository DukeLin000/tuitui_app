// lib/models/post.dart
import 'waterfall_item.dart';

class Post {
  final String id;
  // 👇 [新增] 儲存作者 ID (UUID)，用於辨識是否為自己的貼文
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

  // [原有] 記錄當前用戶是否已按讚
  final bool isLikedByMe;

  // [新增] 標籤列表 (例如: ["美食", "好物推薦"])
  final List<String> tags;

  const Post({
    required this.id,
    // 👇 [新增] 建構子加入 userId
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
    // [新增] 預設為空列表，避免 null 錯誤
    this.tags = const [],
  });

  // ==========================================
  // 👇 重點修改：新增 fromJson 解析後端資料
  // ==========================================
  factory Post.fromJson(Map<String, dynamic> json) {
    // 1. [原有邏輯] 處理圖片
    String coverImage = 'https://via.placeholder.com/300';
    if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      coverImage = json['images'][0]['imageUrl'] ?? coverImage;
    }

    // 2. [新增邏輯] 處理標籤
    // 檢查後端是否有傳 'tags'，如果有的話轉成 List<String>，否則給空陣列
    List<String> parsedTags = [];
    if (json['tags'] != null) {
      // List.from 確保將 dynamic list 安全轉為 String list
      parsedTags = List<String>.from(json['tags']);
    }

    // 3. [修正邏輯] 解析作者資訊 (優先使用 user 物件中的資料)
    String parsedAuthorName = '匿名用戶';
    String parsedAuthorAvatar = 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100';
    // 👇 [新增] 解析 userId
    String parsedUserId = '';

    if (json['user'] != null) {
      parsedAuthorName = json['user']['nickname'] ?? parsedAuthorName;
      parsedAuthorAvatar = json['user']['avatarUrl'] ?? parsedAuthorAvatar;
      // 👇 從 user 物件拿 ID (轉字串以防萬一)
      if (json['user']['id'] != null) {
        parsedUserId = json['user']['id'].toString();
      }
    } else if (json['userId'] != null) {
      // 降級處理：如果沒有 user 物件但有 userId
      parsedAuthorName = json['userId'].toString();
      // 👇 從根目錄拿 ID
      parsedUserId = json['userId'].toString();
    }

    return Post(
      // [原有邏輯] ID 轉 String
      id: json['id'].toString(),
      // 👇 [新增] 帶入解析好的 userId
      userId: parsedUserId,
      // [修正邏輯] 使用解析後的真實暱稱
      authorName: parsedAuthorName,
      // [修正邏輯] 使用解析後的真實頭像
      authorAvatar: parsedAuthorAvatar,
      verified: false,
      content: json['content'] ?? '',
      image: coverImage,
      likes: json['likeCount'] ?? 0,
      comments: json['commentCount'] ?? 0,
      timestamp: '剛剛',
      isMerchant: false,
      // [新增] 帶入解析好的標籤
      tags: parsedTags,
    );
  }

  // [原有] copyWith 方法保持不變，但加入 tags 支援
  Post copyWith({
    String? id,
    // 👇 [新增] copyWith 支援修改 userId
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
    // [新增] 允許修改 tags
    List<String>? tags,
  }) {
    return Post(
      id: id ?? this.id,
      // 👇 [新增] 如果沒傳入新 userId，就用舊的
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
      // [新增] 如果沒傳入新 tags，就用舊的
      tags: tags ?? this.tags,
    );
  }

  // [原有] 轉為瀑布流物件的方法
  WaterfallItem toWaterfallItem() {
    // 避免 id 是非數字字串導致 hashCode 出錯的保險寫法
    final double randomRatio = (id.hashCode % 5 + 10) / 10.0;
    return WaterfallItem(
      id: id,
      // 👇 [關鍵修正] 這裡必須傳入 userId，WaterfallItem 才能正確記錄作者
      userId: userId,
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