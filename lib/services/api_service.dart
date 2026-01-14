// lib/services/api_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart'; // 用於判斷平台 (kIsWeb)
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/cart_item.dart';
import '../models/waterfall_item.dart'; // [新增] 為了 fetchProducts

class ApiService {
  // 💡 自動判斷連線網址
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080/api';
    } else {
      return 'http://localhost:8080/api';
    }
  }

  // ==========================================
  // 🛠️ 輔助方法 (Helper Methods)
  // ==========================================
  
  // 統一處理 GET 請求
  static Future<dynamic> _get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'));
      if (response.statusCode == 200) {
        // 解決中文亂碼
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        print('Server Error ($endpoint): ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Network Error ($endpoint): $e');
      return [];
    }
  }

  // 統一處理 POST 請求
  static Future<bool> _post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Network Error ($endpoint): $e');
      return false;
    }
  }

  // ==========================================
  // 🔐 會員驗證 (Auth) 相關 API
  // ==========================================

  // 1. 登入
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  // 2. 註冊
  static Future<Map<String, dynamic>?> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      print('Register Error: $e');
      return null;
    }
  }

  // ==========================================
  // 📌 貼文 (Social) 相關 API
  // ==========================================

  static Future<List<Post>> fetchPosts() async {
    final data = await _get('/posts');
    if (data is List) {
      return data.map((json) => Post.fromJson(json)).toList();
    }
    return [];
  }

  static Future<bool> createPost(String userId, String content) async {
    return _post('/posts', {'userId': userId, 'content': content});
  }

  // ==========================================
  // 💬 聊天 (Chat) 相關 API - [新增與修改]
  // ==========================================

  // 1. 取得聊天列表
  static Future<List<dynamic>> fetchChatThreads() async {
    // 假設後端有提供 /api/chats
    // 若後端尚未實作，這裡會返回空陣列，不會崩潰
    final data = await _get('/chats');
    return (data is List) ? data : [];
  }

  // 2. 取得特定聊天室的訊息
  static Future<List<dynamic>> fetchMessages(String chatId) async {
    final data = await _get('/chats/$chatId/messages');
    return (data is List) ? data : [];
  }

  // 3. 發送訊息 [修改]：加入 senderId 參數，確保後端能正確識別發送者
  static Future<bool> sendMessage(String chatId, String content, String senderId) async {
    return _post('/chats/$chatId/messages', {
      'content': content,
      'senderId': senderId,
    });
  }

  // 4. [新增] 建立或取得聊天室 (從個人頁私訊用)
  static Future<String?> createChat(String targetUserId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chats'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'targetUserId': targetUserId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['id'].toString(); // 回傳聊天室 ID (Chat ID)
      } else {
        print('Create Chat Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Create Chat Network Error: $e');
    }
    return null;
  }

  // ==========================================
  // 🛍️ 商品 (Market) 相關 API - [新增]
  // ==========================================

  // [新增] 取得商品列表 (GET /api/products)
  static Future<List<WaterfallItem>> fetchProducts() async {
    final data = await _get('/products');
    if (data is List) {
      return data.map((json) {
        return WaterfallItem(
          id: json['id'].toString(),
          userId: json['userId']?.toString() ?? '', // 預防 null
          image: json['coverUrl'] ?? 'https://via.placeholder.com/300',
          title: json['name'] ?? '無標題',
          authorName: json['merchantName'] ?? '推推商家',
          authorAvatar: 'https://cdn-icons-png.flaticon.com/512/1995/1995515.png',
          likes: 0,
          aspectRatio: 1.0,
          price: (json['price'] as num?)?.toInt(),
          type: ItemType.product,
          isMerchant: true,
        );
      }).toList();
    }
    return [];
  }

  // ==========================================
  // 🛒 購物車 (Commerce) 相關 API
  // ==========================================

  static Future<List<CartItem>> fetchCart(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/commerce/cart/$userId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['items'] != null) {
          final List<dynamic> itemsJson = data['items'];
          return itemsJson.map((json) => CartItem.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Fetch Cart Error: $e');
      return [];
    }
  }

  static Future<bool> addToCart(String userId, String productId, int quantity) async {
    return _post('/commerce/cart', {
      'userId': userId,
      'productId': productId,
      'quantity': quantity
    });
  }
}