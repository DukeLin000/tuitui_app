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
  
  // [新增] 判斷是否為商家
  final bool isMerchant; 

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
    
    // [新增] 預設為 false
    this.isMerchant = false, 
  });
}