// lib/screens/main/main_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart'; 
import '../../widgets/map_view_overlay.dart';
// [刪除] import '../../widgets/user_profile_modal.dart'; 
import '../../widgets/cart_overlay.dart';

// 引入頁面
import 'home_screen.dart';
import '../market/market_screen.dart';
import 'create_post_screen.dart';
import '../profile/profile_screen.dart';
import '../chat/chat_tab_screen.dart';
import '../auth/login_screen.dart'; 

// ---------------------------------------------------------------------------
// 設定頁面 (保持不變)
// ---------------------------------------------------------------------------
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("設置", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text("帳號", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text("個人資料"),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {},
              ),
              const Divider(height: 1),
              
              SwitchListTile(
                secondary: const Icon(Icons.storefront, color: Colors.purple),
                title: const Text("商家模式"),
                subtitle: Text(
                  auth.isMerchant ? "已啟用商家功能" : "切換以管理商品與預約",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                value: auth.isMerchant,
                activeColor: Colors.purple,
                onChanged: (bool value) {
                  auth.toggleMerchantMode();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(value ? "歡迎使用商家中心！請至個人頁查看。" : "已切換回個人模式"),
                      duration: const Duration(seconds: 2),
                    )
                  );
                },
              ),
              const Divider(height: 1),
              
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("登出", style: TextStyle(color: Colors.red)),
                onTap: () {
                  auth.logout();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 主畫面
// ---------------------------------------------------------------------------
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; 
  
  // --- Overlays 狀態 ---
  bool _showMapView = false;
  bool _showCart = false;
  // [刪除] Map<String, dynamic>? _selectedUser; // 不再需要，改由頁面內部跳轉

  void _onTabTapped(int index) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (!auth.isLoggedIn && (index == 2 || index == 3 || index == 4)) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );

      if (result == true) {
        setState(() {
          _selectedIndex = index;
        });
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    
    switch (_selectedIndex) {
      case 0: 
        // [修改] 這裡的 HomeScreen 不再需要 onUserTap 回調
        // 因為點擊頭像的跳轉邏輯已經封裝在 PostCard 和 WaterfallFeed 裡面了
        bodyContent = const HomeScreen(); 
        break;
      case 1: 
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
          // [注意] 只有首頁不再強制顯示 AppBar，因為 HomeScreen 已經改用 NestedScrollView 自帶 AppBar
          // 如果您想要統一，這裡可以把 appBar 設為 null，讓各頁面自己處理
          appBar: null, 
          
          body: bodyContent,
          
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.grey,
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '推推'),
              
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
          
        // [刪除] 個人檔案 Modal，已經被 ProfileScreen 頁面跳轉取代
      ],
    );
  }
}