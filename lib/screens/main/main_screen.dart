// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart'; // 引入 AuthProvider
import '../../widgets/map_view_overlay.dart';
import '../../widgets/user_profile_modal.dart';
import '../../widgets/cart_overlay.dart';

// 引入頁面
import 'home_screen.dart';
import '../market/market_screen.dart';
import 'create_post_screen.dart';
import '../profile/profile_screen.dart';
import '../chat/chat_tab_screen.dart';
import '../auth/login_screen.dart'; // 引入登入頁面

// ---------------------------------------------------------------------------
// 設定頁面 (修改：加入商家模式切換)
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
      // 使用 Consumer 監聽 AuthProvider 狀態
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
              
              // [核心功能] 商家模式切換開關
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
                  auth.toggleMerchantMode(); // 切換狀態
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
                  Navigator.pop(context); // 登出後關閉設置頁
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
// 主畫面 (保持原有功能)
// ---------------------------------------------------------------------------
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

  // 處理 Tab 點擊的攔截邏輯 (需要登入才能看的頁面)
  void _onTabTapped(int index) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    // 定義哪些 Tab 需要登入才能看 (2: 發布, 3: 聊天, 4: 個人)
    if (!auth.isLoggedIn && (index == 2 || index == 3 || index == 4)) {
      
      // 跳轉到登入頁面，並等待回傳結果
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );

      // 如果登入成功 (result 為 true)，則自動切換到目標 Tab
      if (result == true) {
        setState(() {
          _selectedIndex = index;
        });
      }
    } else {
      // 已經登入，或點擊的是公開頁面 (首頁、市集)，直接切換
      setState(() {
        _selectedIndex = index;
      });
    }
  }

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
          // 傳遞跳轉到設置頁面的回調
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
            onTap: _onTabTapped, // 使用自定義的攔截方法
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.grey,
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '推推'),
              
              // 市集 (帶有購物車紅點)
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