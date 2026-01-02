// lib/models/post.dart
import 'waterfall_item.dart'; // [新增] 引入目標 Model

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
  });

  // [新增] 轉換方法：將 Post 轉為 WaterfallItem
  // 這樣一來，任何地方拿到 Post 都可以直接轉成瀑布流需要的格式
  WaterfallItem toWaterfallItem() {
    // 使用 id 的 hashCode 來產生固定的隨機比例 (1.0 ~ 1.5)
    // 這樣確保同一個 Post 每次轉換出來的高度都一樣，不會畫面亂跳
    final double randomRatio = (id.hashCode % 5 + 10) / 10.0;

    return WaterfallItem(
      id: id,
      image: image,
      title: content, // 將貼文內容當作標題
      authorName: authorName,
      authorAvatar: authorAvatar,
      likes: likes,
      aspectRatio: randomRatio,
      isMerchant: isMerchant,
    );
  }
}