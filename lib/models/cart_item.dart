// lib/models/cart_item.dart
class CartItem {
  final String id;
  final String name;
  final int price;
  int quantity;
  final String image;

  CartItem({
    required this.id, 
    required this.name, 
    required this.price, 
    this.quantity = 1, 
    required this.image
  });
}