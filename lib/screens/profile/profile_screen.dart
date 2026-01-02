// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/waterfall_item.dart';
import '../../widgets/waterfall_feed.dart';
import '../../widgets/responsive_container.dart';
import 'edit_profile_screen.dart';
import '../merchant/merchant_dashboard_screen.dart';
import '../shop/buyer_order_list_screen.dart';
// [新增] 引入聊天室
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
  // [修改] 移除 late，改為在 build 中動態獲取或使用傳入值
  String _bio = "歡迎來到我的試衣間 ✨ 分享日常穿搭與美好生活";
  bool _isFollowing = false; // 追蹤狀態 (僅看別人時使用)

  // 假資料：作品集
  static const List<WaterfallItem> _userWorks = [
    WaterfallItem(id: '1', image: 'https://images.unsplash.com/photo-1737214475335-8ed64d91f473?w=600', title: '我的作品集', authorName: 'Me', authorAvatar: '', likes: 1234, aspectRatio: 1.3),
    WaterfallItem(id: '2', image: 'https://images.unsplash.com/photo-1544580353-4a24b9074137?w=600', title: '日常隨拍', authorName: 'Me', authorAvatar: '', likes: 2341, aspectRatio: 1.5),
  ];

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
        // 這裡實際應該是呼叫 AuthProvider 更新 user 資料
        // _name = result['name']; 
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
    // 判斷是否為「看自己」：如果沒有傳 userId，或者傳入的 ID 等於登入者 ID
    // 這裡簡化判斷：只要 widget.userId 為 null，就當作是從 Tab 進來的「看自己」
    final bool isMe = widget.userId == null;

    // [核心修正] 資料來源邏輯
    // 如果是看別人 (isMe == false)，顯示傳入的 userName/userAvatar
    // 如果是看自己 (isMe == true)，顯示 AuthProvider 裡的 user 資料 (或是預設值)
    // 這裡為了簡化，先寫死預設值，實際專案請從 AuthProvider 拿
    final String displayName = isMe ? "推推用戶" : (widget.userName ?? "未知用戶");
    final String displayAvatar = isMe 
        ? "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100" 
        : (widget.userAvatar ?? "https://via.placeholder.com/150");

    // 監聽商家狀態 (只有看自己時，才需要判斷自己是不是商家)
    final isMerchant = isMe && context.watch<AuthProvider>().isMerchant;

    return Scaffold(
      backgroundColor: Colors.grey[50],

      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // 如果是看別人，顯示返回鍵；看自己則不需要
        leading: isMe ? null : const BackButton(color: Colors.black),
        title: ResponsiveContainer(
          child: Text(isMe ? "Me" : displayName, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined, color: Colors.black)),
          // 只有看自己時，才顯示設定按鈕
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
                      // 只有看自己且是商家時，才顯示 Merchant 標籤 (或者看別人的商家頁面時也要顯示，這裡暫時只做看自己)
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

                  // --- 按鈕區 (核心差異) ---
                  if (isMe) ...[
                    // [看自己] 顯示功能入口

                    // 我的訂單
                    _buildMenuRow(
                      icon: Icons.receipt_long_outlined,
                      color: Colors.blue,
                      title: "我的訂單",
                      onTap: _navigateToMyOrders // 使用提取出的方法
                    ),
                    const SizedBox(height: 12),

                    // 商家中心 (如果是商家)
                    if (isMerchant)
                      _buildMenuRow(
                        icon: Icons.storefront,
                        color: Colors.purple,
                        title: "商家中心",
                        subtitle: "管理商品與營收",
                        onTap: _navigateToMerchantCenter // 使用提取出的方法
                      ),

                    const SizedBox(height: 20),
                    // 編輯個人檔案按鈕
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _navigateToEditProfile(displayName, displayAvatar), // 傳入當前資料
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black, side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                        ),
                        child: const Text("Edit Profile"),
                      ),
                    ),

                  ] else ...[
                    // [看別人] 顯示互動按鈕 (追蹤 & 聊聊)
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
                            // 跳轉到聊天室
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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