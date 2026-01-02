// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../../providers/auth_provider.dart'; 
import '../../models/waterfall_item.dart';
import '../../widgets/waterfall_feed.dart';
import '../../widgets/responsive_container.dart';
import 'edit_profile_screen.dart';
import '../merchant/merchant_dashboard_screen.dart'; 
// [新增] 引入買家訂單頁面
import '../shop/buyer_order_list_screen.dart'; 

class ProfileScreen extends StatefulWidget {
  final VoidCallback onSettingsTap;

  const ProfileScreen({super.key, required this.onSettingsTap});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 用戶資料狀態
  String _name = "推推用戶";
  String _bio = "歡迎來到我的試衣間 ✨ 分享日常穿搭與美好生活";
  final String _avatar = "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100";

  // 假資料：我的作品
  static const List<WaterfallItem> _userWorks = [
    WaterfallItem(id: '1', image: 'https://images.unsplash.com/photo-1737214475335-8ed64d91f473?w=600', title: '我的作品集', authorName: 'Me', authorAvatar: '', likes: 1234, aspectRatio: 1.3),
    WaterfallItem(id: '2', image: 'https://images.unsplash.com/photo-1544580353-4a24b9074137?w=600', title: '日常隨拍', authorName: 'Me', authorAvatar: '', likes: 2341, aspectRatio: 1.5),
  ];

  // 編輯頁面跳轉
  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentName: _name,
          currentBio: _bio,
          currentAvatar: _avatar,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _name = result['name'];
        _bio = result['bio'];
      });
    }
  }

  // 跳轉到商家中心
  void _navigateToMerchantCenter() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const MerchantDashboardScreen())
    );
  }

  // [新增] 跳轉到我的訂單
  void _navigateToMyOrders() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const BuyerOrderListScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    // 監聽商家狀態
    final isMerchant = context.watch<AuthProvider>().isMerchant;

    return Scaffold(
      backgroundColor: Colors.grey[50], 
      
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const ResponsiveContainer(
          child: Text("Me", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined, color: Colors.black)),
          IconButton(onPressed: widget.onSettingsTap, icon: const Icon(Icons.settings_outlined, color: Colors.black)),
        ],
      ),
      
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          // 1. 用戶資料區塊 (Profile Info)
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
                      CircleAvatar(radius: 40, backgroundImage: NetworkImage(_avatar)),
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
                  
                  // 名字區域
                  Row(
                    children: [
                      Text(_name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                  Text(_bio, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  
                  const SizedBox(height: 24),

                  // --- 功能入口區 ---

                  // [新增] 我的訂單入口 (所有人可見)
                  GestureDetector(
                    onTap: _navigateToMyOrders,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle),
                            child: const Icon(Icons.receipt_long_outlined, color: Colors.blue, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text("我的訂單", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  // 商家中心入口卡片 (僅商家可見)
                  if (isMerchant) ...[
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _navigateToMerchantCenter,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.purple[50], shape: BoxShape.circle),
                              child: const Icon(Icons.storefront, color: Colors.purple, size: 20),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("商家中心", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("管理商品、預約與營收數據", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  
                  // Edit Profile 按鈕
                  SizedBox(
                    width: double.infinity, 
                    child: _ProfileActionButton(
                      text: "Edit Profile", 
                      onTap: _navigateToEditProfile, 
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 2. 底部作品區 (Works Tab & Feed)
          ResponsiveContainer(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
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
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), 
                    child: WaterfallFeed(items: _userWorks),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// --- 私有輔助組件 ---
class _ProfileStatItem extends StatelessWidget {
  final String count;
  final String label;
  const _ProfileStatItem({required this.count, required this.label});
  @override
  Widget build(BuildContext context) => Column(children: [Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey))]);
}

class _ProfileActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const _ProfileActionButton({required this.text, this.onTap});
  
  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onTap ?? () {}, 
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.black, 
      side: BorderSide(color: Colors.grey[300]!), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), 
      padding: const EdgeInsets.symmetric(vertical: 12)
    ), 
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold))
  );
}