// lib/models/cart_item.dart
enum ItemType { product, reservation }

class CartItem {
  final String id;
  final String name;
  final int price;
  int quantity;
  final String image;
  final ItemType type;
  final String? bookingDate;
  final int? peopleCount;
  bool isSelected;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.image,
    this.type = ItemType.product,
    this.bookingDate,
    this.peopleCount,
    this.isSelected = true,
  });

  // ==========================================
  // 👇 新增：解析後端 JSON
  // ==========================================
  factory CartItem.fromJson(Map<String, dynamic> json) {
    // 1. 取得巢狀的 product 物件
    // 後端回傳結構長這樣: 
    // { 
    //   "id": 1, 
    //   "quantity": 2, 
    //   "product": { "name": "...", "price": 100, "imageUrl": "..." } 
    // }
    final product = json['product'];

    // 2. 防呆處理：萬一 product 是 null (雖然理論上不該發生)
    final productName = product != null ? product['name'] : '未知商品';
    // 處理價格：後端可能是 Double 或 Int，用 num 接比較安全
    final productPrice = product != null ? (product['price'] as num).toInt() : 0;
    // 假設後端 Product 有 imageUrl 欄位，若無則給假圖
    final productImage = product != null ? (product['imageUrl'] ?? 'https://via.placeholder.com/150') : 'https://via.placeholder.com/150';

    return CartItem(
      id: json['id'].toString(), // 轉字串
      name: productName,
      price: productPrice,
      quantity: json['quantity'] ?? 1,
      image: productImage,
      type: ItemType.product, // 後端目前只有一般商品
      isSelected: true, // 載入時預設勾選
    );
  }
}