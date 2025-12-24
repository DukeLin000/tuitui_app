import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../widgets/map_view_overlay.dart';
import '../widgets/user_profile_modal.dart';
import '../widgets/cart_overlay.dart';

// 引入所有拆分出去的頁面
import 'home_screen.dart';
import 'market_screen.dart';
import 'create_post_screen.dart'; // 新增：引入發布頁面
import 'profile_screen.dart';
import 'chat_tab_screen.dart';

// 設定頁面 (可選：也可以拆出去獨立檔案)
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Center(child: Text("Settings Page")),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // 0:推推, 1:市集, 2:發布, 3:聊天, 4:個人
  
  // --- Overlays 狀態 (只有這些需要全域管理) ---
  bool _showMapView = false;
  bool _showCart = false;
  Map<String, dynamic>? _selectedUser; // 用於顯示個人檔案彈窗

  // --- 全域數據 (例如購物車) ---
  final List<CartItem> _cartItems = [
    CartItem(id: '1', name: '質感針織外套', price: 1280, quantity: 1, image: 'https://images.unsplash.com/photo-1532453288672-3a27e9be9efd?w=200'),
  ];

  // 購物車邏輯：更新數量
  void _updateQuantity(String id, int delta) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index == -1) return;
    int newQuantity = _cartItems[index].quantity + delta;
    if (newQuantity < 1) newQuantity = 1;
    setState(() => _cartItems[index].quantity = newQuantity);
  }

  // 購物車邏輯：計算總金額
  int get _totalAmount => _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    
    // 根據 Tab 選擇顯示哪個獨立模組
    switch (_selectedIndex) {
      case 0: 
        bodyContent = HomeScreen(
          onUserTap: (user) => setState(() => _selectedUser = user),
        ); 
        break;
      case 1: 
        bodyContent = MarketScreen(
          cartItems: _cartItems, 
          onOpenCart: () => setState(() => _showCart = true),
          onOpenMap: () => setState(() => _showMapView = true),
        ); 
        break;
      case 2: 
        // 使用新建立的發布頁面
        bodyContent = const CreatePostScreen(); 
        break;
      case 3: 
        bodyContent = const ChatTabScreen(); 
        break;
      case 4: 
        bodyContent = ProfileScreen(
          onSettingsTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
        ); 
        break;
      default: 
        bodyContent = const Center(child: Text("Error"));
    }

    return Stack(
      children: [
        Scaffold(
          // 只有首頁 (Index 0) 顯示主 AppBar，其他頁面 (市集、發布、個人) 自己處理 AppBar
          appBar: _selectedIndex == 0 ? AppBar(
            title: const Text('TuiTui'),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined))],
          ) : null,
          
          body: bodyContent,
          
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (idx) => setState(() => _selectedIndex = idx),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '推推'),
              BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), activeIcon: Icon(Icons.storefront), label: '市集'),
              // 中間的加號按鈕
              BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline, size: 32), activeIcon: Icon(Icons.add_circle, size: 32), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: '聊天'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: '個人'),
            ],
          ),
        ),

        // --- 全域覆蓋層 (Overlays) ---
        
        // 1. 地圖覆蓋層
        if (_showMapView) 
          Positioned.fill(child: MapViewOverlay(onClose: () => setState(() => _showMapView = false))),
        
        // 2. 購物車覆蓋層
        if (_showCart) 
          Positioned.fill(child: CartOverlay(
            cartItems: _cartItems, 
            onClose: () => setState(() => _showCart = false), 
            onUpdateQuantity: _updateQuantity, 
            totalAmount: _totalAmount
          )),
          
        // 3. 個人檔案覆蓋層 (Modal)
        if (_selectedUser != null) 
          Positioned.fill(child: UserProfileModal(
            user: _selectedUser!, 
            onBack: () => setState(() => _selectedUser = null)
          )),
      ],
    );
  }
}