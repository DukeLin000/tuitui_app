// lib/providers/cart_provider.dart
import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  // 內部私有變數，儲存購物車商品
  final List<CartItem> _items = [];

  // 1. 讀取購物車列表 (唯讀)
  List<CartItem> get items => List.unmodifiable(_items);

  // 2. 取得商品總數
  int get itemCount => _items.length;

  // 3. 計算總金額
  int get totalAmount {
    var total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // 4. 加入購物車邏輯 [修改：支援商品類型、預約時間與人數]
  void addToCart(
    String id, 
    String name, 
    int price, 
    String image, 
    {
      ItemType type = ItemType.product, 
      String? bookingDate,
      int? peopleCount, // [新增] 接收預約人數
    }
  ) {
    if (type == ItemType.product) {
      // 一般商品：檢查 ID 是否存在且類型相同，存在則數量 +1
      final index = _items.indexWhere((item) => item.id == id && item.type == ItemType.product);
      
      if (index >= 0) {
        _items[index].quantity += 1;
      } else {
        _items.add(CartItem(
          id: id, 
          name: name, 
          price: price, 
          image: image, 
          quantity: 1,
          type: type,
        ));
      }
    } else {
      // 預約服務：視為獨立項目
      // 生成 Unique ID 避免相同店家的不同預約在刪除時發生衝突
      final uniqueId = "${id}_${DateTime.now().millisecondsSinceEpoch}";
      
      _items.add(CartItem(
        id: uniqueId, 
        name: name, 
        price: price, 
        image: image, 
        quantity: 1,
        type: type,
        bookingDate: bookingDate,
        peopleCount: peopleCount, // [新增] 存入預約人數
      ));
    }
    
    // 通知 UI 更新
    notifyListeners();
  }

  // 5. 更新數量 (增加或減少)
  void updateQuantity(String id, int delta) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity += delta;
      
      // 如果數量變為 0 或更少，將商品從購物車移除
      if (_items[index].quantity <= 0) {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // 6. 清空購物車
  void clear() {
    _items.clear();
    notifyListeners();
  }
}