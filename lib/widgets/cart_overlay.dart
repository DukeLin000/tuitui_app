import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // [新增] 引入 provider
import '../providers/cart_provider.dart'; // [新增] 引入 CartProvider
// import '../models/cart_item.dart'; // 視情況，如果 CartProvider 已匯出可省略，但保留較安全

class CartOverlay extends StatelessWidget {
  final VoidCallback onClose;

  // [重構] 不再需要接收 cartItems, totalAmount 等參數，因為我們可以直接問 Provider
  const CartOverlay({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    // [關鍵] 使用 Consumer<CartProvider> 來監聽購物車變化
    // 當購物車內容改變時，這個 builder 會自動重新執行，更新畫面
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // [使用 Provider 資料] 顯示商品總數
                          Text("購物車 (${cart.itemCount})", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          IconButton(icon: const Icon(Icons.close), onPressed: onClose),
                        ],
                      ),
                    ),
                    Expanded(
                      // [使用 Provider 資料] 檢查是否為空 & 讀取列表
                      child: cart.items.isEmpty 
                        ? const Center(child: Text("購物車是空的"))
                        : ListView.builder(
                            itemCount: cart.items.length,
                            itemBuilder: (context, index) {
                              final item = cart.items[index];
                              return ListTile(
                                leading: Image.network(item.image, width: 50, height: 50, fit: BoxFit.cover),
                                title: Text(item.name),
                                subtitle: Text("NT\$ ${item.price}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // [操作 Provider 方法] 減少數量
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline), 
                                      onPressed: () => cart.updateQuantity(item.id, -1)
                                    ),
                                    Text("${item.quantity}"),
                                    // [操作 Provider 方法] 增加數量
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline), 
                                      onPressed: () => cart.updateQuantity(item.id, 1)
                                    ),
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
                          onPressed: () {
                            // 這裡未來可以加入結帳邏輯，例如跳轉到結帳頁面
                            // Navigator.push(...);
                          },
                          style: FilledButton.styleFrom(backgroundColor: Colors.purple, padding: const EdgeInsets.all(16)),
                          // [使用 Provider 資料] 顯示總金額
                          child: Text("結帳 (NT\$ ${cart.totalAmount})"),
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