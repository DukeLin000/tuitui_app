// lib/widgets/cart_overlay.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';

class CartOverlay extends StatefulWidget {
  final VoidCallback onClose;

  const CartOverlay({
    super.key,
    required this.onClose,
  });

  @override
  State<CartOverlay> createState() => _CartOverlayState();
}

class _CartOverlayState extends State<CartOverlay> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Container(
          color: Colors.black54,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.grey[100], // 整體背景改為淺灰
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: Column(
                  children: [
                    // 1. 頂部標題與關閉按鈕
                    _buildHeader(cart),

                    // 2. 購物項目列表
                    Expanded(
                      child: cart.items.isEmpty
                          ? const Center(child: Text("購物車是空的，去市集逛逛吧！"))
                          : ListView.builder(
                              padding: const EdgeInsets.only(top: 8, bottom: 20),
                              itemCount: cart.items.length,
                              itemBuilder: (context, index) {
                                return _buildCartCard(cart.items[index], cart);
                              },
                            ),
                    ),

                    // 3. 底部蝦皮式導覽列 (連動 Provider)
                    _buildBottomBar(cart),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 頂部組件
  Widget _buildHeader(CartProvider cart) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "購物車 (${cart.itemCount})",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: widget.onClose,
          ),
        ],
      ),
    );
  }

  // 商品卡片組件 (連動勾選狀態)
  Widget _buildCartCard(CartItem item, CartProvider cart) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // [修改] 勾選框：連動單一商品狀態
          Checkbox(
            value: item.isSelected, 
            activeColor: Colors.purple,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onChanged: (val) {
              cart.toggleItemSelection(item.id);
            },
          ),
          
          // 圖片
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // 商品資訊區
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                
                // 預約標籤 (方案 B)
                if (item.type == ItemType.reservation && item.bookingDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "📅 ${item.bookingDate} (${item.peopleCount}人)",
                        style: const TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                
                const SizedBox(height: 12),

                // 價格與數量控制器
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "NT\$ ${item.price}",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    
                    // 蝦皮式數量選擇器
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          _qtyButton(Icons.remove, () => cart.updateQuantity(item.id, -1)),
                          Container(
                            width: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.symmetric(vertical: BorderSide(color: Colors.grey[300]!)),
                            ),
                            child: Text("${item.quantity}", style: const TextStyle(fontSize: 13)),
                          ),
                          _qtyButton(Icons.add, () => cart.updateQuantity(item.id, 1)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 數量控制器小按鈕
  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Icon(icon, size: 14, color: Colors.grey[600]),
      ),
    );
  }

  // [修改] 底部固定的蝦皮結帳導覽列：連動全選與合計
  Widget _buildBottomBar(CartProvider cart) {
    // 獲取目前被選取的商品數量
    final selectedCount = cart.items.where((item) => item.isSelected).length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      child: Row(
        children: [
          // [修改] 全選勾選框：連動 Provider 的 isAllSelected
          Row(
            children: [
              Checkbox(
                value: cart.isAllSelected,
                activeColor: Colors.purple,
                onChanged: (val) {
                  cart.toggleAllSelection(val ?? false);
                },
              ),
              const Text("全選", style: TextStyle(fontSize: 14)),
            ],
          ),
          const Spacer(),
          
          // 金額統計
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text("合計", style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    "NT\$ ${cart.totalAmount}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Text("已享免運優惠", style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
          const SizedBox(width: 12),
          
          // 結帳按鈕 (顯示被勾選的數量)
          SizedBox(
            height: 44,
            width: 110,
            child: FilledButton(
              onPressed: selectedCount == 0 ? null : () {
                // 這裡執行買單邏輯
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              ),
              child: Text(
                "去買單 ($selectedCount)",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}