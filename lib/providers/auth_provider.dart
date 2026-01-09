// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isMerchant = false; // 商家身分狀態

  // [修改] 改為 dynamic 以支援 DateTime (生日) 等非字串資料
  final Map<String, dynamic> _userProfile = {
    'name': '推推用戶',
    'bio': '歡迎來到我的試衣間 ✨ 分享日常穿搭與美好生活',
    'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
    'email': 'user@tuitui.com',
    // 預設值，避免 UI 讀取 null 報錯
    'gender': '保密',
    'birthday': null,
    'region': '台灣 台北',
  };

  bool get isLoggedIn => _isLoggedIn;
  bool get isMerchant => _isMerchant;
  
  // [修改] 回傳 dynamic Map
  Map<String, dynamic> get userProfile => _userProfile; 

  // [修改] 執行登入
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      _userProfile['email'] = email; 
      notifyListeners();
      return true;
    }
    return false;
  }

  // [新增] 註冊帳號
  Future<bool> signUp(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 1));
    
    _isLoggedIn = true;
    _userProfile['email'] = email;
    _userProfile['name'] = name;
    
    notifyListeners();
    return true;
  }

  // [新增] 忘記密碼
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint("重設密碼信件已發送至: $email");
  }

  // [修改] 更新個人資料 (擴充支援性別、生日、地區)
  Future<void> updateProfile({
    String? name, 
    String? bio, 
    String? avatar,
    String? gender,
    DateTime? birthday,
    String? region,
  }) async {
    // 模擬上傳資料的延遲
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (name != null) _userProfile['name'] = name;
    if (bio != null) _userProfile['bio'] = bio;
    if (avatar != null) _userProfile['avatar'] = avatar;
    
    // 新增欄位
    if (gender != null) _userProfile['gender'] = gender;
    if (birthday != null) _userProfile['birthday'] = birthday;
    if (region != null) _userProfile['region'] = region;
    
    notifyListeners(); 
  }

  // 執行登出
  void logout() {
    _isLoggedIn = false;
    _isMerchant = false; // 登出時重置商家狀態
    notifyListeners();
  }

  // [保留] 原有的方法名稱
  void toggleMerchantMode() {
    _isMerchant = !_isMerchant;
    notifyListeners();
  }

  // [新增] 這是 MainScreen 呼叫的方法名稱 (功能與上面相同)
  void toggleMerchant() {
    _isMerchant = !_isMerchant;
    notifyListeners();
  }
}