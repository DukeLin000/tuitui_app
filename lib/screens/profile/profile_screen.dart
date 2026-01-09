// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart';
import '../../models/waterfall_item.dart';
import '../../widgets/waterfall_feed.dart';
import '../../widgets/responsive_container.dart';
import '../../config/app_config.dart'; 
import 'edit_profile_screen.dart';
import '../merchant/merchant_dashboard_screen.dart';
import '../shop/buyer_order_list_screen.dart';
import '../chat/chat_room_screen.dart';
import '../auth/login_screen.dart'; 

class ProfileScreen extends StatefulWidget {
  final String? userId;
  final String? userName;
  final String? userAvatar;
  final VoidCallback? onSettingsTap; // 只有看自己時才需要

  const ProfileScreen({
    super.key,
    this.userId,
    this.userName,
    this.userAvatar,
    this.onSettingsTap
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // [修正] 不再手動維護 _bio，改為直接使用 AuthProvider 的數據，避免狀態不同步
  // String _bio = "..."; 
  bool _isFollowing = false; 

  // --- [新增功能] 1. QR Code 彈窗 ---
  void _showQRCode(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("我的 QR Code", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 20),
            // 模擬 QR Code 區塊
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!)
              ),
              child: const Center(
                child: Icon(Icons.qr_code_2, size: 150, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 20),
            const Text("掃描此行動條碼來追蹤我", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("關閉", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // --- [新增功能] 2. 分享功能 ---
  void _onShareTap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("已呼叫系統分享 (模擬): https://tuitui.app/u/profile"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // --- [新增功能] 3. 更多選項 (查看他人時) ---
  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text("複製個人檔案連結"),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("連結已複製")));
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text("封鎖此用戶", style: TextStyle(color: Colors.red)),
                onTap: () {
                   Navigator.pop(context);
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("已封鎖用戶")));
                },
              ),
              ListTile(
                leading: const Icon(Icons.report, color: Colors.red),
                title: const Text("檢舉此用戶", style: TextStyle(color: Colors.red)),
                onTap: () {
                   Navigator.pop(context);
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("感謝您的檢舉，我們會盡快處理")));
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // 編輯資料：傳入當前 Bio (雖然這裡用不到了，但保留輔助函式以免未來需要)
  void _navigateToEditProfile(String currentName, String currentBio, String currentAvatar) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentName: currentName,
          currentBio: currentBio,
          currentAvatar: currentAvatar,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      // 更新 AuthProvider
      if (mounted) {
        context.read<AuthProvider>().updateProfile(
          name: result['name'],
          bio: result['bio'],
          avatar: result['avatar'],
        );
      }
    }
  }

  void _navigateToMerchantCenter() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MerchantDashboardScreen())
    );
  }

  void _navigateToMyOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BuyerOrderListScreen())
    );
  }

  // 訪客模式畫面
  Widget _buildGuestView(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("個人檔案", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline, size: 60, color: Colors.purple),
            ),
            const SizedBox(height: 20),
            const Text(
              "登入以查看您的個人檔案",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "管理您的訂單、收藏與個人作品",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text("登入 / 註冊", style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. 獲取 AuthProvider 狀態 (這裡使用 watch 確保狀態變更時重繪)
    final auth = context.watch<AuthProvider>();

    // 2. 判斷是否為「看自己」
    final bool isMe = widget.userId == null;

    // 3. 訪客模式判斷
    if (isMe && !auth.isLoggedIn) {
      return _buildGuestView(context);
    }

    // --- 以下為登入後的正常邏輯 ---

    final String displayName = isMe 
        ? (auth.userProfile['name'] ?? "推推用戶") 
        : (widget.userName ?? "未知用戶");
        
    final String displayAvatar = isMe 
        ? (auth.userProfile['avatar'] ?? "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100")
        : (widget.userAvatar ?? "https://via.placeholder.com/150");

    // [修正] 改為讀取 AuthProvider 的 bio，而非本地變數
    final String displayBio = isMe
        ? (auth.userProfile['bio'] ?? "歡迎來到我的試衣間 ✨ 分享日常穿搭與美好生活")
        : "這個人很懶，什麼都沒寫";

    // 判斷是否顯示商家中心
    final isMerchant = isMe && AppConfig.enableCommerce && auth.isMerchant;

    return Scaffold(
      backgroundColor: Colors.grey[50],

      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: isMe ? null : const BackButton(color: Colors.black),
        title: ResponsiveContainer(
          child: Text(isMe ? "Me" : displayName, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        actions: [
          // [實作] QR Code 按鈕
          IconButton(
            onPressed: () => _showQRCode(context), 
            icon: const Icon(Icons.qr_code, color: Colors.black)
          ),
          // [實作] 分享按鈕
          IconButton(
            onPressed: () => _onShareTap(context), 
            icon: const Icon(Icons.share_outlined, color: Colors.black)
          ),
          // 根據是否為自己顯示不同按鈕
          if (isMe)
            IconButton(
              onPressed: widget.onSettingsTap, 
              icon: const Icon(Icons.settings_outlined, color: Colors.black)
            )
          else
            // [實作] 更多選項 (檢舉/封鎖)
            IconButton(
              onPressed: () => _showMoreOptions(context), 
              icon: const Icon(Icons.more_horiz, color: Colors.black)
            ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          // 1. 用戶資料區塊
          ResponsiveContainer(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(radius: 40, backgroundImage: NetworkImage(displayAvatar)),
                      const SizedBox(width: 24),
                      const Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _ProfileStatItem(count: "18", label: "Following"),
                            _ProfileStatItem(count: "32", label: "Followers"),
                            _ProfileStatItem(count: "128", label: "Like & Save"),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 名字與 Bio
                  Row(
                    children: [
                      Text(displayName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      if (isMerchant) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.purple.withOpacity(0.3))
                          ),
                          child: const Text("Merchant", style: TextStyle(fontSize: 10, color: Colors.purple, fontWeight: FontWeight.bold)),
                        )
                      ]
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(displayBio, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 20),

                  // --- 按鈕區 ---
                  if (isMe) ...[
                    if (AppConfig.enableCommerce) ...[
                      // [核心修正] 移除 icon 參數
                      _buildMenuRow(
                        title: "我的訂單",
                        onTap: _navigateToMyOrders
                      ),
                      const SizedBox(height: 12),

                      if (isMerchant) ...[
                        // [核心修正] 移除 icon 參數
                        _buildMenuRow(
                          title: "商家中心",
                          subtitle: "管理商品與營收",
                          onTap: _navigateToMerchantCenter
                        ),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 8),
                    ],

                    // [重要修正] 移除了 "Edit Profile" 按鈕
                    // 因為編輯功能已經移至設定頁面，這裡不再需要顯示。
                    
                  ] else ...[
                    // [看別人]
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () => setState(() => _isFollowing = !_isFollowing),
                            style: FilledButton.styleFrom(
                              backgroundColor: _isFollowing ? Colors.grey[200] : Colors.purple,
                              foregroundColor: _isFollowing ? Colors.black : Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(_isFollowing ? "已追蹤" : "追蹤"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ChatRoomScreen(userName: displayName)));
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Icon(Icons.chat_bubble_outline, size: 20, color: Colors.black),
                        )
                      ],
                    )
                  ]
                ],
              ),
            ),
          ),

          // 2. 底部作品區
          ResponsiveContainer(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(onPressed: (){}, child: const Text("Notes", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold))),
                        TextButton(onPressed: (){}, child: const Text("Collect", style: TextStyle(color: Colors.grey))),
                        TextButton(onPressed: (){}, child: const Text("Likes", style: TextStyle(color: Colors.grey))),
                      ],
                    ),
                  ),
                  
                  Consumer<PostProvider>(
                    builder: (context, postProvider, child) {
                      final myPosts = postProvider.discoveryItems.where((item) {
                        if (isMe) {
                          return item.authorName == '我 (Me)' || item.authorName == 'Me';
                        } else {
                          return item.authorName == widget.userName || item.authorName == widget.userId;
                        }
                      }).toList();

                      if (myPosts.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Center(child: Text("尚無作品", style: TextStyle(color: Colors.grey))),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: WaterfallFeed(items: myPosts),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // [核心修正] 移除 Icon 參數與實作，只保留文字
  Widget _buildMenuRow({required String title, String? subtitle, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            // 這裡原本有 Icon Container，已完全移除
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _ProfileStatItem extends StatelessWidget {
  final String count;
  final String label;
  const _ProfileStatItem({required this.count, required this.label});
  @override
  Widget build(BuildContext context) => Column(children: [Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))]);
}