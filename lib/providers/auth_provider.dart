// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isMerchant = false; // 商家身分狀態

  // [新增] 模擬的用戶資料 (真實情況會從後端 API 獲取)
  // 這裡預設填入一些假資料，讓 App 一打開不會是空的
  final Map<String, String> _userProfile = {
    'name': '推推用戶',
    'bio': '歡迎來到我的試衣間 ✨ 分享日常穿搭與美好生活',
    'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
    'email': 'user@tuitui.com',
  };

  bool get isLoggedIn => _isLoggedIn;
  bool get isMerchant => _isMerchant;
  Map<String, String> get userProfile => _userProfile; // [新增] 讓 UI 可以讀取用戶資料

  // [修改] 執行登入 (改為非同步，模擬網路請求)
  Future<bool> login(String email, String password) async {
    // 模擬網路延遲 1 秒
    await Future.delayed(const Duration(seconds: 1));
    
    // 這裡可以加入簡單的驗證邏輯，目前先無條件成功
    if (email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      // 如果是用特定帳號登入，也可以順便更新 email 顯示
      _userProfile['email'] = email; 
      notifyListeners();
      return true;
    }
    return false;
  }

  // [新增] 註冊帳號
  Future<bool> signUp(String email, String password, String name) async {
    // 模擬網路延遲
    await Future.delayed(const Duration(seconds: 1));
    
    // 註冊成功後的邏輯：
    // 1. 自動設為已登入
    _isLoggedIn = true;
    // 2. 更新用戶資料為註冊時填寫的內容
    _userProfile['email'] = email;
    _userProfile['name'] = name;
    // 3. 頭像暫時維持預設，或設為空
    
    notifyListeners();
    return true;
  }

  // [新增] 忘記密碼
  Future<void> resetPassword(String email) async {
    // 模擬發送 API 請求
    await Future.delayed(const Duration(seconds: 1));
    debugPrint("重設密碼信件已發送至: $email");
  }

  // [新增] 更新個人資料 (即時連動 UI)
  Future<void> updateProfile({String? name, String? bio, String? avatar}) async {
    // 模擬上傳資料的延遲
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (name != null) _userProfile['name'] = name;
    if (bio != null) _userProfile['bio'] = bio;
    if (avatar != null) _userProfile['avatar'] = avatar;
    
    // 關鍵：通知所有監聽者 (ProfileScreen) 更新畫面
    notifyListeners(); 
  }

  // 執行登出
  void logout() {
    _isLoggedIn = false;
    _isMerchant = false; // 登出時重置商家狀態
    
    // 可選：登出時是否要重置用戶資料回預設值？
    // _userProfile['name'] = '推推用戶'; 
    
    notifyListeners();
  }

  // 切換商家模式
  void toggleMerchantMode() {
    _isMerchant = !_isMerchant;
    notifyListeners();
  }
}