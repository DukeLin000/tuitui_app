// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/cart_item.dart'; // 記得引入 CartItem

class ApiService {
  // 💡 設定連線網址
  // Android 模擬器請用 'http://10.0.2.2:8080/api'
  // iOS 模擬器或電腦瀏覽器請用 'http://localhost:8080/api'
  // 實機測試請用電腦的區網 IP，例如 'http://192.168.1.100:8080/api'
  static const String baseUrl = 'http://10.0.2.2:8080/api'; 

  // ==========================================
  // 📌 貼文 (Social) 相關 API
  // ==========================================

  // 1. 取得貼文列表 (GET /api/posts)
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

  // 2. 發布貼文 (POST /api/posts)
  static Future<bool> createPost(String userId, String content) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'content': content,
          // 暫時不傳圖片，後端 MVP 還沒處理圖片上傳
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

  // 3. 取得購物車內容 (GET /api/commerce/cart/{userId})
  static Future<List<CartItem>> fetchCart(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/commerce/cart/$userId'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        // 後端回傳格式: { "items": [...], "totalAmount": ... }
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

  // 4. 加入購物車 (POST /api/commerce/cart)
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