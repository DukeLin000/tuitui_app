// lib/screens/main/main_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart'; 
import '../../widgets/map_view_overlay.dart';
import '../../widgets/cart_overlay.dart';
import '../../config/app_config.dart'; // [必要] 確保引入設定檔

// 引入頁面
import 'home_screen.dart';
import '../market/market_screen.dart';
import 'create_post_screen.dart';
import '../profile/profile_screen.dart';
import '../profile/edit_profile_screen.dart'; // [新增] 引入編輯個人資料頁面
import '../chat/chat_tab_screen.dart';
import '../auth/login_screen.dart'; 

// ---------------------------------------------------------------------------
// 設定頁面
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
                // [修改] 移除了 leading ICON (Icons.person_outline)
                title: const Text("個人資料"),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                // [修改] 連結到編輯個人資料頁面
                onTap: () async {
                  // 1. 處理生日資料型別轉換 (String/DateTime 兼容)
                  DateTime? birthDate;
                  final rawDate = auth.userProfile['birthday'];
                  if (rawDate is DateTime) {
                    birthDate = rawDate;
                  } else if (rawDate is String) {
                    birthDate = DateTime.tryParse(rawDate);
                  }

                  // 2. 跳轉到編輯頁面
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        currentName: auth.userProfile['name'] ?? "",
                        currentBio: auth.userProfile['bio'] ?? "",
                        currentAvatar: auth.userProfile['avatar'] ?? "",
                        currentGender: auth.userProfile['gender'],
                        currentBirthday: birthDate,
                        currentRegion: auth.userProfile['region'],
                      ),
                    ),
                  );

                  // 3. 如果有回傳資料，更新 Provider
                  if (result != null && result is Map<String, dynamic>) {
                    auth.updateProfile(
                      name: result['name'],
                      bio: result['bio'],
                      avatar: result['avatar'],
                      gender: result['gender'],
                      birthday: result['birthday'],
                      region: result['region'],
                    );
                  }
                },
              ),
              const Divider(height: 1),
              
              // [核心修正] 只有在開啟電商功能時，才顯示商家模式切換
              if (AppConfig.enableCommerce) ...[
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
                    auth.toggleMerchant();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(value ? "歡迎使用商家中心！請至個人頁查看。" : "已切換回個人模式"),
                        duration: const Duration(seconds: 2),
                      )
                    );
                  },
                ),
                const Divider(height: 1),
              ],
              
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
// 主畫面 (保持不變)
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

  // 定義導航項目結構
  late final List<Map<String, dynamic>> _navItems;

  @override
  void initState() {
    super.initState();
    
    // 定義各個頁面元件
    
    // 1. 首頁 (傳入打開地圖的動作)
    final homeItem = {
      'page': HomeScreen(
        onOpenMap: () => setState(() => _showMapView = true),
      ),
      'item': const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '推推'),
      'requireAuth': false,
    };

    // 2. 市集 (包含購物車圖示邏輯)
    final marketItem = {
      'page': MarketScreen(
        onOpenCart: () => setState(() => _showCart = true),
        onOpenMap: () => setState(() => _showMapView = true),
      ),
      'item': BottomNavigationBarItem(
        icon: Consumer<CartProvider>(
          builder: (context, cart, child) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.storefront_outlined),
                if (cart.itemCount > 0)
                  Positioned(
                    right: -2, top: -2,
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
      'requireAuth': false,
    };

    // 3. 發文
    final createPostItem = {
      'page': const CreatePostScreen(),
      'item': const BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline, size: 32), 
        activeIcon: Icon(Icons.add_circle, size: 32), 
        label: '發佈' 
      ),
      'requireAuth': true,
    };

    // 4. 聊天
    final chatItem = {
      'page': const ChatTabScreen(),
      'item': const BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: '聊天'),
      'requireAuth': true,
    };

    // 5. 個人
    final profileItem = {
      'page': ProfileScreen(
        onSettingsTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
      ), 
      'item': const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: '個人'),
      'requireAuth': false,
    };

    // 根據開關決定排列順序
    if (AppConfig.enableCommerce) {
      // 開啟電商：標準 5 欄位
      _navItems = [
        homeItem,
        marketItem,
        createPostItem,
        chatItem,
        profileItem,
      ];
    } else {
      // 關閉電商：平衡 4 欄位 (IG 風格)
      _navItems = [
        homeItem,
        chatItem,       
        createPostItem, 
        profileItem,
      ];
    }
  }

  void _onTabTapped(int index) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    // 動態判斷是否需要登入
    final targetItem = _navItems[index];
    final bool requireAuth = targetItem['requireAuth'] ?? false;

    if (requireAuth && !auth.isLoggedIn) {
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
    final Widget bodyContent = _navItems[_selectedIndex]['page'] as Widget;

    return Stack(
      children: [
        Scaffold(
          appBar: null, 
          body: bodyContent,
          
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed, 
            backgroundColor: Colors.white,
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            items: _navItems.map((e) => e['item'] as BottomNavigationBarItem).toList(),
          ),
        ),

        // --- 全域覆蓋層 (Overlays) ---
        
        // 1. 地圖覆蓋層
        if (_showMapView) 
          Positioned.fill(child: MapViewOverlay(onClose: () => setState(() => _showMapView = false))),
        
        // 2. 購物車覆蓋層
        if (AppConfig.enableCommerce && _showCart) 
          Positioned.fill(
            child: CartOverlay(
              onClose: () => setState(() => _showCart = false), 
            )
          ),
      ],
    );
  }
}