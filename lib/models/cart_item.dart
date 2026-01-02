// lib/models/cart_item.dart
enum ItemType { product, reservation }
bool isSelected = true; // 預設選取

class CartItem {
  final String id;
  final String name;
  final int price;
  int quantity;
  final String image;
  final ItemType type;
  final String? bookingDate;
  final int? peopleCount; // [新增] 預約人數欄位
  bool isSelected; // [新增] 記錄選取狀態

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.image,
    this.type = ItemType.product,
    this.bookingDate,
    this.peopleCount, // [新增]
    this.isSelected = true, // [新增] 預設為全選
  });
}