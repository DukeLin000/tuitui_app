// lib/providers/cart_provider.dart
import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  // 內部私有變數，儲存購物車商品
  final List<CartItem> _items = [];

  // 1. 讀取購物車列表 (唯讀)
  List<CartItem> get items => List.unmodifiable(_items);

  // 2. 取得商品總數 (清單內的項目種類數量)
  int get itemCount => _items.length;
  
  // [新增] 取得總金額 (Getter for totalPrice) - 修正您 checkout_screen 可能用到的屬性名稱
  int get totalPrice => totalAmount;

  // 3. 計算總金額 [修改：僅計算被勾選的項目]
  int get totalAmount {
    var total = 0;
    for (var item in _items) {
      if (item.isSelected) {
        total += item.price * item.quantity;
      }
    }
    return total;
  }

  // [新增] 判斷是否全部選取
  bool get isAllSelected => _items.isNotEmpty && _items.every((item) => item.isSelected);

  // [新增] 切換單一商品勾選狀態
  void toggleItemSelection(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].isSelected = !_items[index].isSelected;
      notifyListeners();
    }
  }

  // [新增] 全選或取消全選
  void toggleAllSelection(bool selected) {
    for (var item in _items) {
      item.isSelected = selected;
    }
    notifyListeners();
  }

  // [新增] 這是您缺少的關鍵方法！接收 CartItem 物件
  void addItem(CartItem item) {
    // 簡單判斷：如果是實體商品且 ID 相同則合併數量 (視您的 ID 生成邏輯而定)
    if (item.type == ItemType.product) {
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index >= 0) {
        _items[index].quantity += item.quantity;
        _items[index].isSelected = true; // 重新加入時自動勾選
      } else {
        _items.add(item);
      }
    } else {
      // 預約類商品直接加入
      _items.add(item);
    }
    notifyListeners();
  }

  // 4. 原有的加入購物車邏輯 (保留)
  void addToCart(
    String id, 
    String name, 
    int price, 
    String image, 
    {
      ItemType type = ItemType.product, 
      String? bookingDate,
      int? peopleCount,
    }
  ) {
    if (type == ItemType.product) {
      final index = _items.indexWhere((item) => item.id == id && item.type == ItemType.product);
      
      if (index >= 0) {
        _items[index].quantity += 1;
        _items[index].isSelected = true;
      } else {
        _items.add(CartItem(
          id: id, 
          name: name, 
          price: price, 
          image: image, 
          quantity: 1,
          type: type,
          isSelected: true,
        ));
      }
    } else {
      final uniqueId = "${id}_${DateTime.now().millisecondsSinceEpoch}";
      _items.add(CartItem(
        id: uniqueId, 
        name: name, 
        price: price, 
        image: image, 
        quantity: 1,
        type: type,
        bookingDate: bookingDate,
        peopleCount: peopleCount,
        isSelected: true,
      ));
    }
    notifyListeners();
  }

  // 5. 更新數量 (增加或減少)
  void updateQuantity(String id, int delta) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity += delta;
      
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