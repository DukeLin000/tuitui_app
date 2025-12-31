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
  final int? peopleCount; // [新增] 預約人數欄位

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.image,
    this.type = ItemType.product,
    this.bookingDate,
    this.peopleCount, // [新增]
  });
}