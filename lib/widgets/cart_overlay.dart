// lib/widgets/cart_overlay.dart
import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartOverlay extends StatelessWidget {
  final List<CartItem> cartItems;
  final VoidCallback onClose;
  final Function(String, int) onUpdateQuantity;
  final int totalAmount;

  const CartOverlay({
    super.key,
    required this.cartItems,
    required this.onClose,
    required this.onUpdateQuantity,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("購物車", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.close), onPressed: onClose),
                    ],
                  ),
                ),
                Expanded(
                  child: cartItems.isEmpty 
                    ? const Center(child: Text("購物車是空的"))
                    : ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return ListTile(
                            leading: Image.network(item.image, width: 50, height: 50, fit: BoxFit.cover),
                            title: Text(item.name),
                            subtitle: Text("NT\$ ${item.price}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => onUpdateQuantity(item.id, -1)),
                                Text("${item.quantity}"),
                                IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => onUpdateQuantity(item.id, 1)),
                              ],
                            ),
                          );
                        },
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(backgroundColor: Colors.purple, padding: const EdgeInsets.all(16)),
                      child: Text("結帳 (NT\$ $totalAmount)"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}