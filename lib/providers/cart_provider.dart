// lib/providers/cart_provider.dart
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/api_service.dart'; // [新增] 引入 API 服務

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  bool isLoading = false;
  
  // [新增] 暫時寫死的測試用戶 ID (之後需串接 AuthProvider)
  final String _testUserId = "user_001"; 

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  int get totalPrice => totalAmount;

  int get totalAmount {
    var total = 0;
    for (var item in _items) {
      if (item.isSelected) {
        total += item.price * item.quantity;
      }
    }
    return total;
  }

  bool get isAllSelected => _items.isNotEmpty && _items.every((item) => item.isSelected);

  // [新增] 從後端同步購物車
  Future<void> fetchCart() async {
    isLoading = true;
    notifyListeners();
    
    try {
      // 呼叫 API 取得最新購物車狀態
      _items = await ApiService.fetchCart(_testUserId);
    } catch (e) {
      print("Error fetching cart: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // [修改] 加入購物車 (改為呼叫後端)
  Future<void> addToCart(
    String id, // 這裡傳入的是 productId
    String name, 
    int price, 
    String image, 
    {
      ItemType type = ItemType.product, 
      String? bookingDate,
      int? peopleCount,
    }
  ) async {
    // 1. 呼叫後端 API
    // 注意：後端目前只需要 productId 和 quantity，不需要 name/price (後端會自己查)
    bool success = await ApiService.addToCart(_testUserId, id, 1);
    
    if (success) {
      // 2. 成功後，重新從後端抓取最新資料，確保 ID 和資訊一致
      await fetchCart();
      print("已加入購物車並同步後端");
    } else {
      print("加入購物車失敗");
    }
  }

  // [新增] 為了相容您原本的 addItem 方法 (如果是直接操作物件)
  Future<void> addItem(CartItem item) async {
     // 這裡假設 item.id 是 productId (因為是從 UI 傳來的)
     await addToCart(item.id, item.name, item.price, item.image);
  }

  // --- 以下功能目前維持「本地端操作」，因為後端尚未實作對應 API ---
  
  void updateQuantity(String id, int delta) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity += delta;
      if (_items[index].quantity <= 0) {
        _items.removeAt(index);
      }
      notifyListeners();
    }
    // TODO: 之後後端補上 PATCH /api/commerce/cart/quantity 時再來串接
  }

  void toggleItemSelection(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].isSelected = !_items[index].isSelected;
      notifyListeners();
    }
  }

  void toggleAllSelection(bool selected) {
    for (var item in _items) {
      item.isSelected = selected;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
    // TODO: 之後後端補上 DELETE /api/commerce/cart 時再來串接
  }
}