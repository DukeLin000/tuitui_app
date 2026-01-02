// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isMerchant = false; // [新增] 商家身分狀態

  bool get isLoggedIn => _isLoggedIn;
  bool get isMerchant => _isMerchant; // [新增] Getter

  // 執行登入
  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  // 執行登出
  void logout() {
    _isLoggedIn = false;
    _isMerchant = false; // [新增] 登出時重置商家狀態
    notifyListeners();
  }

  // [新增] 切換商家模式
  void toggleMerchantMode() {
    _isMerchant = !_isMerchant;
    notifyListeners();
  }
}