// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart'; // [新增] 引入 PostProvider
import '../../models/waterfall_item.dart';
import '../../widgets/waterfall_feed.dart';
import '../../widgets/responsive_container.dart';
import 'edit_profile_screen.dart';
import '../merchant/merchant_dashboard_screen.dart';
import '../shop/buyer_order_list_screen.dart';
import '../chat/chat_room_screen.dart';

class ProfileScreen extends StatefulWidget {
  // 如果傳入 null，代表是用戶看自己 (Tab模式)
  // 如果有傳入 userId，代表是看別人的公開頁
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
  // 這些之後應該從 API 獲取
  String _bio = "歡迎來到我的試衣間 ✨ 分享日常穿搭與美好生活";
  bool _isFollowing = false; // 追蹤狀態 (僅看別人時使用)

  // [移除] static const List<WaterfallItem> _userWorks ... (改用 Provider)

  // 編輯頁面跳轉
  void _navigateToEditProfile(String currentName, String currentAvatar) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentName: currentName,
          currentBio: _bio,
          currentAvatar: currentAvatar,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
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

  // 跳轉到我的訂單
  void _navigateToMyOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BuyerOrderListScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    // 判斷是否為「看自己」
    final bool isMe = widget.userId == null;

    final String displayName = isMe ? "推推用戶" : (widget.userName ?? "未知用戶");
    final String displayAvatar = isMe 
        ? "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100" 
        : (widget.userAvatar ?? "https://via.placeholder.com/150");

    // 監聽商家狀態
    final isMerchant = isMe && context.watch<AuthProvider>().isMerchant;

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined, color: Colors.black)),
          if (isMe)
            IconButton(onPressed: widget.onSettingsTap, icon: const Icon(Icons.settings_outlined, color: Colors.black))
          else
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz, color: Colors.black)),
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
                  Text(_bio, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 20),

                  // --- 按鈕區 ---
                  if (isMe) ...[
                    // [看自己]
                    _buildMenuRow(
                      icon: Icons.receipt_long_outlined,
                      color: Colors.blue,
                      title: "我的訂單",
                      onTap: _navigateToMyOrders
                    ),
                    const SizedBox(height: 12),

                    if (isMerchant)
                      _buildMenuRow(
                        icon: Icons.storefront,
                        color: Colors.purple,
                        title: "商家中心",
                        subtitle: "管理商品與營收",
                        onTap: _navigateToMerchantCenter
                      ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _navigateToEditProfile(displayName, displayAvatar),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black, side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                        ),
                        child: const Text("Edit Profile"),
                      ),
                    ),

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
                  // Tab 切換
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
                  
                  // [核心修改] 使用 Consumer 獲取動態作品集
                  Consumer<PostProvider>(
                    builder: (context, postProvider, child) {
                      // 過濾邏輯：
                      // 如果是看自己 (isMe)，顯示作者是 '我 (Me)' 的貼文 (對應 CreatePostScreen 發布時的名稱)
                      // 如果是看別人，顯示作者名稱符合的貼文
                      final myPosts = postProvider.discoveryItems.where((item) {
                        if (isMe) {
                          // [注意] 這裡要跟 CreatePostScreen 裡的 authorName 對應
                          // 為了相容性，這裡判斷 '我 (Me)' 或 'Me'
                          return item.authorName == '我 (Me)' || item.authorName == 'Me';
                        } else {
                          // 比對 userName 或 userId (視您的資料而定)
                          // 這裡的邏輯是：只要 authorName 跟傳進來的 userName 一樣就顯示
                          return item.authorName == widget.userName || item.authorName == widget.userId;
                        }
                      }).toList();

                      // 如果沒有內容，可以顯示空狀態
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

  // 輔助方法：建立選單行
  Widget _buildMenuRow({required IconData icon, required Color color, required String title, String? subtitle, required VoidCallback onTap}) {
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
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