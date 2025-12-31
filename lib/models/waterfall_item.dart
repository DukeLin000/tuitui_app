// lib/models/waterfall_item.dart
import 'cart_item.dart'; // [新增] 引入 CartItem 以使用 ItemType

class WaterfallItem {
  final String id;
  final String image;
  final String title;
  final String authorName;
  final String authorAvatar;
  final int likes;
  final double aspectRatio;
  final int? price; // [已存在] 價格欄位
  
  // [新增] 類型欄位：用來判斷是商品還是預約
  final ItemType type;

  const WaterfallItem({
    required this.id,
    required this.image,
    required this.title,
    required this.authorName,
    required this.authorAvatar,
    required this.likes,
    required this.aspectRatio,
    this.price,
    // [新增] 預設是一般商品
    this.type = ItemType.product, 
  });
}