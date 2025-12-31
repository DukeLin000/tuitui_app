// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  // 執行登入
  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  // 執行登出
  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}