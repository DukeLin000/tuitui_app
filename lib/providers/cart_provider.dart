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

  // 4. 加入購物車邏輯
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
        // [新增] 如果重複加入，通常蝦皮會自動幫你勾選
        _items[index].isSelected = true;
      } else {
        _items.add(CartItem(
          id: id, 
          name: name, 
          price: price, 
          image: image, 
          quantity: 1,
          type: type,
          isSelected: true, // 預設勾選
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
        isSelected: true, // 預設勾選
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