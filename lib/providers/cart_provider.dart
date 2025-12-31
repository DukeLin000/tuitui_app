import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  // 內部私有變數，儲存購物車商品
  final List<CartItem> _items = [];

  // 1. 讀取購物車列表 (唯讀)
  List<CartItem> get items => List.unmodifiable(_items);

  // 2. 取得商品總數 (用於 TabBar 紅點或購物車標題)
  int get itemCount => _items.length;

  // 3. 計算總金額
  int get totalAmount {
    var total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // 4. 加入購物車邏輯
  void addToCart(String id, String name, int price, String image) {
    // 檢查商品是否已存在
    final index = _items.indexWhere((item) => item.id == id);
    
    if (index >= 0) {
      // 如果已存在，數量 +1
      _items[index].quantity += 1;
    } else {
      // 如果不存在，新增一筆
      _items.add(CartItem(
        id: id, 
        name: name, 
        price: price, 
        image: image, 
        quantity: 1
      ));
    }
    
    // 關鍵：通知所有監聽者 (UI) 更新畫面
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

  // 6. 清空購物車 (例如結帳後)
  void clear() {
    _items.clear();
    notifyListeners();
  }
}