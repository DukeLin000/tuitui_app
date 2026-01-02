// lib/models/waterfall_item.dart
import 'cart_item.dart'; 

class WaterfallItem {
  final String id;
  final String image;
  final String title;
  final String authorName;
  final String authorAvatar;
  final int likes;
  final double aspectRatio;
  final int? price; 
  final ItemType type;
  
  // [新增] 關鍵欄位：判斷是否為商家帳號
  final bool isMerchant;

  const WaterfallItem({
    required this.id,
    required this.image,
    required this.title,
    required this.authorName,
    required this.authorAvatar,
    required this.likes,
    required this.aspectRatio,
    this.price,
    this.type = ItemType.product,
    
    // [新增] 預設為 false (一般用戶)，這樣舊資料不會報錯
    this.isMerchant = false, 
  });
}