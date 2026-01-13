// lib/services/api_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart'; // [新增] 用於判斷平台 (kIsWeb)
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/cart_item.dart';

class ApiService {
  // 💡 [修改] 自動判斷連線網址
  // 透過 getter 動態回傳適合當前平台的 IP
  static String get baseUrl {
    if (kIsWeb) {
      // Web 瀏覽器: 使用 localhost
      return 'http://localhost:8080/api';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Android 模擬器: 使用 10.0.2.2
      return 'http://10.0.2.2:8080/api';
    } else {
      // iOS 模擬器或電腦版 App: 使用 localhost
      return 'http://localhost:8080/api';
    }
  }

  // ==========================================
  // 🔐 會員驗證 (Auth) 相關 API
  // ==========================================

  // 1. 登入 (POST /api/auth/login)
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'), // 對應後端 UserController
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // 登入成功，回傳後端的 User DTO
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        print('Login Failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Login Network Error: $e');
      return null;
    }
  }

  // 2. 註冊 (POST /api/auth/register)
  static Future<Map<String, dynamic>?> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'), // 對應後端 UserController
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,       // 對應後端的 payload.get("name")
          'email': email,     // 對應後端的 payload.get("email")
          'password': password, // 對應後端的 payload.get("password")
        }),
      );

      if (response.statusCode == 200) {
        print('Register Success');
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        print('Register Failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Register Network Error: $e');
      return null;
    }
  }

  // ==========================================
  // 📌 貼文 (Social) 相關 API
  // ==========================================

  static Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'));
      if (response.statusCode == 200) {
        // 解決中文亂碼: utf8.decode
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        print('Server Error (fetchPosts): ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Network Error (fetchPosts): $e');
      return []; 
    }
  }

  static Future<bool> createPost(String userId, String content) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'content': content,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Create Post Error: $e');
      return false;
    }
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
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/commerce/cart'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'productId': productId,
          'quantity': quantity
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Add to Cart Error: $e');
      return false;
    }
  }
}