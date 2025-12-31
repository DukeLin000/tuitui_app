// lib/widgets/cart_overlay.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart'; // 引入以辨識 ItemType

class CartOverlay extends StatelessWidget {
  final VoidCallback onClose;

  const CartOverlay({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
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
                    // 標題列
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("購物車 (${cart.itemCount})", 
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          IconButton(icon: const Icon(Icons.close), onPressed: onClose),
                        ],
                      ),
                    ),
                    
                    // 購物車項目列表
                    Expanded(
                      child: cart.items.isEmpty 
                        ? const Center(child: Text("購物車是空的"))
                        : ListView.builder(
                            itemCount: cart.items.length,
                            itemBuilder: (context, index) {
                              final item = cart.items[index];
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(item.image, width: 50, height: 50, fit: BoxFit.cover),
                                ),
                                title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                
                                // [修改] 顯示價格、日期、人數
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("NT\$ ${item.price}", style: TextStyle(color: Colors.grey[600])),
                                    
                                    // 判斷是否為預約類型，顯示橘色標籤
                                    if (item.type == ItemType.reservation && item.bookingDate != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.event_available, size: 14, color: Colors.orange),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${item.bookingDate} (${item.peopleCount}位)",
                                                style: const TextStyle(
                                                  color: Colors.orange, 
                                                  fontSize: 11, 
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                
                                // 數量調整按鈕
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_circle_outline, color: Colors.grey[400]), 
                                      onPressed: () => cart.updateQuantity(item.id, -1)
                                    ),
                                    Text("${item.quantity}", style: const TextStyle(fontSize: 16)),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline, color: Colors.purple), 
                                      onPressed: () => cart.updateQuantity(item.id, 1)
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                    ),
                    
                    // 底部結帳區
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SafeArea(
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: cart.items.isEmpty ? null : () {
                              // 結帳邏輯
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.purple, 
                              padding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                            ),
                            child: Text(
                              "結帳 (NT\$ ${cart.totalAmount})",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}