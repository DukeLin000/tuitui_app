import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
// import '../models/cart_item.dart'; // [移除] 這裡已經不需要 CartItem 模型了

import '../widgets/map_view_overlay.dart';
import '../widgets/user_profile_modal.dart';
import '../widgets/cart_overlay.dart';

// 引入所有拆分出去的頁面
import 'home_screen.dart';
import 'market_screen.dart';
import 'create_post_screen.dart';
import 'profile_screen.dart';
import 'chat_tab_screen.dart';

// 設定頁面
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
  
  // --- Overlays 狀態 ---
  bool _showMapView = false;
  bool _showCart = false;
  Map<String, dynamic>? _selectedUser;

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
        // [修正] 移除了 cartItems 參數
        bodyContent = MarketScreen(
          onOpenCart: () => setState(() => _showCart = true),
          onOpenMap: () => setState(() => _showMapView = true),
        ); 
        break;
      case 2: 
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
          // 只有首頁 (Index 0) 顯示主 AppBar
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
            items: [ // [修改] 這裡移除 const，因為我們要動態讀取 Provider
              const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '推推'),
              
              // [優化] 市集 Tab 加上購物車紅點
              BottomNavigationBarItem(
                icon: Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.storefront_outlined),
                        if (cart.itemCount > 0)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                            ),
                          )
                      ],
                    );
                  },
                ),
                activeIcon: const Icon(Icons.storefront), 
                label: '市集'
              ),
              
              const BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline, size: 32), activeIcon: Icon(Icons.add_circle, size: 32), label: ''),
              const BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: '聊天'),
              const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: '個人'),
            ],
          ),
        ),

        // --- 全域覆蓋層 (Overlays) ---
        
        // 1. 地圖覆蓋層
        if (_showMapView) 
          Positioned.fill(child: MapViewOverlay(onClose: () => setState(() => _showMapView = false))),
        
        // 2. 購物車覆蓋層
        if (_showCart) 
          Positioned.fill(
            child: CartOverlay(
              onClose: () => setState(() => _showCart = false), 
            )
          ),
          
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