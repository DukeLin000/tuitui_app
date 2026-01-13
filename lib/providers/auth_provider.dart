// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import '../services/api_service.dart'; // 1. 引入 ApiService

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isMerchant = false; // 商家身分狀態

  // [修改] 改為 dynamic 以支援 DateTime (生日) 等非字串資料
  // 這裡保留預設值，當後端回傳資料後會被覆蓋
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

  // [修改] 執行登入 (串接後端)
  Future<bool> login(String email, String password) async {
    // 呼叫 ApiService 的登入方法
    final userData = await ApiService.login(email, password);
    
    if (userData != null) {
      _isLoggedIn = true;
      
      // 將後端回傳的資料 (id, name, avatar, bio, role...) 更新到本地 profile
      _userProfile.addAll(userData);
      
      // 同步商家狀態 (根據後端回傳的 role 判斷)
      if (userData.containsKey('role')) {
        _isMerchant = (userData['role'] == 'merchant');
      }

      notifyListeners();
      return true; // 登入成功
    }
    
    return false; // 登入失敗
  }

  // [新增] 註冊帳號 (串接後端)
  Future<bool> signUp(String email, String password, String name) async {
    // 呼叫 ApiService 的註冊方法
    final userData = await ApiService.register(name, email, password);
    
    if (userData != null) {
      _isLoggedIn = true;
      
      // 將後端回傳的新用戶資料更新到本地
      _userProfile.addAll(userData);
      
      // 新註冊用戶預設通常是 user，但以防萬一還是檢查一下
      if (userData.containsKey('role')) {
        _isMerchant = (userData['role'] == 'merchant');
      }
      
      notifyListeners();
      return true; // 註冊成功
    }
    
    return false; // 註冊失敗
  }

  // [新增] 忘記密碼 (暫時保留模擬，因為後端尚未實作寄信功能)
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint("重設密碼信件已發送至: $email");
  }

  // [修改] 更新個人資料 (暫時保留模擬，因為後端 Update API 尚未開發)
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
    
    // 可選：登出時是否要清空個人資料回到預設值？
    // 目前保留不變，下次登入會被新資料覆蓋
    
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